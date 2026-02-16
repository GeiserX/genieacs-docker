# syntax=docker/dockerfile:1
############################
# GenieACS v1.2.13.3 Dockerfile #
####################################################################
# docker buildx build --platform linux/amd64,linux/arm64 \         #
#   -t drumsergio/genieacs:1.2.13.3 -t drumsergio/genieacs:latest \ #
#   --push .                                                       #
####################################################################
FROM node:24-bookworm AS build 
LABEL maintainer="acsdesk@protonmail.com"

# packages needed only to build genieacs
RUN apt-get update \
 && apt-get install -y git python3 make g++ \
 && rm -rf /var/lib/apt/lists/*

# Install GenieACS
WORKDIR /opt
ARG GENIEACS_VERSION=v1.2.13
RUN git clone --depth 1 --single-branch \
      --branch "${GENIEACS_VERSION}" \
      https://github.com/genieacs/genieacs.git
#RUN npm install -g --unsafe-perm genieacs@1.2.13

WORKDIR /opt/genieacs
RUN npm ci --unsafe-perm 
#RUN npm i -D tslib
RUN npm run build

###########################################
# ----- helper stage: service files ------#
###########################################

FROM debian:bookworm-slim AS services
RUN apt-get update && \
    apt-get install -y --no-install-recommends git ca-certificates && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /tmp
RUN git clone --depth 1 --single-branch --branch 1.2.13 \
      https://github.com/GeiserX/genieacs-services.git

##################################
# -------- Final image ----------#
##################################
FROM debian:bookworm-slim

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      supervisor ca-certificates iputils-ping logrotate git wget cron gosu \
 && rm -rf /var/lib/apt/lists/*

# Copy Node runtime and GenieACS artefacts from the build stage
COPY --from=build /usr/local /usr/local
COPY --from=build /opt/genieacs /opt/genieacs

# supervisor + helper scripts from the services repo
COPY --from=services /tmp/genieacs-services/supervisord.conf \
     /etc/supervisor/conf.d/genieacs.conf
COPY --from=services /tmp/genieacs-services/run_with_env.sh \
     /usr/local/bin/run_with_env.sh
RUN chmod +x /usr/local/bin/run_with_env.sh

# remove unnecessary dpkg and apt-compat scripts from cron.daily
RUN rm -rf /etc/cron.daily/dpkg && rm -rf /etc/cron.daily/apt-compat

# logrotate rule
COPY config/genieacs.logrotate /etc/logrotate.d/genieacs

# create runtime user
RUN useradd --system --no-create-home --home /opt/genieacs genieacs \
 && mkdir -p /opt/genieacs/ext /var/log/genieacs \
 && chown -R genieacs:genieacs /opt/genieacs /var/log/genieacs

COPY entrypoint.sh /opt/entrypoint.sh
RUN chmod +x /opt/entrypoint.sh

ENTRYPOINT ["/opt/entrypoint.sh"]

WORKDIR /opt/genieacs

EXPOSE 7547 7557 7567 3000
CMD ["/usr/bin/supervisord","-c","/etc/supervisor/conf.d/genieacs.conf"]
