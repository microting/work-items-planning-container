#!/bin/bash

CUSTOMERS=('924')

for CUSTOMER in ${CUSTOMERS[@]}; do
  echo "Rolling back customer with no $CUSTOMER"
  helm rollback -n customers frontend-$CUSTOMER
  echo "Done rolling back customer with no $CUSTOMER, sleeping 10 seconds before proceeding to the next"
  sleep 10
done
