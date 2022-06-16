#!/usr/bin/env bash
CUSTOMERS=('238' '419' '734' '743' '750' '756' '769' '777' '784' '834' '836' '840' '845' '846' '847' '848' '849' '850' '852' '853' '855' '856' '857' '858' '859' '860' '861' '862' '863' '864' '865' '866' '867' '869' '870' '871' '872' '873' '874' '875' '876' '877' '878' '879' '880' '881' '882' '884' '885' '886' '887' '888' '889' '890' '891' '892' '893' '894' '895' '896' '897' '898')

for CUSTOMER in ${CUSTOMERS[@]}; do
  echo "Updating customer with no $CUSTOMER"

  HOST="frontend-$CUSTOMER-mariadb-0"
  DATABASE_NAME="$CUSTOMER""_eform-backend-configuration-plugin"

  kubectl -n customers exec -it $HOST -- mysql -u root -psecretpassword -e 'use `'$DATABASE_NAME'`; update Properties set IsFarm = 1'

  echo "Done updating customer with no $CUSTOMER"
done
