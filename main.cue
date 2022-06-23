package main

import (
	podinfo "github.com/konfigstore/podinfo-config/podinfo"
)

version: "6.1.6"

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
			maxReplicas: 5
		}
		ingress: {
			enabled:   true
			className: "nginx"
			host:      "podinfo.preview.internal"
			tls:       true
			annotations: "cert-manager.io/cluster-issuer": "letsencrypt"
		}
		serviceMonitor: enabled: false
	}
}

stagingObjects: appStaging.objects

appProduction: podinfo.#Application & {
	config: {
		meta: {
			name:      "podinfo"
			namespace: "default"
		}
		image: tag: version
		resources: requests: {
			cpu:    "500m"
			memory: "64Mi"
		}
		hpa: {
			enabled:     true
			maxReplicas: 20
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

productionObjects: appProduction.objects
