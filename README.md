# Podinfo CUE module

This repository contains a [CUE](https://cuelang.org/docs/) module and tooling
for generating [podinfo](https://github.com/stefanprodan/podinfo)'s Kubernetes resources.

The module contains a `podinfo.#Application` definition which takes `podinfo.#Config` as input.

## Prerequisites

Install Go and CUE with:

```shell
brew install go cue
```

Generate the Kubernetes API definitions required by this module with:

```shell
make mod
```

## Configuration

Configure the application in `main.cue`:

```cue
appStaging: podinfo.#Application & {
	config: {
		meta: {
			name:      "podinfo"
			namespace: "default"
		}
		image: tag: version
		resources: requests: {
			cpu:    "100m"
			memory: "16Mi"
		}
		hpa: {
			enabled:     true
			maxReplicas: 3
		}
		ingress: {
			enabled:   true
			className: "nginx"
			host:      "podinfo.example.com"
			tls:       true
			annotations: "cert-manager.io/cluster-issuer": "letsencrypt"
		}
		serviceMonitor: enabled: false
	}
}
```

## Generate the manifests

```shell
cue staging
```
