test: testdeps
	go test ./...
	go test ./... -short -race
	go test ./... -run=NONE -bench=. -benchmem
	env GOOS=linux GOARCH=386 go test ./...
	go vet

testdeps: testdata/redis/src/redis-server

bench: testdeps
	go test ./... -test.run=NONE -test.bench=. -test.benchmem

.PHONY: all test testdeps bench

testdata/redis:
	mkdir -p $@
	wget -qO- https://download.redis.io/releases/redis-6.2.5.tar.gz | tar xvz --strip-components=1 -C $@

testdata/redis/src/redis-server: testdata/redis
	cd $< && make all

fmt:
	gofmt -w -s ./
	goimports -w  -local github.com/go-redis/redis ./
