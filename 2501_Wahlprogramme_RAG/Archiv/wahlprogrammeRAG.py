import streamlit as st
from streamlit_chat import message
from langchain.chains import RetrievalQA
from langchain_community.document_loaders import PyPDFLoader
from langchain_community.vectorstores import FAISS
from langchain_community.embeddings.openai import OpenAIEmbeddings
from langchain_community.llms import OpenAI

def load_document(file_like):
    with open("temp.pdf", "wb") as temp_file:
        temp_file.write(file_like.read())
    loader = PyPDFLoader("temp.pdf")
    documents = loader.load_and_split()
    return documents

def create_vectorstore(documents):
    embeddings = OpenAIEmbeddings()
    vectorstore = FAISS.from_documents(documents, embeddings)
    return vectorstore

def setup_retrieval_qa(vectorstore):
    llm = OpenAI(temperature=0)
    qa = RetrievalQA.from_chain_type(llm=llm, retriever=vectorstore.as_retriever())
    return qa

def render_navigation():
    with st.sidebar:
        st.title("Navigation")
        st.markdown("### Sections")
        st.markdown("- **About**: Learn about this app.")
        st.markdown("- **Tipps**: Helpful tips for usage.")
        st.markdown("- **Example Questions**: Suggestions for queries.")
        st.markdown("- **Current References**: See where the information comes from.")

def main():
    st.set_page_config(page_title="RAG System Chat", layout="wide")

    render_navigation()

    st.title("RAG Chat System")

    uploaded_file = st.file_uploader("Upload your document (PDF only)", type="pdf")

    if uploaded_file:
        with st.spinner("Processing your document..."):
            documents = load_document(uploaded_file)
            vectorstore = create_vectorstore(documents)
            qa_system = setup_retrieval_qa(vectorstore)

        st.session_state.qa_system = qa_system
        st.session_state.vectorstore = vectorstore

        st.success("Document processed successfully!")

    if "qa_system" in st.session_state:
        if "messages" not in st.session_state:
            st.session_state.messages = []

        user_input = st.text_input("Ask your question here:")
        if user_input:
            with st.spinner("Fetching response..."):
                try:
                    qa_result = st.session_state.qa_system.run(user_input)
                except AttributeError as e:
                    st.error(f"An error occurred: {e}")
                    qa_result = "Sorry, there was an error processing your request."

            st.session_state.messages.append({"role": "user", "content": user_input})
            st.session_state.messages.append({"role": "assistant", "content": qa_result})

            for message_data in st.session_state.messages:
                message(message_data["content"], is_user=(message_data["role"] == "user"))

    else:
        st.info("Please upload a document to begin.")

    with st.sidebar:
        st.header("About")
        st.write("This app allows users to interact with a document using a Retrieval-Augmented Generation (RAG) system.")

        st.header("Tipps")
        st.write("- Ask specific, concise questions for the best results.")
        st.write("- Include keywords to help narrow down the search scope.")

        st.header("Example Questions")
        st.write("- What are the key points of section X?")
        st.write("- Can you summarize the document?")
        st.write("- Where does the document discuss Y?")

        st.header("Current References")
        st.write("When you ask a question, references to the relevant parts of the document will appear here.")

if __name__ == "__main__":
    main()
