#!make
BUILDER ?= github
include Makefile.$(BUILDER)


build: build-date add-files-to-archive docker-lab-html

.PHONY: fetch-app-advisor-intro-sources help build release add-files-to-archive docker-lab-html Makefile releaseclean get-reporeg get-name deploy

add-files-to-archive:
	cp -r labs/* build
	$(MAKE) fetch-app-advisor-intro-sources
	for d in build/*; do \
	  tar -czvf build/`cat $$d/WORKSHOP_ID`.tar.gz -C $$d .; \
	done

	mkdir -p build/educates-resources
	cp -r resources/* build/educates-resources
	for f in build/educates-resources/apply/*; do \
	  VERSION=${version} CONTAINER_REGISTRY=${CONTAINER_REGISTRY} CONTAINER_REPOSITORY=${CONTAINER_REPOSITORY} envsubst '$${VERSION} $${CONTAINER_REGISTRY} $${CONTAINER_REPOSITORY}' < $$f > $$f.resolved; \
	  mv $$f.resolved $$f; \
	done

# Shipped as git bundles (single files) because bare repos are mostly empty directories,
# which don't survive being unpacked as workshop files. setup.d clones from these, so
# students never need to reach GitHub.
fetch-app-advisor-intro-sources:
	rm -rf build/tmp-sources
	mkdir -p build/app-advisor-intro/workshop/sources build/tmp-sources
	git clone --bare ${PETCLINIC_REPO} build/tmp-sources/spring-petclinic.git
	git --git-dir=build/tmp-sources/spring-petclinic.git rev-parse --verify ${PETCLINIC_REF}^{commit}
	git --git-dir=build/tmp-sources/spring-petclinic.git update-ref `git --git-dir=build/tmp-sources/spring-petclinic.git symbolic-ref HEAD` ${PETCLINIC_REF}
	git --git-dir=build/tmp-sources/spring-petclinic.git bundle create $(CURDIR)/build/app-advisor-intro/workshop/sources/spring-petclinic.bundle --all
	git clone --bare ${CORPORATE_STARTER_REPO} build/tmp-sources/saa-corporate-starter-sample.git
	git --git-dir=build/tmp-sources/saa-corporate-starter-sample.git bundle create $(CURDIR)/build/app-advisor-intro/workshop/sources/saa-corporate-starter-sample.bundle --all
	rm -rf build/tmp-sources

build-date:
	rm -rf build
	# This ensures there is always a build directory with an asset to upload
	mkdir -p build

docker-lab-html:

	docker build --build-arg VERSION="${version}" \
				 -t "${CONTAINER_REPOSITORY}:${version}" \
				 -t "${CONTAINER_REGISTRY}${CONTAINER_REPOSITORY}:${version}" \
				 -t "${CONTAINER_REGISTRY}${CONTAINER_REPOSITORY}:${env}" \
				 .

	docker image prune -f

docker-lab-html-reporeg:
	@echo "${CONTAINER_REGISTRY}${CONTAINER_REPOSITORY}"

release:
	docker tag ${CONTAINER_REGISTRY}${CONTAINER_REPOSITORY}:${version} ${CONTAINER_REGISTRY}${CONTAINER_REPOSITORY}:latest
	docker push ${CONTAINER_REGISTRY}${CONTAINER_REPOSITORY}:${version}
	docker push ${CONTAINER_REGISTRY}${CONTAINER_REPOSITORY}:latest

deploy-lab:
	docker pull ${CONTAINER_REGISTRY}${CONTAINER_REPOSITORY}:${version}
	docker tag ${CONTAINER_REGISTRY}${CONTAINER_REPOSITORY}:${version} ${CONTAINER_REGISTRY}${CONTAINER_REPOSITORY}:${environment}
	docker push ${CONTAINER_REGISTRY}${CONTAINER_REPOSITORY}:${environment}

deploy-lab-local:
	kubectl apply -f build/educates-resources/apply
	source build/educates-resources/env."${environment}"
	envsubst '$${ENVIRONMENT}' < build/educates-resources/apply/trainingportal.yaml | kubectl apply -f -

deploy-lms:
	metadata/lms/deploy.sh deploy-all

get-reporeg:
	@echo "${CONTAINER_REGISTRY}${CONTAINER_REPOSITORY}"

get-name:
	@echo "${NAME}"
