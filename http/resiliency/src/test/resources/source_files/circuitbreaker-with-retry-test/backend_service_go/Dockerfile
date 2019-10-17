# Use go image
FROM golang

# Create env variable GOPATH
ENV GOPATH /go

# Copy local package file
ADD http1_backend /go/src/http1_backend

WORKDIR /go/src/http1_backend

# Download go dependencies
RUN go get -d ./...

# Install the package
RUN go install ./...

run go build -i -o http1_go_backend

ENTRYPOINT ["/go/bin/http1_backend"]

# Exposing port number
EXPOSE 10400
