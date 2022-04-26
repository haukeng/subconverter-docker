#!/usr/bin/sh

reset_config() {
	sed -i "180s/.*/listen = \"0.0.0.0\"/" pref.toml
	sed -i "181s/.*/port = 25500/" pref.toml
}

reset_config

if [ -n "${SUB_PASSWORD}" ]; then
    sed -i "7s/.*/api_access_token = \"${SUB_PASSWORD}\"/" pref.toml
else
    echo "Your need to set environment variable SUB_PASSWORD to start the container!"
    exit 1
fi

if [ -n "${LISTEN}" ]; then
    sed -i "180s/.*/listen = \"${LISTEN}\"/" pref.toml
fi

if [ -n "${PORT}" ]; then
    sed -i "181s/.*/port = ${PORT}/" pref.toml
fi

subconverter


