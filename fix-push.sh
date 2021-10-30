#!/usr/bin/env bash
CUSTOMERS=('238' '715' '734' '743' '750' '754' '756' '769' '777' '780' '783' '784' '788' '790' '791' '798' '800' '802' '805' '806' '811' '812' '815' '817' '818' '819' '820' '823' '824' '826' '827' '828' '829' '830' '834' '835' '836' '837' '839' '840' '841' '842' '843' '844' '845' '846')

for CUSTOMER in ${CUSTOMERS[@]}; do
  echo "Updating customer with no $CUSTOMER"

  HOST="frontend-$CUSTOMER-mariadb-0"
  DATABASE_NAME="$CUSTOMER""_eform-angular-items-planning-plugin"

  kubectl -n customers exec -it $HOST -- mysql -u root -psecretpassword -e 'use `'$DATABASE_NAME'`; update Plannings set PushMessageOnDeployment = 0, DaysBeforeRedeploymentPushMessageRepeat = 0'

  echo "Done updating customer with no $CUSTOMER"
done
