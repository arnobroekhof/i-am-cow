
IMAGE_TAG?="dev"
IMAGE_REPO?="127.0.0.1:5000"

image/build:
	DOCKER_BUILDKIT=1 docker build -t $(IMAGE_REPO)/cowy:$(IMAGE_TAG) .
