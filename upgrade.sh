#!/usr/bin/env bash
echo "Upgrading $1"

RABBITMQ_ERLANG_COOKIE=$(kubectl get secret --namespace customers frontend-$1-rabbitmq -o jsonpath="{.data.rabbitmq-erlang-cookie}" | base64 --decode)

echo $RABBITMQ_ERLANG_COOKIE

helm upgrade -n customers frontend-$1 helm/ --set rabbitmq.auth.erlangCookie=$RABBITMQ_ERLANG_COOKIE
