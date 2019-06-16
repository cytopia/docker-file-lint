FROM alpine:latest as builder

RUN set -x \
	&& apk add --no-cache \
		moreutils

FROM alpine:latest
LABEL \
	maintainer="cytopia <cytopia@everythingcli.org>" \
	repo="https://github.com/cytopia/docker-jsonlint"

RUN set -x \
	&& apk add --no-cache \
		bash \
		dos2unix \
		file \
		grep \
		sed

COPY --from=builder /usr/bin/isutf8 /usr/bin/isutf8
COPY data /usr/bin/
WORKDIR /data
CMD ["usage"]
