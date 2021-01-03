build:
	docker build --compress -t azizur:node-python-ruby .

clean:
	docker image rm azizur:node-python-ruby

build-no-cache:
	docker build --no-cache --compress -t azizur:node-python-ruby .

shell:
	docker run --name node-python-ruby -it --rm azizur:node-python-ruby
