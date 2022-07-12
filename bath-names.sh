#!/usr/bin/env bash
CUSTOMERS=('911')

for CUSTOMER in ${CUSTOMERS[@]}; do
  echo "Updating customer with no $CUSTOMER"

  HOST="frontend-$CUSTOMER-mariadb-0"
  DATABASE_NAME="$CUSTOMER""_SDK"

  kubectl -n customers exec -it $HOST -- mysql -u root -psecretpassword -e 'use `'$DATABASE_NAME'`; update CheckListTranslations set Text = "01. Aflæsninger - Dragør Svømmehal" where Id IN (349)'

  echo "Done updating customer with no $CUSTOMER"
done