CUR_DIR = $(CURDIR)

## Builds and tests project
.PHONY: all
all: gen-api check-style test

## Generates boilerplate from openapi spec
.PHONY: gen-api
gen-api: 
	oapi-codegen --config=openapi.cfg.yml openapi.yml

## Runs golangci-lint and npm run lint.
.PHONY: check-style
check-style: golangci-lint
	@echo Checking for style guide compliance

## Runs a local environment using docker-compose
.PHONY: start
start: check-style
	docker-compose up

## Removes volumes and all containers
.PHONY: clean
clean: 
	docker-compose  down --rmi local -v
## Run golangci-lint on codebase.
.PHONY: golangci-lint
golangci-lint:
	docker run --rm -v $(CUR_DIR):/app -w /app golangci/golangci-lint:latest golangci-lint run

## Runs any lints and unit tests defined for the server, if they exist.
.PHONY: test-back
test-back:
	go test -race -v ./...


## Runs test on backend and frontend
.PHONY: test
test: test-back

## Runs tests and generates coverage files
.PHONY: cov
cov:
	go test -race -coverprofile=coverage.txt -covermode=atomic -v ./...

## Autogenerates mocks
.PHONY: mocks
mocks: 
	docker run --rm -v $(CUR_DIR):/src -w /src vektra/mockery:v2 --all --recursive --output ./test/mocks

# Help documentation à la https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help:
	@cat Makefile | grep -v '\.PHONY' |  grep -v '\help:' | grep -B1 -E '^[a-zA-Z0-9_.-]+:.*' | sed -e "s/:.*//" | sed -e "s/^## //" |  grep -v '\-\-' | sed '1!G;h;$$!d' | awk 'NR%2{printf "\033[36m%-30s\033[0m",$$0;next;}1' | sort