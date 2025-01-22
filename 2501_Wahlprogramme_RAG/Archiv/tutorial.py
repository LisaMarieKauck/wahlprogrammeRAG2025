# Import library
from langchain_community.document_loaders import PyPDFLoader

# Create a document loader for rag_paper.pdf
loader = PyPDFLoader('rag_paper.pdf')

# Load the document
data = loader.load()
print(data[0])

from langchain_text_splitters import RecursiveCharacterTextSplitter

# Define a text splitter that splits recursively through the character list
text_splitter = RecursiveCharacterTextSplitter(
    separators=["\n\n", "\n", ".", " ", ""],
    chunk_size=75,  
    chunk_overlap=10  
)

# Split the document using text_splitter
chunks = text_splitter.split_documents(data)
print(chunks)
print([len(chunk.page_content) for chunk in chunks])

from langchain_openai import OpenAIEmbeddings
from langchain_chroma import Chroma

embedding_model = OpenAIEmbeddings(    
    api_key=openai_api_key,    
    model="text-embedding-3-small"
)

vector_store = Chroma.from_documents(    
    documents=chunks,     
    embedding=embedding_model
)

vector_store = Chroma.from_documents(    
    documents=chunks,     
    embedding=embedding_model
)

retriever = vector_store.as_retriever(    
    search_type="similarity",    
    search_kwargs={"k": 2}
)

from langchain_core.prompts import ChatPromptTemplate
from langchain_core.runnables import RunnablePassthrough
from langchain_core.output_parsers import StrOutputParser

llm = ChatOpenAI(model="gpt-4o-mini", api_key="...", temperature=0)

prompt = """
Use the only the context provided to answer the following question. If you don't know the answer, reply that you are unsure.
Context: {context}
Question: {question}
"""

# Convert the string into a chat prompt template
prompt_template = ChatPromptTemplate.from_template(prompt)

# Create an LCEL chain to test the prompt
chain = (    
    {"context": retriever, "question": RunnablePassthrough()}    
    | prompt    
    | llm    
    | StrOutputParser()
)

# Invoke the chain on the inputs provided
print(chain.invoke({"context": "DataCamp's RAG course was created by Meri Nova and James Chapman!", "question": "Who created DataCamp's RAG course?"}))

