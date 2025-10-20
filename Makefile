#!make
include Makefile.env


build: build-date add-files-to-archive docker-lab-html

.PHONY: help build release add-files-to-archive docker-lab-html Makefile releaseclean get-reporeg get-name deploy

add-files-to-archive:
	mkdir -p ${DIR_LAB}/_static/lab-files

build-date:
	# This ensures there is always a build directory with an asset to upload
	mkdir -p build
	date > build/build-date

docker-lab-html:

	# in case the generation failed, cleanup old generated items
	rm -rf ${DIR_LAB}/_static/lab-files*

    # combine all the files together in a way where new files we add just automatically get picked up
	mkdir -p ${DIR_LAB}/_static/lab-files
	cp -R ${DIR_LAB}/instructions/*/code/* ${DIR_LAB}/_static/lab-files/ || true
	tar -czf ${DIR_LAB}/_static/lab-files.tar.gz -C ${DIR_LAB}/_static/lab-files/ .

	docker build --build-arg VERSION="${version}" \
				 -t "${CONTAINER_REPOSITORY}:${version}" \
				 -t "${CONTAINER_REGISTRY}/${CONTAINER_REPOSITORY}:${version}" \
				 -t "${CONTAINER_REGISTRY}/${CONTAINER_REPOSITORY}:${env}" \
				 .

	# cleanup all the temporary stuff
	rm -rf ${DIR_LAB}/_static/lab-files*
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