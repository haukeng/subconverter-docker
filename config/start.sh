#!/usr/bin/env sh
if [ -n "${SUB_PASSWORD}" ]; then
    sed -i "7s/.*/api_access_token = \"${SUB_PASSWORD}\"/" pref.toml
else
    echo "Your need to set environment variable SUB_PASSWORD to start the container!"
    exit 1
fi

subconverter