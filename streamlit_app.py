import streamlit as st
import os
from dotenv import load_dotenv
from langchain.vectorstores import FAISS
from rag_system import invoke_rag_chain, parties, setup_retrieval, embedding_function, parties_old

# Set Streamlit page configuration
st.set_page_config(layout="wide")

# Initialize session state
if "messages" not in st.session_state:
    st.session_state.messages = {party: [] for party in parties}
if "party_references" not in st.session_state:
    st.session_state.party_references = {party: [] for party in parties}
if "vectorstore" not in st.session_state:
    st.session_state.vectorstore = {party: [] for party in parties}
if "retriever" not in st.session_state:
    st.session_state.retriever = {party: [] for party in parties}

# Load Streamlit secrets if available
if "OPENAI_API_KEY" in st.secrets:
    os.environ["OPENAI_API_KEY"] = st.secrets["OPENAI_API_KEY"]

# Load environment variables from .env file as a fallback
load_dotenv()

# Initialize OpenAI embeddings
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")
if not OPENAI_API_KEY:
    raise ValueError("OPENAI_API_KEY is missing. Please check your secrets.toml or .env file.")


# Main interface
st.title("Wahlprogramme Chat Assistant")
st.write("Chat mit den Wahlprogrammen für die Bundestagswahl 2025!")

# Prompt the user to enter their API key
#apikey = st.form("user_api_key")
#api_key = apikey.text_input("Kopiere hier deinen Groq API Key rein:", type="password")
#submit = apikey.form_submit_button('Enter')
#if submit:
 #   st.session_state.api_key = api_key
  #  os.environ["GROQ_API_KEY"] = api_key  # Set API key dynamically
   # apikey.success("API Key erfolgreich eingfügt.")
#else:
 #   if not st.session_state.api_key:
  #      apikey.warning("Es fehlt noch ein API Key.", icon="⚠️")

#apikey.write("Here is the key:")
#apikey.write(st.session_state.api_key)

# Show a warning if no API Key is set
#if not st.session_state.api_key:
#    apikey.warning("Bitte gib deinen Groq API Key ein, um fortzufahren!", icon="⚠️")

# Use Groq API key for OpenAI client
#if st.session_state.api_key:
#    client = openai.OpenAI(
#        base_url="https://api.groq.com/openai/v1",
#        api_key=st.session_state.api_key  # User-provided key
#    )

#st.subheader("st.session_state object:") 
#st.session_state

#LLM = ChatGroq(groq_api_key=st.session_state.api_key, model_name="Llama3-8b-8192")

# Dynamic columns for party answers
columns = st.columns(len(parties))
for col, (party, document) in zip(columns, parties.items()):
    with col:
        parteiname = document['name']
        header = st.container()
        header.subheader(parteiname)
        header.write("""<div class='fixed-header'/>""", unsafe_allow_html=True)

        ### Custom CSS for the sticky header
        st.markdown(
            """
        <style>
            div[data-testid="stVerticalBlock"] div:has(div.fixed-header) {
                position: sticky;
                top: 2.875rem;
                z-index: 999;
            }
            .fixed-header {
                border-bottom: 1px solid black;
            }
        </style>
            """,
            unsafe_allow_html=True
        )
        
query = st.chat_input("Stellen Sie jetzt eine Frage!")

for col, (party, document_name) in zip(columns, parties.items()):
    with col:        
        # Display chat messages from history
        for message in st.session_state.messages[party]:
            with st.chat_message(message["role"]):
                st.markdown(message["content"])

for col, (party, document) in zip(columns, parties.items()):
    document_name, parteiname = document.values()
    if query:
        with col:
            with st.chat_message("user"):
                st.markdown(query)
            st.session_state.messages[party].append({"role": "user", "content": query})
            if not st.session_state.vectorstore[party]:
                vectorestore = FAISS.load_local(f"{party}_faiss_index", embedding_function, allow_dangerous_deserialization=True)
                #vectorestore = create_vectorstore(document_name)
                st.session_state.vectorstore[party] = vectorestore
                st.session_state.retriever[party] = setup_retrieval(vectorestore)
            try:
                 with st.chat_message("assistant"):
                    with st.spinner(f"Generiere Antwort für {parteiname}..."):
                        retriever = st.session_state.retriever[party]
                        output = invoke_rag_chain(retriever, query)
                        #answer = output
                        answer = output["answer"]
                        context = output["context"]
                        st.markdown(answer)
            except AttributeError as e:
                st.error(f"Fehler! {e}")
                answer = "Sorry, hat nicht geklappt."
        st.session_state.messages[party].append({"role": "assistant", "content": answer})
        st.session_state.party_references[party] = context

    # Display current references if existent
    with col:
        if st.session_state.party_references[party]:
            st.markdown("### Referenzen für die aktuelle Antwort:")
            for i, ref in enumerate(st.session_state.party_references[party], 1):
                with st.expander(f"Referenz {i}"):
                    st.markdown(f"**Seite**: {ref.metadata.get('page', 'N/A')}")
                    st.text(ref.page_content)


# Sidebar
with st.sidebar:
    if st.button("Clear Chat History"):
        st.session_state.messages = {party: [] for party in parties}
        st.session_state.party_references = {party: [] for party in parties}
        st.rerun()

    st.markdown("### Über diese App")
    st.write("Stellen Sie Fragen zu den Wahlprogrammen deutscher Parteien für die Bundestagswahl 2025.")

    st.markdown("""
    ### Tipps
    - Spezifische Fragen stellen
    - Im Anschluss Follow-up Fragen 
    - Den Chatverlauf mit dem obigen Knopf löschen
    """)

    # Example Questions with clickable functionality
    
   # st.markdown(questions)
    st.markdown("### Beispielfragen")
    example_questions = [
        "Was sind die zentralen Themen im Wahlprogramm von der Partei?",
        "Welche Maßnahmen schlägt die Partei zur Förderung erneuerbarer Energien vor?",
        "Wie plant die Partei, das Bildungssystem in Deutschland zu verbessern?",
        "Welche Position hat die Partei zur Aufnahme von Geflüchteten?"
    ]

    for question in example_questions:
        if st.button(question):
            # Simulate clicking the question
            with st.spinner(f"Generiere Antwort für alle Parteien..."):
                query = question
                for (party, document) in parties.items():
                        document_name, parteiname = document.values()
                        st.session_state.messages[party].append({"role": "user", "content": query})
                        try:
                            if not st.session_state.vectorstore[party]:
                                vectorestore = FAISS.load_local(f"{party}_faiss_index", embedding_function, allow_dangerous_deserialization=True)
                                #vectorestore = create_vectorstore(document_name)
                                st.session_state.vectorstore[party] = vectorestore
                                st.session_state.retriever[party] = setup_retrieval(vectorestore)

                            retriever = st.session_state.retriever[party]
                            output = invoke_rag_chain(retriever, query)
                            answer = output["answer"]
                            context = output["context"]

                            st.session_state.messages[party].append({"role": "assistant", "content": answer})
                            st.session_state.party_references[party] = context
                        except AttributeError as e:
                            st.error(f"Fehler! {e}")
                            st.session_state.messages[party].append({"role": "assistant", "content": "Sorry, hat nicht geklappt."})
            st.rerun()

    # Document Overview
    st.markdown("### Quelle")
    with st.expander("📚  Link zu den Wahlprogrammen"):
        st.page_link("https://www.bundestagswahl-bw.de/bundestagswahl-wahlprogramme", label="Wahlprogramme Parteien - Bundestagswahl 2025")
        for (party, document) in parties_old.items():
            path, document_name = document.values()
            st.markdown(f"**{document_name}**:"
                        f"\n- {path}"
                        "\n- Latest Version: 2025")
                
    #if st.button("Export Data"):
        # Prepare the data for export
     #   export_data = {
      #      "messages": st.session_state.messages,
       #     "party_references": st.session_state.party_references,
        #}

        # Convert to JSON format
       # export_json = json.dumps(export_data, indent=4, ensure_ascii=False)

        # Define the filename
        #now = datetime.datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
        #filename = f"chat_data_{now}.json"

        # Use Streamlit's file download feature
        #st.download_button(
         #   label="Download JSON File",
          #  data=export_json,
           # file_name=filename,
            #mime="application/json"
        #)
