FROM python:3.13-slim
LABEL maintainer="Ehsan"

ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt

ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -f /tmp/requirements.txt && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

COPY ./app /app

WORKDIR /app

EXPOSE 8000

ENV PATH="/py/bin:$PATH"

USER django-user

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]