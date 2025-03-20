APPLICATION_NAME ?= ulogger-server
DOCKER_USERNAME ?= username
GIT_HASH != git log --format="%s" -n 1
APPLICATION_TAG != grep -Po '^application-tag: \K(.*)$$' version
PHP_TAG != grep -Po '^php-tag: \K(.*)$$' version

build:
	docker build --tag ${APPLICATION_NAME}:latest \
	  --build-arg ulogger_tag="${APPLICATION_TAG}" \
	  --build-arg php_version="${PHP_TAG}" .

push:
	docker push ${DOCKER_USERNAME}/${APPLICATION_NAME}:${GIT_HASH}

release:
	docker pull ${DOCKER_USERNAME}/${APPLICATION_NAME}:${GIT_HASH}
	docker tag  ${DOCKER_USERNAME}/${APPLICATION_NAME}:${GIT_HASH} ${DOCKER_USERNAME}/${APPLICATION_NAME}:latest
	docker push ${DOCKER_USERNAME}/${APPLICATION_NAME}:latest

run:
	docker run -it --rm --name ulogger-server -p 8080:8080 ulogger-server
