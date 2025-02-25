# IRIS RAG LocalLLM Demo
 1. Clone or download this repostory to your local machine
 2. Edit the front-end port in `.env` (optional)
 3. Change IRIS password in `./src-iris/irispw.txt` (optional, default: SYS)
 4. Build the container images: `docker-compose build`
 5. Create and run containers: `docker-compose up -d`
 6. Open IRIS managementportal: http://localhost:52773/csp/sys/UtilHome.csp
 7. Open SwaggerUI (APIs): http://localhost:52773/swagger-ui/index.html?url=http://localhost:52773/rag/_spec
 8. Open Streamlit (Chat interface): http://localhost:8051/

RAG
 Submit PDF/audio file or text content for context:
 1. Open SwaggerUI
 2. Select /SubmitContent or /SubmitPDF
 3. Submit file or type the new text to vectorize
 
 Alternatively, submit Audio File to vectorize:
 - Copy audio file to the `./volumes/Input` folder or send it on the Swagger through API

macOS*
 Docker Desktop does not currently support GPU acceleration on Mac.
  https://ollama.com/blog/ollama-is-now-available-as-an-official-docker-image
 On this case for a better performance it is recommended for MacOS users to run Ollama as a standalone application outside of Docker container.
  https://ollama.com/download/mac
