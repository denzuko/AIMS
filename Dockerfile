FROM python:alpine
# Metadata params
ARG VERSION="1.0.0"
ARG VCS_URL="https://github.com/denzuko/AIMS"
ARG VCS_REF="master"
ARG BUILD_DATE
ARG PORT=8080
ARG VENDOR="denzuko"
ARG MODULE="aims"

# Metadata
LABEL org.label-schema.vendor=$VENDOR \
      org.label-schema.url="https://dwightaspencer.com" \
      org.label-schema.name="aims" \
      org.label-schema.description="ansible inventory management system" \    
      org.label-schema.version=$VERSION \
      org.label-schema.vcs-url=$VCS_URL \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.docker.schema-version="1.0"
      
WORKDIR /usr/src/app

ADD requirements.txt Procfile LICENSE $MODULE ./
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE $PORT
ENTRYPOINT ['/usr/bin/env', 'honcho']
CMD ['start']
