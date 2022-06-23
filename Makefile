# cue utils

REPO_ROOT := $(shell git rev-parse --show-toplevel)
BUILD_DIR := $(REPO_ROOT)/build

all: vet fmt

vet:
	@cue vet ./... -c

fmt:
	@cue fmt ./...

mod:
	go get -u k8s.io/api/...
	cue get go k8s.io/api/...
	go get -u github.com/fluxcd/source-controller/api/v1beta2
	cue get go github.com/fluxcd/source-controller/api/v1beta2
	go get -u github.com/fluxcd/kustomize-controller/api/v1beta2
	cue get go github.com/fluxcd/kustomize-controller/api/v1beta2
	go get -u github.com/fluxcd/notification-controller/api/v1beta1
	cue get go github.com/fluxcd/notification-controller/api/v1beta1
	go get -u github.com/fluxcd/helm-controller/api/v2beta1
	cue get go github.com/fluxcd/helm-controller/api/v2beta1
	go get -u github.com/fluxcd/image-reflector-controller/api/v1beta1
	cue get go github.com/fluxcd/image-reflector-controller/api/v1beta1
	go get -u github.com/fluxcd/image-automation-controller/api/v1beta1
	cue get go github.com/fluxcd/image-automation-controller/api/v1beta1

build:
	mkdir -p deploy/staging
	cue staging > ./deploy/staging/podinfo.yaml
	mkdir -p deploy/production
	cue production > ./deploy/production/podinfo.yaml

push:
	flux push artifact ghcr.io/konfigstore/manifests/podinfo:$$(git rev-parse --short HEAD) \
    	--path="./deploy" \
    	--source="$$(git config --get remote.origin.url)" \
    	--revision="$$(git branch --show-current)/$$(git rev-parse HEAD)"
	flux tag artifact ghcr.io/konfigstore/manifests/podinfo:$$(git rev-parse --short HEAD) --tag staging

promote:
	flux tag artifact ghcr.io/konfigstore/manifests/podinfo:staging --tag production

.PHONY: deploy
deploy:
	flux -n staging create source oci podinfo \
    	--url ghcr.io/konfigstore/manifests/podinfo \
    	--tag staging \
    	--interval 10m
	flux -n staging create kustomization podinfo \
		--source=OCIRepository/podinfo \
		--path="./deploy/staging" \
		--target-namespace=staging \
		--interval=5m \
		--prune=true \
		--wait=true
	flux -n production create source oci podinfo \
    	--url ghcr.io/konfigstore/manifests/podinfo \
    	--tag production \
    	--interval 10m
	flux -n production create kustomization podinfo \
		--source=OCIRepository/podinfo \
		--path="./deploy/production" \
		--target-namespace=production \
		--interval=5m \
		--prune=true \
		--wait=true
