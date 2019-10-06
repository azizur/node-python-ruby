build:
	docker build -t azizur:node-python-ruby .

build-no-cache:
	docker build --no-cache -t azizur:node-python-ruby .

shell:
	docker run --name node-python-ruby -it --rm azizur:node-python-ruby bash
