// Code generated by cue get go. DO NOT EDIT.

//cue:generate cue get go github.com/fluxcd/pkg/apis/meta

package meta

// LocalObjectReference contains enough information to locate the referenced Kubernetes resource object.
#LocalObjectReference: {
	// Name of the referent.
	// +required
	name: string @go(Name)
}

// NamespacedObjectReference contains enough information to locate the referenced Kubernetes resource object in any
// namespace.
#NamespacedObjectReference: {
	// Name of the referent.
	// +required
	name: string @go(Name)

	// Namespace of the referent, when not specified it acts as LocalObjectReference.
	// +optional
	namespace?: string @go(Namespace)
}

// NamespacedObjectKindReference contains enough information to locate the typed referenced Kubernetes resource object
// in any namespace.
#NamespacedObjectKindReference: {
	// API version of the referent, if not specified the Kubernetes preferred version will be used.
	// +optional
	apiVersion?: string @go(APIVersion)

	// Kind of the referent.
	// +required
	kind: string @go(Kind)

	// Name of the referent.
	// +required
	name: string @go(Name)

	// Namespace of the referent, when not specified it acts as LocalObjectReference.
	// +optional
	namespace?: string @go(Namespace)
}

// SecretKeyReference contains enough information to locate the referenced Kubernetes Secret object in the same
// namespace. Optionally a key can be specified.
// Use this type instead of core/v1 SecretKeySelector when the Key is optional and the Optional field is not
// applicable.
#SecretKeyReference: {
	// Name of the Secret.
	// +required
	name: string @go(Name)

	// Key in the Secret, when not specified an implementation-specific default key is used.
	// +optional
	key?: string @go(Key)
}
