.PHONY: build test

build:
	docker-compose up --build --remove-orphans

start:
	docker-compose up --build --remove-orphans --detach
	# Wait for the container to be running before attaching
	@while [ -z "$$(docker-compose ps -q rubySDK)" ]; do \
		sleep 1; \
	done
	docker attach $$(docker-compose ps -q rubySDK)

test:
	@[ "${CONTAINER}" ] && \
		docker exec -it $$CONTAINER /bin/bash -c "bundle exec rake" || \
		bundle exec rake

run:
	@[ "${CONTAINER}" ] && \
		(docker exec -it $$CONTAINER /bin/bash -c 'cd /usr/src/app/ruby-sdk-test/ && ruby test.rb') || \
		(cd /usr/src/app/ruby-sdk-test/ && ruby test.rb)