import streamlit as st
from streamlit_chat import message
from rag_system import generate_answer

st.set_page_config(layout="wide")

# Initialize chat history and document states
if "messages" not in st.session_state:
    st.session_state.messages = []
if "current_references" not in st.session_state:
    st.session_state.current_references = []

# Display chat messages from history
def handle_chat_interaction(messages_key, input_prompt, response_generator):
    # Chat-Verlauf anzeigen
    for message in st.session_state[messages_key]:
        with st.chat_message(message["role"]):
            st.markdown(message["content"])
    
    # Benutzerinput akzeptieren
    if prompt := st.chat_input(input_prompt):
        with st.chat_message("user"):
            st.markdown(prompt)
        st.session_state[messages_key].append({"role": "user", "content": prompt})
        
        try:
            with st.chat_message("assistant"):
                with st.spinner("Thinking..."):
                    response, references = response_generator(prompt, return_sources=True)  # Antwort generieren
                    st.markdown(response.content)
                    st.session_state[messages_key].append({"role": "assistant", "content": response.content})
                    st.session_state.current_references = references  # Referenzen aktualisieren
        except Exception as e:
            st.error(f"Ein Fehler ist aufgetreten: {str(e)}")

# Main chat interface 
st.title("Wahlprogramme Chat Assistant")
st.write("Chat with your favourite Wahlprogramm!")

BSW, SPD, Linke, FDP, Green, Union, AFD = st.columns(7)

with BSW:
    st.header("BSW")
    if "chat_bsw_messages" not in st.session_state:
        st.session_state["chat_bsw_messages"] = []
    handle_chat_interaction("chat_bsw_messages", "Was möchten Sie über das Wahlprogramm wissen?", generate_answer)

with SPD:
    st.header("SPD")
    st.image("https://static.streamlit.io/examples/dog.jpg")

with Linke:
    st.header("Die LINKE")
    st.image("https://static.streamlit.io/examples/owl.jpg")

with FDP:
    st.header("FDP")
    st.image("https://static.streamlit.io/examples/owl.jpg")

with Green:
    st.header("Bündnis 90/DIE GRÜNEN")
    st.image("https://static.streamlit.io/examples/owl.jpg")

with Union:
    st.header("CDU/CSU")
    st.image("https://static.streamlit.io/examples/owl.jpg")

with AFD:
    st.header("AfD")
    st.image("https://static.streamlit.io/examples/owl.jpg")



# Sidebar content
with st.sidebar:
    # Clear chat button
    if st.button("Clear Chat History"):
        st.session_state.messages = []
        st.session_state.current_references = []
        st.rerun()

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
            st.session_state.messages.append({"role": "user", "content": question})
            try:
                response, references = generate_answer(question, return_sources=True)
                st.session_state.messages.append({"role": "assistant", "content": response.content})
                st.session_state.current_references = references
                st.rerun()
            except Exception as e:
                st.error(f"An error occurred: {str(e)}")

    # Referenced Documents Section
    st.markdown("### Current References")
    if st.session_state.current_references:
        for i, ref in enumerate(st.session_state.current_references, 1):
            with st.expander(f"Reference {i}"):
                st.markdown(f"```\n{ref}\n```")
                st.markdown("---")
                if hasattr(ref, 'metadata'):
                    st.markdown(f"**Source**: {ref.metadata.get('source', 'EU AI Act')}")
                    st.markdown(f"**Section**: {ref.metadata.get('section', 'N/A')}")
    else:
        st.info("Ask a question to see relevant references from your Wahlprogramm")

    # Document Overview
    st.markdown("### Document Overview")
    with st.expander("📚 Available Documents"):
        st.markdown("""
        - **Wahlprogramm** (Primary Document)
            - Full text
            - Latest version: 2025
        """)