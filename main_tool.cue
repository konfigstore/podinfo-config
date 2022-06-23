package main

import (
	"tool/cli"
	"encoding/yaml"
)

command: staging: {
	task: print: cli.Print & {
		text: yaml.MarshalStream([ for x in staging {x}])
	}
}

command: production: {
	task: print: cli.Print & {
		text: yaml.MarshalStream([ for x in production {x}])
	}
}
