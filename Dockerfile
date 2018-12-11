FROM python:alpine
WORKDIR /usr/src/app
ADD requirements.txt Procfile LICENSE aims ./
RUN pip install --no-cache-dir -r requirements.txt
ENTRYPOINT ['/usr/bin/env', 'honcho']
CMD ['start']
