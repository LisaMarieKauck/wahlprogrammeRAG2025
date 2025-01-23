import streamlit as st
#from rag_system import generate_answer
import os
from dotenv import load_dotenv
from langchain.chains import RetrievalQA
from langchain_community.document_loaders import PyPDFLoader
from langchain.vectorstores import FAISS
from langchain_openai import OpenAIEmbeddings
#from langchain_community.llms import OpenAI
from langchain_openai import ChatOpenAI
import openai

# Set Streamlit page configuration
st.set_page_config(layout="wide")

# Party documents
parties = {
    "BSW": "pdf/BSW_Wahlprogramm_2025__Entwurf_.pdf",
  #  "SPD": "pdf/BTW_2025_SPD_Regierungsprogramm.pdf",
  #  "DieLINKE": "pdf/btw_2025_wahlprogramm_die_linke.pdf",
  #  "FDP": "pdf/BTW_2025_Wahlprogramm_FDP_Entwurf.pdf",
  #  "Green": "pdf/BTW_2025_Wahlprogramm_Grüne_Entwurf.pdf",
  #  "Union": "pdf/btw_2025_wahlprogramm-cdu-csu.pdf",
  #  "AfD": "pdf/Ich_kotze_gleich_Leitantrag-Bundestagswahlprogramm-2025.pdf"
}


# Load environment variables
load_dotenv()
OPENAI_API_KEY = os.getenv('OPENAI_API_KEY')
#client = OpenAI(
#  api_key=os.environ['OPENAI_API_KEY'],  # this is also the default, it can be omitted
#)
openai.api_key = OPENAI_API_KEY

# Initialize OpenAI embeddings
embedding_function = OpenAIEmbeddings(model="text-embedding-3-large", api_key=OPENAI_API_KEY)

def create_vectorstore(path):
    loader = PyPDFLoader(path)
    documents = loader.load_and_split()
    embeddings = embedding_function
    vectorstore = FAISS.from_documents(documents, embeddings)
    return vectorstore

def setup_retrieval_qa(vectorstore):
    llm = ChatOpenAI(temperature=0.7)
    qa = RetrievalQA.from_chain_type(llm=llm, retriever=vectorstore.as_retriever(), chain_type="stuff", return_source_documents=True)
    return qa


# Initialize session state
if "messages" not in st.session_state:
    st.session_state.messages = {party: [] for party in parties}
if "party_references" not in st.session_state:
    st.session_state.party_references = {party: [] for party in parties}

# Main interface
st.title("Wahlprogramme Chat Assistant")
st.write("Chat with German political party programs for 2025!")

# Dynamic columns for party answers
columns = st.columns(len(parties))
for col, (party, document_name) in zip(columns, parties.items()):
    vectorstore = create_vectorstore(document_name)
    st.session_state[party] = {
        "qa_system": setup_retrieval_qa(vectorstore),
        "vectorstore": vectorstore
    }

    with col:
        st.subheader(party)

# Initialize session state
if "messages" not in st.session_state:
    st.session_state.messages = {party: [] for party in parties}
if "party_references" not in st.session_state:
    st.session_state.party_references = {party: [] for party in parties}

prompt = st.chat_input("Stellen Sie jetzt eine Frage!")

for col, (party, document_name) in zip(columns, parties.items()):
    with col:        
    # Display chat messages from history
        for message in st.session_state.messages[party]:
            with st.chat_message(message["role"]):
                st.markdown(message["content"])
        if prompt:
            with st.spinner(f"Generiere Antwort für {party}..."):
                try:
                    retriever = vectorstore.as_retriever()
                    retrieved_docs = retriever.get_relevant_documents(prompt)
                    context = "\n".join([doc.page_content for doc in retrieved_docs])
                    print("--------Check-----")
                    qa_result = st.session_state[party]["qa_system"].run(prompt)
                    print(qa_result, "--------Check-----")
                    answer, references = qa_result["answer"], qa_result["references"]
                except AttributeError as e:
                    st.error(f"Fehler: {e}")
                    qa_result = "Sorry, there was an error processing your request."

            messages = [
                {"role": "system",
                    "content": ("""Du bist ein kritischer KI-Assistent, der auf Wahlprogramme deutscher Parteien spezialisiert ist.
                                Gib präzise, klare und fundierte Antworten auf Basis des bereitgestellten Kontextes.
                                Verschönere nichts, sondern gib nur die Stellungen der jeweiligen Partei wieder.
                                Wenn du dich auf spezifische Abschnitte oder Themen aus den Wahlprogrammen beziehst, erwähne dies explizit in deiner Antwort.""")},
                {"role": "user",
                    "content": f"Kontext:\n{context}\n\nFrage: {prompt}\n\nBitte geben Sie eine klare Antwort, die sich auf den Kontext stützt, und erwähnen Sie gegebenenfalls relevante Artikel oder Abschnitte.“"}
            ]
            st.session_state.messages[party].append({"role": "user", "content": prompt})
            st.session_state.messages[party].append({"role": "user", "content": answer})
            st.session_state.party_references[party] = references

            for message_data in st.session_state.messages[party]:
                message(message_data["content"], is_user=(message_data["role"] == "user"))

            
            st.markdown("### Referenzen:")
            for i, ref in enumerate(st.session_state.party_references[party], 1):
                with st.expander(f"Referenz {i}"):
                    st.markdown(f"**Source**: {ref.metadata.get('source', 'N/A')}")
                    st.markdown(f"**Section**: {ref.metadata.get('section', 'N/A')}")
                    st.text(ref.page_content)


# Sidebar
with st.sidebar:
    if st.button("Clear Chat History"):
        st.session_state.party_answers = {party: "" for party in parties}
        st.session_state.party_references = {party: [] for party in parties}
        st.rerun()

    st.markdown("### Über diese App")
    st.write("Stellen Sie Fragen zu den Wahlprogrammen deutscher Parteien.")

    st.markdown("""
    ### About
    This is an AI assistant specialized in answering questions about German Wahlprogramme for 2025
    
    ### Tips
    - Ask specific questions
    - You can ask follow-up questions
    - Clear the chat history using the button above
    """)

    # Example Questions with clickable functionality
    st.markdown("### Example Questions")
    example_questions = [
        'Was sind die zentralen Themen im Wahlprogramm von die Partei?',
        'Welche Maßnahmen schlägt die Partei zur Förderung erneuerbarer Energien vor?',
        'Wie plant die Partei, das Bildungssystem in Deutschland zu verbessern?',
        'Welche Position hat die Partei zur Aufnahme von Geflüchteten?'
    ]
    for question in example_questions:
        if st.button(question):
            # Simulate clicking the question
            st.session_state.messages[party].append({"role": "user", "content": question})
            try:
                qa_result = st.session_state[party]["qa_system"].run(prompt)
                answer, references = qa_result["answer"], qa_result["references"]
            except AttributeError as e:
                st.error(f"Fehler: {e}")
                qa_result = "Sorry, there was an error processing your request."
            st.session_state.messages[party].append({"role": "user", "content": prompt})
            st.session_state.messages[party].append({"role": "user", "content": answer})
            st.session_state.party_references[party] = references

            for message_data in st.session_state.messages[party]:
                message(message_data["content"], is_user=(message_data["role"] == "user"))

            st.session_state.messages[party].append({"role": "user", "content": prompt})
            
            st.markdown("### Referenzen:")
            for i, ref in enumerate(st.session_state.party_references[party], 1):
                with st.expander(f"Referenz {i}"):
                    st.markdown(f"**Source**: {ref.metadata.get('source', 'N/A')}")
                    st.markdown(f"**Section**: {ref.metadata.get('section', 'N/A')}")
                    st.text(ref.page_content)
