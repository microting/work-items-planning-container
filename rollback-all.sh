#!/bin/bash

CUSTOMERS=('715' '734' '743' '750' '754' '756' '769' '777' '780' '783' '784' '788' '790' '791' '798' '800' '802' '805' '806' '811' '812' '815' '817' '818' '819' '820' '823' '824' '826' '827' '828' '829' '830' '834' '835' '836' '837' '839' '840' '841' '842' '843' '844' '845' '846')

for CUSTOMER in ${CUSTOMERS[@]}; do
  echo "Rolling back customer with no $CUSTOMER"
  helm rollback -n customers frontend-$CUSTOMER
  echo "Done rolling back customer with no $CUSTOMER, sleeping 10 seconds before proceeding to the next"
  sleep 10
done