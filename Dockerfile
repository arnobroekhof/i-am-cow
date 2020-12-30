# syntax = docker/dockerfile:1.0-experimental
FROM --platform=${TARGETPLATFORM:-linux/amd64} python:3.9.1-buster

ARG TARGETPLATFORM
ARG BUILDPLATFORM

# Allows you to add additional packages via build-arg
ARG ADDITIONAL_PACKAGE

RUN apt-get update \
    &&  apt-get install -y ca-certificates ${ADDITIONAL_PACKAGE} \
    && rm -rf /var/lib/apt/lists/

# Add non root user
RUN groupadd app && useradd -r -g app app

WORKDIR /home/app/

COPY . .

RUN chown -R app /home/app && \
    mkdir -p /home/app/ && chown -R app /home/app

USER app
ENV PATH=$PATH:/home/app/.local/bin:/home/app/python/bin/
ENV PYTHONPATH=$PYTHONPATH:/home/app/libs

RUN pip install -r requirements.txt --target=/home/app/libs

WORKDIR /home/app/

USER app

# do not forget the execute bit script to be executed 

ENTRYPOINT ["python"]

CMD ["/home/app/some-cowy-python-script.py"]
