#!/bin/bash

dfx stop
rm -rf .dfx

dfx identity use alice
ALICE_PUBLIC_KEY="principal \"$( \
    dfx identity get-principal
)\""

dfx start --background
dfx canister --no-wallet create --all
dfx build

dfx canister update-settings --controller idboi-b5xwr-sqmib-et732-6xddj-bauzl-4cpjf-s3tin-updwk-c3l2v-fqe --all

dfx canister --no-wallet install iCat -m=reinstall

eval dfx canister --no-wallet call iCat initCat "'($ALICE_PUBLIC_KEY, \"myCat\")'"
eval dfx canister --no-wallet call iCat getCatName "'($ALICE_PUBLIC_KEY)'"
eval dfx canister --no-wallet call iCat getUserData "'($ALICE_PUBLIC_KEY)'"
eval dfx canister --no-wallet call iCat addFreezeScore "($ALICE_PUBLIC_KEY,5)"
eval dfx canister --no-wallet call iCat getUserData "'($ALICE_PUBLIC_KEY)'"
eval dfx canister --no-wallet call iCat addFreezeScore "($ALICE_PUBLIC_KEY,10)"
eval dfx canister --no-wallet call iCat getUserData "'($ALICE_PUBLIC_KEY)'"










