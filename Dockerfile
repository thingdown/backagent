#############################################
# Dockerfile to run trailblazer
# Based on Alpine
#############################################

FROM node:8-alpine

MAINTAINER Jam Risser (jamrizzi)

ENV MONGO_HOST=db
ENV MONGO_PORT=27017
ENV MONGO_DATABASE=blogagent
ENV NODE_ENV=production
ENV GIT_ORIGIN=https://github.com/thingdown/blogdown-theme-docs.git
ENV GIT_BRANCH=master
ENV BLOGDOWN_LOCATION=/data/blogdown

EXPOSE 6602

WORKDIR /app/

RUN apk add --no-cache \
        tini && \
    apk add --no-cache --virtual build-deps \
        git && \
    npm install -g eslint

COPY ./package.json /app/
RUN npm install
COPY ./ /app/
RUN npm test && \
    apk del build-deps && \
    npm uninstall -g eslint && \
    npm prune --production

ENTRYPOINT ["/sbin/tini", "--", "node", "/app/node_modules/babel-cli/bin/babel-node", "/app/server.js"]
