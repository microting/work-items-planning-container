#!/bin/bash

CUSTOMERS=('238' '734' '743' '750' '756' '802' '836' '840' '845' '848' '849' '850' '852' '853' '855' '856' '858' '859' '860' '862' '863' '864' '865' '866' '867' '869' '870' '872' '873' '874' '875' '876' '877' '878' '879' '880' '881' '882' '884' '885' '886' '887' '889' '890' '892' '893' '894' '895' '898' '901' '911' '912' '913' '914' '915' '916' '917' '918' '921' '922' '923' '924' '925' '926' '927' '930' '931')


for CUSTOMER in ${CUSTOMERS[@]}; do
  echo "Updating customer with no $CUSTOMER"
  ./upgrade.sh $CUSTOMER
  echo "Done updating customer with no $CUSTOMER, sleeping 60 seconds before proceeding to the next"
  sleep 10
done
