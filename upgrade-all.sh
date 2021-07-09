#!/bin/bash

CUSTOMERS=('734' '743' '754' '783' '784' '788' '790' '791' '800' '802' '805' '806' '809' '811' '812' '815' '817' '818' '820' '823' '824' '826' '827' '828' '829' '830' '834' '835' '836' '836' '839' '840' '841' '842' '843' '844')

for CUSTOMER in ${CUSTOMERS[@]}; do
  echo "Updating customer with no $CUSTOMER"
  ./upgrade.sh $CUSTOMER
  echo "Done updating customer with no $CUSTOMER, sleeping 60 seconds before proceeding to the next"
  sleep 60
done
