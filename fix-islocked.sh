#!/usr/bin/env bash
CUSTOMERS=('915')

for CUSTOMER in ${CUSTOMERS[@]}; do
  echo "Updating customer with no $CUSTOMER"

  HOST="frontend-$CUSTOMER-mariadb-0"
  DATABASE_NAME="$CUSTOMER""_SDK"

  kubectl -n customers exec -it $HOST -- mysql -u root -psecretpassword -e 'use `'$DATABASE_NAME'`; update CheckLists set IsLocked = 1 where Id IN (3)'

  echo "Done updating customer with no $CUSTOMER"
done
