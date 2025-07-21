FROM python:3.13.5-slim-bullseye

WORKDIR /app

COPY requirements.txt .
COPY app/* .

RUN pip install -r requirements.txt

EXPOSE 80

ARG APP_VERSION=unknown
ENV APP_VERSION=$APP_VERSION
ENV PYTHONUNBUFFERED=1

ENTRYPOINT ["flask", "--app", "app"]
CMD ["run", "--host=0.0.0.0", "--port=80"]
