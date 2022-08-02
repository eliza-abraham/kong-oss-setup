FROM kong/kong:2.8.1
LABEL description="Docker image containing Kong + kong-oidc plugin"

USER root

RUN apk update

RUN apk add bash build-base curl git openssl unzip gcc luarocks5.1

RUN luarocks install luacov
RUN luarocks install luaunit
RUN luarocks install lua-cjson

ENV KONG_PLUGIN_OIDC_VER="1.2.4-4"
ENV LUA_RESTY_OIDC_VER="1.7.5-1"

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

USER kong
