# Kong (OSS) + OIDC Plugin + Konga Setup

## Kong (OSS)

Dockerfile 

- Install Kong 2.8.0 (open source)
- Installs luarocks5.1
- Installs opidc plugin of luarocks

## Kong Database

docker-compose

- Kong Database installed on postgres12
- Kong Migration runs boostrapped migrations for kong 
- Kong uses the kong database

## Konga Setup

- Konga uses latest version of Konga and uses konga-database (not to be confused with kong-database)
- Konga Database installed on postgres9.6 since kong doesn't support postgres12+ as of 27th July, 2022. This is a work around for now.

  See Related Issues: 
  https://github.com/balderdashy/sails/issues/6957
  https://github.com/pantsel/konga/issues/462

  PR for fix (yet to be merged):
  https://github.com/pantsel/konga/pull/740

## Future Changes

Note: If above PR is merged, update docker-compose for konga to use kong-datase with postgres12 

  ```yml
  konga-prepare:
    image: pantsel/konga:next
    environment:
      DB_IS_PG12_OR_NEWER: true
    command: "-c prepare -a postgres -u postgresql://kong:kongpass@kong-database:5432/konga_db"
    networks:
      - kong-net
    links:
      - kong-database
    depends_on:
      - kong-database

  konga:
    image: pantsel/konga:next
    restart: always
    networks:
        - kong-net
    environment:
      DB_ADAPTER: postgres
      DB_HOST: kong-database
      DB_USER: kong
      DB_PASSWORD: kongpass
      DB_DATABASE: konga_db
      DB_IS_PG12_OR_NEWER: true
      TOKEN_SECRET: km1GUr4RkcQD7DewhJPNXrCuZwcKmqjb
      NODE_ENV: production
    depends_on:
      - kong-database
    ports:
      - "1337:1337"
  ```

- 


