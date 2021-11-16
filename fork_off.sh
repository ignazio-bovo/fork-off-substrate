#!/bin/sh

# get env variables
if [[ -f .env ]]; then
    source .env
fi

# create data folder
if ! [[ -d ./data ]]; then
    mkdir data
fi

# copy storage dump
if ! [[ -f ./data/storage.json ]]; then
    scp ${REMOTE_STORAGE_DUMP_ADDRESS} ./data/storage.json
fi

# copy required elements to data folder
if ! [[ -f ./data/binary ]]; then
    cp ${BINARY_PATH} ./data/binary
fi

if ! [[ -f ./data/runtime.wasm ]]; then
    cp ${WASM_PATH} ./data/runtime.wasm
fi

if ! [[ -f ./data/schema.json ]]; then
    cp ${TYPES_PATH} ./data/schema.json
fi

# the script works by modifying an existing 
build_raw_spec() {
    echo "{
  \"balances\":[
    [\"${ALICE}\", ${ALICE_INITIAL_BALANCE}]
  ]
}" > ${DATA_PATH}/initial-balances.json

    # Make Alice a member
    echo '
  [{
    "member_id":0,
    "root_account":${ALICE},
    "controller_account":${ALICE},
    "handle":"alice",
    "avatar_uri":"https://alice.com/avatar.png",
    "about":"Alice",
    "registered_at_time":0
  }]
' > ${DATA_PATH}/initial-members.json

    # Create a chain spec file with Alice as SUDO
    ./chain-spec-builder ${BINARY_PATH} \
			 new \
			 --authority-seeds Alice \
			 --sudo-account  ${ALICE} \
			 --deployment dev \
			 --chain-spec-path ./data/chain-spec.json \
			 --initial-balances-path ./data/initial-balances.json \
			 --initial-members-path ./data/initial-members.json

    # Convert the chain spec file to a raw chainspec file
    ${BINARY_PATH} build-spec \
		   --raw --disable-default-bootnode \
		   --chain /data/chain-spec.json > ./data/${CHAIN_FORK}.json

    # remove human readable chainspec & files
    rm data/{initial-balances,initial-members,chain-spec}.json
}

# copy the executable binary
npm start

