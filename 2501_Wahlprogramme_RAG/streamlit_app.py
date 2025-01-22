import streamlit as st
from rag_system import generate_answer

# Set Streamlit page configuration
st.set_page_config(layout="wide")

# Party documents
parties = {
    "BSW": "pdf/BSW_Wahlprogramm_2025__Entwurf_.pdf",
    "SPD": "pdf/BTW_2025_SPD_Regierungsprogramm.pdf",
    "DieLINKE": "pdf/btw_2025_wahlprogramm_die_linke.pdf",
    "FDP": "pdf/BTW_Wahlprogramm_FDP_2025_Entwurf.pdf",
    "Green": "pdf/BTW_Wahlprogramm_Grüne_2025_Entwurf.pdf",
    "Union": "pdf/btw_2025_wahlprogramm-cdu-csu.pdf",
    "AfD": "pdf/Ich_kotze_gleich_Leitantrag-Bundestagswahlprogramm-2025.pdf"
}

# Initialize session state
if "messages" not in st.session_state:
    st.session_state.messages = {party: "" for party in parties}
if "party_references" not in st.session_state:
    st.session_state.party_references = {party: [] for party in parties}

# Main interface
st.title("Wahlprogramme Chat Assistant")
st.write("Chat with German political party programs for 2025!")

prompt = st.chat_input("Stellen Sie jetzt eine Frage!")

# Dynamic columns for party answers
columns = st.columns(len(parties))
for col, (party, document_name) in zip(columns, parties.items()):
    with col:
        st.subheader(party)
    # Display chat messages from history
    for message in st.session_state.messages[party]:
        with st.chat_message(message["role"]):
            st.markdown(message["content"])
    if prompt:
        for col, (party, document_name) in zip(columns, parties.items()):
            with col:
                with st.chat_message("user"):
                    st.markdown(prompt)
                st.session_state.messages.append({"role": "user", "content": prompt})
                try:
                    with st.chat_message("assistant"):
                        with st.spinner(f"Generiere Antwort für {party}..."):
                            answer, references = generate_answer(
                                party, document_name, prompt, return_sources=True
                            )
                            st.markdown(answer.content)
                            st.session_state.messages[party].append({"role": "assistant", "content": answer.content})
                            # Update current references
                            st.session_state.party_references[party] = references

                    # Display answer
                    #st.markdown(st.session_state.party_answers[party])

                    # Display references
                    st.markdown("### Referenzen:")
                    st.markdown(f"**Source**: {ref.metadata.get('source', party)}")
                    st.markdown(f"**Section**: {ref.metadata.get('section', 'N/A')}")
                    for i, ref in enumerate(st.session_state.party_references[party], 1):
                        with st.expander(f"Referenz {i}"):
                            st.text(ref)

                except Exception as e:
                    st.error(f"Fehler: {e}")

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
                response, references = generate_answer(question, return_sources=True)
                st.session_state.messages[party].append({"role": "assistant", "content": response.content})
                st.session_state.party_references[party] = references
                st.rerun()
            except Exception as e:
                st.error(f"An error occurred: {str(e)}")
