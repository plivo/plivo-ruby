.PHONY: build test

build:
	docker-compose up --build --remove-orphans

start:
	docker-compose up --build --remove-orphans --detach
	docker attach $(shell docker-compose ps -q rubySDK)

test:
	@[ "${CONTAINER}" ] && \
		docker exec -it $$CONTAINER /bin/bash -c "bundle exec rake" || \
		bundle exec rake

run:
	@[ "${CONTAINER}" ] && \
		(docker exec -it $$CONTAINER /bin/bash -c 'cd /usr/src/app/ruby-sdk-test/ && ruby test.rb') || \
		(cd /usr/src/app/ruby-sdk-test/ && ruby test.rb)