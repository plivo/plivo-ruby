.PHONY: build test

build:
	docker-compose up --build --remove-orphans

test:
	@[ "${CONTAINER}" ] && \
		docker exec -it $$CONTAINER /bin/bash -c "bundle exec rake" || \
		bundle exec rake

run:
	@[ "${CONTAINER}" ] && \
		(docker exec -it $$CONTAINER /bin/bash -c 'cd /usr/src/app/ruby-sdk-test/ && ruby test.rb') || \
		(cd /usr/src/app/ruby-sdk-test/ && ruby test.rb)