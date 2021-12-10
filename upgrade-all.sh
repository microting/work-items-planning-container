#!/bin/bash

CUSTOMERS=('238' '419' '715' '734' '743' '750' '754' '756' '769' '777' '780' '783' '784' '788' '790' '791' '798' '800' '802' '811' '812' '815' '817' '818' '819' '820' '823' '824' '826' '827' '828' '829' '830' '834' '835' '836' '837' '839' '840' '841' '842' '843' '844' '845' '846' '847' '848' '849' '850' '851' '852' '853' '854' '855' '856' '857' '858' '859' '860' '861' '862' '863' '864' '865' '866' '867' '868' '869' '870' '871' '872' '873' '874' '875' '876' '877' '880' '881' '882' '883' '884' '885' '886' '887' '888' '889')

for CUSTOMER in ${CUSTOMERS[@]}; do
  echo "Updating customer with no $CUSTOMER"
  ./upgrade.sh $CUSTOMER
  echo "Done updating customer with no $CUSTOMER, sleeping 60 seconds before proceeding to the next"
  sleep 90
done
