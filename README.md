# 🤖 IRIS RAG LocalLLM Demo 
 1. Clone or download this repostory to your local machine
 2. Edit the front-end port in `.env` (optional)
 3. Change IRIS password in `./src-iris/irispw.txt` (optional, default: SYS)
 4. Create and run containers: `docker-compose up -d` (macOS: `docker-compose -f docker-compose-arm.yaml up -d`)
 5. Open IRIS managementportal: http://localhost:52773/csp/sys/UtilHome.csp
 6. Open SwaggerUI (APIs): http://localhost:52773/swagger-ui/index.html?url=http://localhost:52773/rag/_spec
 7. Open Streamlit (Chat interface): http://localhost:8051/

RAG
 Submit PDF or text content to vectorize and use as context:
 1. Open SwaggerUI
 2. Select /SubmitContent or /SubmitPDF
 3. Submit file or type the new text contet to vectorize
 4. In the Demo.RecordEmbeddings is possible to check the vectors created for each text.
 5. (optional) It is possible to change LLM model, settings or intructions to use for the LLM model, in the Production > LLM Operation.
 6. Open Streamlit and just start asking about the content submited.
 
 Alternatively, submit Audio File to vectorize and use as context:
 - Copy audio file to the `./volumes/Input` folder.

macOS*
 - Docker Desktop does not currently support GPU acceleration on Mac.
   - https://ollama.com/blog/ollama-is-now-available-as-an-official-docker-image
 - On this case for a better performance it is recommended for MacOS users to run Ollama as a standalone application outside of Docker container.
   - https://ollama.com/download/mac
