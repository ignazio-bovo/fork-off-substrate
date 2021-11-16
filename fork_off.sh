#!/bin/bash

# get env variables
if [-f .env]; then
    source .env
fi

# create data folder
mkdir data

# copy storage dump
scp ${REMOTE_STORAGE_DUMP_ADDRESS} ./data/storage.json

# copy required elements to data folder
cp ${BINARY_PATH} ./data/binary
cp ${WASM_PATH} ./data/runtime.wasm
cp ${TYPES_PATH} ./data/schema.json

# copy the executable binary
npm start

