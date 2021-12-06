#!/usr/bin/env sh
if [ -n "${SUB_PASSWORD}" ]; then
    sed -i "7s/.*/api_access_token = \"${SUB_PASSWORD}\"/" pref.toml
else
    exit 1
fi

subconverter