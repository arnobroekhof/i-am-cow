# syntax = docker/dockerfile:1.0-experimental
FROM --platform=${TARGETPLATFORM:-linux/amd64} python:${TARGETVERSION:-3.9.1}-buster as builder

ARG TARGETPLATFORM
ARG BUILDPLATFORM

# Allows you to add additional packages via build-arg
ARG ADDITIONAL_DEV_PACKAGES

RUN apt-get update \
    &&  apt-get install -y ca-certificates ${ADDITIONAL_DEV_PACKAGES} \
    && rm -rf /var/lib/apt/lists/

# Add non root user
RUN groupadd app && useradd -r -g app app

# set the workdir
WORKDIR /home/app/

# copy from current directory to the image
COPY . .

# set the correct owner
RUN chown -R app /home/app

# run flake8 test
RUN pip install flake8 
RUN flake8 --ignore=E501,F401,W504 /home/app

# create the user and set the right python path
USER app
ENV PATH=$PATH:/home/app/.local/bin:/home/app/bin/
ENV PYTHONPATH=$PYTHONPATH:/home/app/libs

# install dependencies
RUN pip install -r requirements.txt --target=/home/app/libs

# fixed building the python environment

# build the actual image with content from the builder image
FROM --platform=${TARGETPLATFORM:-linux/amd64} python:${TARGETVERSION:-3.9.1}-slim-buster

# install additional packages via build-args
ARG ADDITIONAL_PACKAGES
RUN apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates ${ADDITIONAL_PACKAGES} \
 && rm -rf /var/lib/apt/lists \
 && apt-get clean

# Add non root user
RUN groupadd app && useradd -r -g app app

# Set the workdir
WORKDIR /home/app/

# copy the file from the builder    
COPY --from=builder /home/app .

# set the permissions
RUN chown -R app /home/app 

# switch to the user and set the correct environment
USER app
ENV PATH=$PATH:/home/app/.local/bin:/home/app/bin/
ENV PYTHONPATH=$PYTHONPATH:/home/app/libs

# set python as the entrypoint
ENTRYPOINT ["python"]

# execute the script
CMD ["/home/app/some-cowy-python-script.py"]
