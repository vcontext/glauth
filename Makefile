VERSION=$(shell bin/glauth-darwin-amd64 --version)

GIT_COMMIT=$(shell git rev-list -1 HEAD )
BUILD_TIME=$(shell date -u +%Y%m%d_%H%M%SZ)
GIT_CLEAN=$(shell git status | grep -E "working (tree|directory) clean" | wc -l | sed 's/^[ ]*//')

# Last git tag
LAST_GIT_TAG=$(shell git describe --abbrev=0 --tags 2> /dev/null)

# this=1 if the current commit is the tagged commit (ie, if this is a release build)
GIT_IS_TAG_COMMIT=$(shell git describe --abbrev=0 --tags > /dev/null 2> /dev/null && echo "1" || echo "0")

# Used when a tag isn't available
GIT_BRANCH=$(shell git rev-parse --abbrev-ref HEAD)

# Build variables
BUILD_VARS=-X main.GitCommit=${GIT_COMMIT} -X main.GitBranch=${GIT_BRANCH} -X main.BuildTime=${BUILD_TIME} -X main.GitClean=${GIT_CLEAN} -X main.LastGitTag=${LAST_GIT_TAG} -X main.GitTagIsCommit=${GIT_IS_TAG_COMMIT}
BUILD_FILES=glauth.go
TRIM_FLAGS=-gcflags "all=-trimpath=${PWD}" -asmflags "all=-trimpath=${PWD}"

#####################
# High level commands
#####################

# Build and run - used for development
run: setup devrun cleanup

# Run the integration test on linux64 (eventually allow the binary to be set)
test: runtest

# Run build process for all binaries
all: setup binaries verify cleanup

# Run build process for only linux64
fast: setup darwin64 verify cleanup

# list of binary formats to build
#binaries: linux32 linux64 linuxarm32 linuxarm64 darwin64 win32 win64
binaries: darwin-amd64 solaris-amd64
# Setup commands to always run
#setup: getdeps bindata format
setup: getdeps format

#####################
# Subcommands
#####################

# Run integration test
runtest:
	./scripts/travis/integration-test.sh cleanup

# Get all dependencies
getdeps:
	go get -d ./...

updatetest:
	./scripts/travis/integration-test.sh

#bindata:
#	go get -u github.com/jteeuwen/go-bindata/... && ${GOPATH}/bin/go-bindata -pkg=assets -o=pkg/assets/bindata.go assets && gofmt -w pkg/assets/bindata.go


cleanup:
	echo "webinterface/bindata is disabled."
	#rm pkg/assets/bindata.go

clean:
	rm bin/*

format:
	go fmt

devrun:
	go run ${BUILD_FILES} -c glauth.cfg

linux-amd64:
	GOOS=linux GOARCH=amd64 go build ${TRIM_FLAGS} -ldflags "${BUILD_VARS}" -o bin/glauth-linux-amd64 ${BUILD_FILES} && cd bin && sha256sum glauth-linux-amd64 > glauth-linux-amd64.sha256

darwin-amd64:
	GOOS=darwin GOARCH=amd64 go build ${TRIM_FLAGS} -ldflags "${BUILD_VARS}" -o bin/glauth-Darwin-amd64 ${BUILD_FILES} && cd bin && sha256sum glauth-Darwin-amd64 > glauth-Darwin-amd64.sha256

windows-amd64:
	GOOS=windows GOARCH=amd64 go build ${TRIM_FLAGS} -ldflags "${BUILD_VARS}" -o bin/glauth-windows-amd64 ${BUILD_FILES} && cd bin && sha256sum glauth-windows-amd64 > glauth-windows-amd64.sha256

illumos-amd64:
	GOOS=illumos GOARCH=amd64 go build ${TRIM_FLAGS} -ldflags "${BUILD_VARS}" -o bin/glauth-illumos-amd64 ${BUILD_FILES} && cd bin && sha256sum glauth-illumos-amd64 > glauth-illumos-amd64.sha256

solaris-amd64:
	GOOS=solaris GOARCH=amd64 go build ${TRIM_FLAGS} -ldflags "${BUILD_VARS}" -o bin/glauth-solaris-amd64 ${BUILD_FILES} && cd bin && sha256sum glauth-solaris-amd64 > glauth-solaris-amd64.sha256


verify:
	cd bin && sha256sum *.sha256 -c && cd ../;
