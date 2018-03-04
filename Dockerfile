FROM python:3.6

RUN groupadd -r uwsgi && useradd -r -g uwsgi uwsgi \
    && pip install Flask==0.12.2 uwsgi==2.0.17 requests==2.18.2 redis==2.10.6

WORKDIR /app

COPY app /app
COPY ./cmd.sh /

EXPOSE 9090 9191

USER uwsgi

CMD ["/cmd.sh"]

HEALTHCHECK CMD curl --fail http://localhost:9090/monster/bla \
    || curl --fail http://localhost:5000/monster/bla || exit 1
