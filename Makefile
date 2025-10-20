#!make
include Makefile.env


build: build-date add-files-to-archive docker-lab-html

.PHONY: help build release add-files-to-archive docker-lab-html Makefile releaseclean get-reporeg get-name deploy

add-files-to-archive:
	cp -r labs/* build
	for d in build/*; do \
	  tar -czvf build/`cat $$d/WORKSHOP_ID`.tar.gz -C $$d .; \
	done

	mkdir -p build/educates-resources
	cp -r resources/* build/educates-resources
	for f in build/educates-resources/apply/*; do \
	  VERSION=${version} envsubst '$${VERSION}' < $$f > $$f.resolved; \
	  mv $$f.resolved $$f; \
	done

build-date:
	rm -rf build
	# This ensures there is always a build directory with an asset to upload
	mkdir -p build

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
