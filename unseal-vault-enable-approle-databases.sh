#!/usr/bin/env bash
VAULT_ADDR=http://localhost:8200

#TODO : vault KV 스토리지에 환경 변수를 올려서 해당 환경변수로 initalize shell script가 돌아가게끔 변경해야함.
export $(grep -v '#.*' ./mysql/.env | xargs)

echo "================"
echo "-- Initializing Vault"

VAULT_KEYS=$(curl -X PUT -s -d '{ "secret_shares": 1, "secret_threshold": 1 }' ${VAULT_ADDR}/v1/sys/init | jq .)
VAULT_KEY1=$(echo ${VAULT_KEYS} | jq -r .keys_base64[0])
VAULT_ROOT_TOKEN=$(echo ${VAULT_KEYS} | jq -r .root_token)

echo
echo "--> unsealing Vault ..."
curl -X PUT -d '{ "key": "'${VAULT_KEY1}'" }' ${VAULT_ADDR}/v1/sys/unseal

echo
echo "--> Vault status"
curl ${VAULT_ADDR}/v1/sys/init

echo
echo "================"
echo "-- AppRole (login without secret-id)"

echo
echo "--> enabling the AppRole auth method ..."
curl -X POST -i -H "X-Vault-Token: ${VAULT_ROOT_TOKEN}" -d '{"type": "approle"}' ${VAULT_ADDR}/v1/sys/auth/approle

echo "================"
echo "-- KV Secrets Engine - Version 1"

echo
echo "--> enabling KV Secrets Engine ..."
curl -X POST -i -H "X-Vault-Token: ${VAULT_ROOT_TOKEN}" -d '{"type": "kv", "description": "my KV Secrets Engine", "config": {"force_no_cache": true}}' ${VAULT_ADDR}/v1/sys/mounts/secret

echo "================"
echo "-- Mounting Database ..."
curl -X POST -i -H "X-Vault-Token:${VAULT_ROOT_TOKEN}" -d '{"type": "database"}' ${VAULT_ADDR}/v1/sys/mounts/database

echo
echo "--> configuring MySQL plugin and connection ..."
curl -X POST -i -H "X-Vault-Token: ${VAULT_ROOT_TOKEN}" -d "{\"plugin_name\": \"mysql-database-plugin\", \"allowed_roles\": \"*\", \"connection_url\": \"root:${MYSQL_ROOT_PASSWORD}@tcp(mysql:3306)/\"}" ${VAULT_ADDR}/v1/database/config/mysql

echo
echo "************************************************************"
echo "export VAULT_ROOT_TOKEN=${VAULT_ROOT_TOKEN}"
echo "************************************************************"
echo