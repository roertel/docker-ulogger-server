#!/usr/bin/env bash

# Builds & tags Docker images
docker build --tag ulogger-server:latest \
  --build-arg ulogger_tag="$(cat version)"
