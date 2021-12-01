#!/usr/bin/env bash
CUSTOMERS=('846' '874' '875' '876' '877' '880' '881' '882' '883' '884' '885')

for CUSTOMER in ${CUSTOMERS[@]}; do
  echo "Updating customer with no $CUSTOMER"

  HOST="frontend-$CUSTOMER-mariadb-0"
  DATABASE_NAME="$CUSTOMER""_SDK"

  kubectl -n customers exec -it $HOST -- mysql -u root -psecretpassword -e 'use `'$DATABASE_NAME'`; update CheckLists set IsLocked = 0 where Id IN (7,61,79)'

  echo "Done updating customer with no $CUSTOMER"
done