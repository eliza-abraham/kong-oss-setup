FROM kong/kong:2.8.0
LABEL description="Docker image containing Kong + kong-oidc plugin"

USER root

RUN apk update

RUN apk add bash build-base curl git openssl unzip gcc luarocks5.1

RUN luarocks install luacov
RUN luarocks install luaunit
RUN luarocks install lua-cjson

# Change openidc version when version in rockspec changes
RUN luarocks install kong-oidc

COPY . /usr/local/kong-oidc

USER kong
