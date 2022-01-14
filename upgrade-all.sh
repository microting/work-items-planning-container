#!/bin/bash

CUSTOMERS=('238' '419' '715' '734' '743' '750' '754' '756' '769' '777' '780' '783' '784' '798' '834' '836' '840' '845' '846' '847' '848' '849' '850' '851' '852' '853' '855' '856' '857' '858' '859' '860' '861' '862' '863' '864' '865' '866' '867' '869' '870' '871' '872' '873' '874' '875' '876' '877' '878' '879' '880' '881' '882' '884' '885' '886' '887' '888' '889' '890' '891' '892')

for CUSTOMER in ${CUSTOMERS[@]}; do
  echo "Updating customer with no $CUSTOMER"
  ./upgrade.sh $CUSTOMER
  echo "Done updating customer with no $CUSTOMER, sleeping 60 seconds before proceeding to the next"
  sleep 10
done
