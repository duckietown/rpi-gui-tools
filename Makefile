branch=$(shell git rev-parse --abbrev-ref HEAD)

name=duckietown/rpi-gui-tools:$(branch)

build:
	docker build -t $(name) .

build-no-cache:
	docker build -t $(name) --no-cache .

push:
	docker push $(name)
