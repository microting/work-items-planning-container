#!/usr/bin/env bash
kubectl get pods -n customers | grep Evicted | cut -d " " -f 1 | xargs kubectl delete pods -n customers --grace-period=0 --force