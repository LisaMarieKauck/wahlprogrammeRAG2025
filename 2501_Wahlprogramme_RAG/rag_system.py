import os
from dotenv import load_dotenv
from langchain_community.vectorstores import FAISS
from langchain_community.embeddings.openai import OpenAIEmbeddings
#import chromadb
#from chromadb.utils import embedding_functions
import fitz  
from openai import OpenAI

# Load environment variables
load_dotenv()
OPENAI_API_KEY = os.getenv('OPENAI_API_KEY')

# Initialize OpenAI client
client = OpenAI(api_key=OPENAI_API_KEY)

# Initialize ChromaDB
chroma_client = chromadb.Client()

# Initialize embedding function
embedding_function = embedding_functions.OpenAIEmbeddingFunction(
    api_key=OPENAI_API_KEY,
    model_name="text-embedding-3-small"
)

def get_or_create_collection(party, document_name):
    collection_name = party
    try:
        # Try to get existing collection
        collection = chroma_client.get_collection(
            name=collection_name,
            embedding_function=embedding_function
        )
    except:
        # Create new collection if it doesn't exist
        collection = chroma_client.create_collection(
            name=collection_name,
            embedding_function=embedding_function
        )
        
        # Load PDF and add to collection
        try:
            doc = fitz.open(document_name)
            for i, page in enumerate(doc):
                text = page.get_text()
                if text.strip():  # Only add non-empty pages
                    collection.add(
                        documents=[text],
                        ids=[f"page_{i}"],
                        metadatas=[{"page": i, "source": document_name}]
                    )
        except Exception as e:
            print(f"Error loading PDF: {e}")
    
    return collection


def generate_answer(party, document_name, query, return_sources=False):
    """
    Generates an answer for a specific query based on a party's document.
    """
    try:
        # Fetch the collection
        collection = get_or_create_collection(party, document_name)
        
        # Query ChromaDB
        results = collection.query(
            query_texts=[query],
            n_results=3
        )
        
        # Handle query results
        relevant_texts = results['documents'][0]
        context = "\n".join(relevant_texts)
        
        if not relevant_texts:
            return "Keine relevanten Abschnitte gefunden.", []

        context = "\n".join(relevant_texts)

        # Generate response using OpenAI (API v1.0.0+)
        messages = [
            {"role": "system",
             "content": ("""Du bist ein kritischer KI-Assistent, der auf Wahlprogramme deutscher Parteien spezialisiert ist.
                         Gib präzise, klare und fundierte Antworten auf Basis des bereitgestellten Kontextes.
                         Verschönere nichts, sondern gib nur die Stellungen der jeweiligen Partei wieder.
                         Wenn du dich auf spezifische Abschnitte oder Themen aus den Wahlprogrammen beziehst, erwähne dies explizit in deiner Antwort.""")},
            {"role": "user",
             "content": f"Kontext:\n{context}\n\nFrage: {query}\n\nBitte geben Sie eine klare Antwort, die sich auf den Kontext stützt, und erwähnen Sie gegebenenfalls relevante Artikel oder Abschnitte.“"}
        ]

        completion = client.chat.completions.create(
            model="gpt-4o-mini",
            messages=messages,
            temperature=0.7
        )
        
        if return_sources:
            return completion.choices[0].message, relevant_texts
        else:
            return completion.choices[0].message
    
    except Exception as e:
        raise Exception(f"Error generating answer: {str(e)}")

def format_source_reference(text):
    """Format the source text for display"""
    # You can add additional formatting logic here
    return text.strip()

if __name__ == "__main__":
    # Test the system
    query = "Whas sind die Hauptthemen der Partei?"
    answer, sources = generate_answer("BSW", "pdf/BSW_Wahlprogramm_2025__Entwurf_.pdf", query, return_sources=True)
    print("Answer:", answer.content)
    print("\nSources:")
    for i, source in enumerate(sources, 1):
        print(f"\nSource {i}:")
        print(format_source_reference(source))