import os
from dotenv import load_dotenv
from langchain.chains import RetrievalQA
from langchain_community.document_loaders import PyPDFLoader
from langchain.vectorstores import FAISS
#from langchain.docstore import InMemoryDocstore
from langchain_community.embeddings.openai import OpenAIEmbeddings
from langchain_community.llms import OpenAI
#import faiss
#import fitz  
#import openai 
#from openai import OpenAI
#import pickle  # For saving FAISS index with metadata
#from openai.error import OpenAIError 

# Load environment variables
load_dotenv()
OPENAI_API_KEY = os.getenv('OPENAI_API_KEY')
#openai.api_key = OPENAI_API_KEY

# Initialize OpenAI embeddings
embedding_function = OpenAIEmbeddings(api_key=OPENAI_API_KEY)

def create_vectorstore(path):
    loader = PyPDFLoader(path)
    documents = loader.load_and_split()
    embeddings = embedding_function
    vectorstore = FAISS.from_documents(documents, embeddings)
    return vectorstore

def setup_retrieval_qa(vectorstore):
    llm = OpenAI(temperature=0.7)
    qa = RetrievalQA.from_chain_type(llm=llm, retriever=vectorstore.as_retriever())
    return qa

#dimension = 1536  # Embedding dimension (check the OpenAI model you use, e.g., Ada embeddings have 1536 dimensions)
#index = faiss.IndexFlatL2(dimension)  # Create a FAISS index for L2 (Euclidean) distance
#docstore = InMemoryDocstore({})  # Initialize an empty in-memory document store
#index_to_docstore_id = {}  # Initialize an empty mapping from index to docstore IDs

# Path to store FAISS index and metadata
#FAISS_INDEX_PATH = "faiss_index_folder"
#METADATA_PATH = "metadata.pkl"

def load_or_create_faiss_index():
    """Load an existing FAISS index or create a new one."""
    global metadata_store
    if os.path.exists(FAISS_INDEX_PATH) and os.path.exists(METADATA_PATH):
        faiss_index = FAISS.load_local(FAISS_INDEX_PATH, embedding_function, allow_dangerous_deserialization=True)
        with open(METADATA_PATH, "rb") as f:
            metadata_store = pickle.load(f)
            #metadata_store = json.load(f)
    else:
        faiss_index = FAISS(
            embedding_function=embedding_function,
            index=index,
            docstore=docstore,
            index_to_docstore_id=index_to_docstore_id
        )
        metadata_store = {}
    return faiss_index


faiss_index = load_or_create_faiss_index()

def add_document_to_faiss(party, document_name):
    """Add the content of a document to the FAISS index."""
    global metadata_store, faiss_index

    # Process the PDF
    try:
        doc = fitz.open(document_name)
        for i, page in enumerate(doc):
            text = page.get_text()
            if text.strip():
                vector_id = f"{party}_page_{i}"
                faiss_index.add_texts([text], ids=[vector_id])
                metadata_store[vector_id] = {"page": i, "source": document_name}
    except Exception as e:
        raise Exception(f"Error processing PDF '{document_name}': {e}")

    # Ensure the directory exists
    os.makedirs(FAISS_INDEX_PATH, exist_ok=True)

    # Save the updated index and metadata
    faiss_index.save_local(FAISS_INDEX_PATH)
    with open(METADATA_PATH, "wb") as f:
        pickle.dump(metadata_store, f)
        #json.dump(metadata_store, f)

def invoke_rag_chain(pdf_path): 
    rag_chain = (
        { 
            "context": itemgetter("question") | create_vectorstore(pdf_path).as_retriever(search_kwargs={"k":3}), 
            "question":itemgetter("question"),
            "lang": itemgetter("lang"),
        }
        | prompt
        | ChatOpenAI(temperature=0.7)
        | StrOutputParser()
    )
    question = "Worum geht es? "
    lang = "German"
    query = { 
        "question":question, 
        "lang":lang,
    }
    
    answer = rag_chain.invoke(query)
    return answer

#for i, j in parties.items():
 #   ans = invoke_rag_chain(j)
  #  print(f"\n########## {i} ###########\n")
   # print(ans)
   
def generate_answer(party, document_name, query, return_sources=False):
    """
    Generates an answer for a specific query based on a party's document.
    """
    try:
        # Add document to FAISS if not already added
        if f"{party}_page_0" not in metadata_store:
            add_document_to_faiss(party, document_name)

        # Query FAISS
        results = faiss_index.similarity_search(query, k=3)

        # Retrieve relevant texts and metadata
        relevant_texts = [r.page_content for r in results]  
        context = "\n".join(relevant_texts)
        if not relevant_texts:
            return "Keine relevanten Abschnitte gefunden.", []

        messages = [
            {"role": "system",
             "content": ("""Du bist ein kritischer KI-Assistent, der auf Wahlprogramme deutscher Parteien spezialisiert ist.
                         Gib präzise, klare und fundierte Antworten auf Basis des bereitgestellten Kontextes.
                         Verschönere nichts, sondern gib nur die Stellungen der jeweiligen Partei wieder.
                         Wenn du dich auf spezifische Abschnitte oder Themen aus den Wahlprogrammen beziehst, erwähne dies explizit in deiner Antwort.""")},
            {"role": "user",
             "content": f"Kontext:\n{context}\n\nFrage: {query}\n\nBitte geben Sie eine klare Antwort, die sich auf den Kontext stützt, und erwähnen Sie gegebenenfalls relevante Artikel oder Abschnitte.“"}
        ]

        response = openai.ChatCompletion.create(
            model="gpt-4o-mini",
            messages=messages,
            temperature=0.7
        )
        answer = response["choices"][0]["message"]["content"]
        
        if return_sources:
            sources = [r.metadata for r in results]
            return answer, sources
        else:
            return answer
    
    except openai.error.OpenAIError as e:  # Catch OpenAI-specific errors
        raise Exception(f"OpenAI API error: {e}")
    except Exception as e:
        raise Exception(f"Error generating answer: {str(e)}")

def format_source_reference(metadata):
    """Format the metadata for display."""
    return f"Source: {metadata['source']}, Page: {metadata['page']}"

if __name__ == "__main__":
    # Test the system
    query = "Whas sind die Hauptthemen der Partei?"
    answer, sources = generate_answer("BSW", "pdf/BSW_Wahlprogramm_2025__Entwurf_.pdf", query, return_sources=True)
    print("Answer:", answer.content)
    print("\nSources:")
    for i, source in enumerate(sources, 1):
        print(f"\nSource {i}:")
        print(format_source_reference(source))