#!/usr/bin/env bash
echo "Doing old backup cleanup"
rm backup-*.sql


echo "Restoring SDK for customer with no $1"

CUSTOMERS=('238' '715' '734' '743' '750' '754' '756' '769' '777' '780' '783' '784' '788' '790' '791' '798' '800' '802' '805' '806' '811' '812' '815' '817' '818' '819' '820' '823' '824' '826' '827' '828' '829' '830' '834' '835' '836' '837' '839' '840' '841' '842' '843' '844' '845' '846')

for CUSTOMER in ${CUSTOMERS[@]}; do
  echo "Updating customer with no $CUSTOMER"

  HOST="frontend-$CUSTOMER-mariadb-0"
  DATABASE_NAME="$CUSTOMER-angular-items-planning-plugin"

  kubectl -n customers exec -it $HOST -- mysql -u root -psecretpassword -e 'use `'$DATABASE_NAME'`; update Plannings set PushMessageOnDeployment = 1, DaysBeforeRedeploymentPushMessageRepeat = 1'

  echo "Done updating customer with no $CUSTOMER, sleeping 60 seconds before proceeding to the next"
  sleep 90
done

kubectl -n customers exec -it $HOST -- mysql -u root -psecretpassword -e 'create database `'$DATABASE_NAME'`'

kubectl -n customers exec -it $HOST -- mysql -u root -psecretpassword $DATABASE_NAME < backup*.sql
