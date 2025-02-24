# InterSystems IRIS RAG Demo

1. Clone or download this repostory to your local machine.
2. (optional) Edit the webserver port in `.env`.
3. (optional, default: SYS) Change IRIS password in `./src-iris/irispw.txt`.
4. Build the container images: `docker-compose build`.
5. Create and run containers: `docker-compose up -d`
6. Open IRIS managementportal: http://localhost:52773/csp/sys/UtilHome.csp
7. Open SwaggerUI: http://localhost:52773/swagger-ui/index.html?url=http://localhost:52773/rag/_spec
8. Open Streamlit: http://localhost:8051/

Additonal command:
- Stop Demo: `docker-compose stop`
- Start Demo: `docker-compose start`
- Delete all docker resources of the demo: `docker-compose down`

RAG
Submit PDF/Content for context:
1. Open SwaggerUI
2. Select 

Submit Audio File for context:
- Copy audio file to the `./volumes/Input` folder

 
