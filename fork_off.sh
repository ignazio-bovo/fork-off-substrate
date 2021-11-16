#!/bin/bash

# get env variables
if [ -f .env ]; then
    source .env
fi

# create data folder
if ![ -d ./data ]; then
    mkdir data
fi

# copy storage dump
if ![ -f ./data/storage.json ]; then
    scp ${REMOTE_STORAGE_DUMP_ADDRESS} ./data/storage.json
fi

# copy required elements to data folder
if ![ -f ./data/binary ]; then
    cp ${BINARY_PATH} ./data/binary
fi

if ![ -f ./data/runtime.wasm ]; then
    cp ${WASM_PATH} ./data/runtime.wasm
fi

if ![ -f ./data/schema.json ]; then
    cp ${TYPES_PATH} ./data/schema.json
fi

# copy the executable binary
npm start

