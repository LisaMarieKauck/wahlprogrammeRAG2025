import streamlit as st
import json
import datetime
from rag_system import invoke_rag_chain, parties, create_vectorstore, setup_retrieval

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

# Main interface
st.title("Wahlprogramme Chat Assistant")
st.write("Chat with German political party programs for 2025!")

#st.subheader("st.session_state object:") 
#st.session_state

# Dynamic columns for party answers
columns = st.columns(len(parties))
for col, (party, document_name) in zip(columns, parties.items()):
    with col:
        st.subheader(party)

query = st.chat_input("Stellen Sie jetzt eine Frage!")

for col, (party, document_name) in zip(columns, parties.items()):
    with col:        
        # Display chat messages from history
        for message in st.session_state.messages[party]:
            with st.chat_message(message["role"]):
                st.markdown(message["content"])


for col, (party, document_name) in zip(columns, parties.items()):
    if query:
        with col:
            with st.chat_message("user"):
                st.markdown(query)
            st.session_state.messages[party].append({"role": "user", "content": query})
            if not st.session_state.vectorstore[party]:
                vectorestore = create_vectorstore(document_name)
                st.session_state.vectorstore[party] = vectorestore
                st.session_state.retriever[party] = setup_retrieval(vectorestore)
            try:
                 with st.chat_message("assistant"):
                    with st.spinner(f"Generiere Antwort für {party}..."):
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
        'Analysiere das Wahlprogramm der Partei. Untersuche dabei insbesondere:' 
        'Nutzung von Statistiken, Zahlen und Daten: Werden in dem Programm Statistiken, Zahlen oder Daten verwendet, um die politischen Positionen oder Argumente der Partei zu untermauern? Falls ja, nenne Beispiele.'
        'Selektive Darstellung: Werden die Statistiken selektiv dargestellt oder interpretiert, sodass eine potenzielle Verzerrung oder Manipulation der Argumentation entsteht? Begründe deine Einschätzung und nenne Beispiele für mögliche Verzerrungen.',
        'Welche Maßnahmen schlägt die Partei zur Förderung erneuerbarer Energien vor?',
        'Wie plant die Partei, das Bildungssystem in Deutschland zu verbessern?',
        'Welche Position hat die Partei zur Aufnahme von Geflüchteten?'
    ]
    st.markdown(example_questions)
    # for question in example_questions:
    #     if st.button(question):
    #         # Simulate clicking the question
    #         st.session_state.messages[party].append({"role": "user", "content": question})
    #         try:
    #             retriever = st.session_state.retriever[party]
    #             output = invoke_rag_chain(retriever, query)
    #             #answer = output
    #             answer = output["answer"]
    #             context = output["context"]
    #             st.session_state.messages[party].append({"role": "assistant", "content": answer})
    #             st.session_state.party_references[party] = context
    #             st.rerun()
    #         except Exception as e:
    #             st.error(f"Fehler! {str(e)}")

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
