#import os
from dotenv import load_dotenv
from langchain.chains import RetrievalQA
from langchain_community.document_loaders import PyPDFLoader
from langchain.vectorstores import FAISS
from langchain_openai import OpenAIEmbeddings
from langchain_openai import ChatOpenAI
import openai
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser
from operator import itemgetter
from langchain.chains import create_retrieval_chain
from langchain.chains.combine_documents import create_stuff_documents_chain
from langchain.text_splitter import RecursiveCharacterTextSplitter
from groq import Groq



# Party documents
parties = {
    "BSW": {'path': "pdf/BSW_Wahlprogramm_2025__Entwurf_.pdf", 'name': "BSW"},
    "SPD": {'path': "pdf/BTW_2025_SPD_Regierungsprogramm.pdf", 'name': "SPD"},
    "DieLINKE": {'path': "pdf/btw_2025_wahlprogramm_die_linke.pdf", 'name': "Die LINKE"},
    "FDP": {'path': "pdf/BTW_2025_Wahlprogramm_FDP_Entwurf.pdf", 'name': "FDP"},
    "Gruene": {'path': "pdf/BTW_2025_Wahlprogramm_Grüne_Entwurf.pdf", 'name': "Bündnis90/Die Grünen"},
    "Union": {'path': "pdf/btw_2025_wahlprogramm-cdu-csu.pdf", 'name': "Union"},
    "AfD": {'path': "pdf/Ich_kotze_gleich_Leitantrag-Bundestagswahlprogramm-2025.pdf", 'name': "AfD"}
}

# Load environment variables
load_dotenv()
#OPENAI_API_KEY = os.getenv('OPENAI_API_KEY')
#client = OpenAI(
#  api_key=os.environ['OPENAI_API_KEY'],  # this is also the default, it can be omitted
#)
#openai.api_key = OPENAI_API_KEY


# Initialize OpenAI embeddings
embedding_function = OpenAIEmbeddings(model="text-embedding-3-large")
# Text-Splitter konfigurieren
text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=100)
# LLM
llm = ChatOpenAI(temperature=0.7)

def create_vectorstore(path):
    loader = PyPDFLoader(path)
    documents = loader.load_and_split(text_splitter)
    embeddings = embedding_function
    vectorstore = FAISS.from_documents(documents, embeddings)
    return vectorstore

def setup_retrieval(vectorstore):
    retriever = vectorstore.as_retriever(search_kwargs={"k":3})
    return retriever

test_prompt =  """Du bist ein kritischer KI-Assistent, der auf Wahlprogramme deutscher Parteien spezialisiert ist.
                                Gib präzise, klare und fundierte Antworten auf Basis des bereitgestellten Kontextes.
                                Verschönere nichts, sondern gib nur die Stellungen der jeweiligen Partei wieder.
                                Wenn du keine Antwort kennst, sage, dass du es nicht weißt.
                                Wenn du dich auf spezifische Abschnitte oder Themen aus den Wahlprogrammen beziehst, erwähne dies explizit in deiner Antwort.
                 Kontext:\n{context}\n\n 
                 Frage:\n {input}\n\n
                 Bitte geben Sie eine klare Antwort, die sich auf den Kontext stützt, und erwähnen Sie relevante Artikel oder Abschnitte."""

prompt=ChatPromptTemplate.from_template(test_prompt)
#print(prompt.invoke)


def invoke_rag_chain(retriever, question):
    combine_docs_chain = create_stuff_documents_chain(llm, prompt)
    rag_chain = create_retrieval_chain(retriever, combine_docs_chain)
    answer = rag_chain.invoke({"input": question})
    return answer


