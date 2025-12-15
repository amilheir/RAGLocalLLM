ARG IRIS_IMAGE
ARG IRIS_TAG
FROM ${IRIS_IMAGE}:${IRIS_TAG}

COPY --chown="${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP}" ./src-iris /opt/irisbuild

RUN mkdir -p /usr/irissys/iriscache/hfcache

RUN pip install --target /usr/irissys/mgr/python --no-warn-script-location --break-system-packages -r /opt/irisbuild/requirements_iris.txt 

RUN iris start IRIS \
    && iris session IRIS < /opt/irisbuild/iris.script \
    && iris stop IRIS quietly

RUN old=http://localhost:52773/crud/_spec && \
	new=http://localhost:52773/rag/_spec && \
	sed -i "s|$old|$new|g" /usr/irissys/csp/swagger-ui/swagger-initializer.js

RUN --mount=type=secret,id=iris_pw,mode=0444 /usr/irissys/dev/Container/changePassword.sh /run/secrets/iris_pw
RUN rm -r /opt/irisbuild/*
