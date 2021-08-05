FROM golang:1.16-alpine AS build

WORKDIR /go/src/app
ADD go.* .
ADD createCertificate.sh .
RUN go mod download
RUN go install -v github.com/cnsilvan/UnblockNeteaseMusic
RUN apk add openssl
RUN chmod u+x /go/bin/UnblockNeteaseMusic
RUN sh createCertificate.sh

FROM alpine:edge
WORKDIR /bin
EXPOSE 8080 8443
COPY --from=build /go/bin/UnblockNeteaseMusic /bin
COPY --from=build /go/src/app/server.* /bin
CMD ["UnblockNeteaseMusic", "-m", "2", "-p", "8080", "-sp", "8443"]


