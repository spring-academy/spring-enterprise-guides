#!make
include Makefile.env


build: build-date add-files-to-archive docker-lab-html

.PHONY: help build release add-files-to-archive docker-lab-html Makefile releaseclean get-reporeg get-name deploy

add-files-to-archive:
	cp -r labs/* build
	for d in build/*; do
	  WORKSHOP_ID=$(<d/WORKSHOP_ID)
	  tar -czvf ${WORKSHOP_ID}.tar.gz d/*
	done

	mkdir p build/educates-resources
	cp -r resources/* build/educates-resources
	for f in build/educates-resources/apply/*; do
	  envsubst '${version}' < $f > build/educates-resources/apply/$f
	done

build-date:
	# This ensures there is always a build directory with an asset to upload
	mkdir -p build
	date > build/build-date

docker-lab-html:

	docker build --build-arg VERSION="${version}" \
				 -t "${CONTAINER_REPOSITORY}:${version}" \
				 -t "${CONTAINER_REGISTRY}/${CONTAINER_REPOSITORY}:${version}" \
				 -t "${CONTAINER_REGISTRY}/${CONTAINER_REPOSITORY}:${env}" \
				 .

	docker image prune -f

docker-lab-html-reporeg:
	@echo "${CONTAINER_REGISTRY}/${CONTAINER_REPOSITORY}"

release:
	docker tag ${CONTAINER_REGISTRY}/${CONTAINER_REPOSITORY}:${version} ${CONTAINER_REGISTRY}/${CONTAINER_REPOSITORY}:latest
	docker push ${CONTAINER_REGISTRY}/${CONTAINER_REPOSITORY}:${version}
	docker push ${CONTAINER_REGISTRY}/${CONTAINER_REPOSITORY}:latest

deploy-lab:
	docker pull ${CONTAINER_REGISTRY}/${CONTAINER_REPOSITORY}:${version}
	docker tag ${CONTAINER_REGISTRY}/${CONTAINER_REPOSITORY}:${version} ${CONTAINER_REGISTRY}/${CONTAINER_REPOSITORY}:${environment}
	docker push ${CONTAINER_REGISTRY}/${CONTAINER_REPOSITORY}:${environment}

deploy-lms:
	metadata/lms/deploy.sh deploy-all

get-reporeg:
	@echo "${CONTAINER_REGISTRY}/${CONTAINER_REPOSITORY}"

get-name:
	@echo "${NAME}"