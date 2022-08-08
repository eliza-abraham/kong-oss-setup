FROM kong/kong:2.8.1
LABEL description="Docker image containing Kong + kong-oidc plugin"

USER root

RUN apk update

RUN apk add bash build-base curl curl-dev git openssl unzip gcc luarocks5.1

RUN luarocks install luacov
RUN luarocks install luaunit
RUN luarocks install lua-cjson

ENV KONG_PLUGIN_OIDC_VER="1.2.4-4"
ENV LUA_RESTY_OIDC_VER="1.7.5-1"

#ENV KONG_DATABASE="postgres"
#ENV KONG_PG_HOST="ec2-23-23-81-31.compute-1.amazonaws.com"
#ENV KONG_PG_USER="wobkcwlmzjxgvb"
#ENV KONG_PG_DATABASE="dferr19vt82cd2"
#ENV KONG_PG_PASSWORD="80d9a238b2501783ebffabb5a09d3151c00a1b2b87c992b28ad694e91bc6e69e"
#ENV KONG_PG_SSL="on"
ENV KONG_PROXY_ACCESS_LOG: /dev/stdout
ENV KONG_ADMIN_ACCESS_LOG: /dev/stdout
ENV KONG_PROXY_ERROR_LOG: /dev/stderr
ENV KONG_ADMIN_ERROR_LOG: /dev/stderr
ENV KONG_ADMIN_LISTEN: "0.0.0.0:${PORT}"
ENV KONG_ADMIN_GUI_URL: http://localhost:8002
ENV KONG_PLUGINS: bundled, oidc
ENV KONG_DECLARATIVE_CONFIG: "/opt/kong/kong.yaml"

# Build kong-oidc from forked repo because is not keeping up with lua-resty-openidc

RUN set -ex \
    ## Install plugins
    # Remove old lua-resty-session
    && luarocks remove --force lua-resty-session \
    # Build kong-oidc from forked repo because is not keeping up with lua-resty-openidc
    && curl -sL https://raw.githubusercontent.com/revomatico/kong-oidc/v${KONG_PLUGIN_OIDC_VER}/kong-oidc-${KONG_PLUGIN_OIDC_VER}.rockspec | tee kong-oidc-${KONG_PLUGIN_OIDC_VER}.rockspec | \
    sed -E -e 's/(tag =)[^,]+/\1 "master"/' -e "s/(lua-resty-openidc ~>)[^\"]+/\1 ${LUA_RESTY_OIDC_VER}/" > kong-oidc-${KONG_PLUGIN_OIDC_VER}.rockspec \
    && luarocks build kong-oidc-${KONG_PLUGIN_OIDC_VER}.rockspec

COPY . /usr/local/kong-oidc

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

USER kong
