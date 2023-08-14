#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~ MY SALON ~~~~\n"
echo -e "Welcome to My Salon, how can I help you?\n"
MAIN_MENU() {
  MAIN_MENU_SERVICES=$($PSQL "SELECT service_id, name FROM services")
  echo "$MAIN_MENU_SERVICES" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"
  done
  read SERVICE_ID_SELECTED
if [[ ! $SERVICE_ID_SELECTED =~ ^[1-3]$ ]]
then
  echo -e "\nI could not find that service. What would you like today?"
  MAIN_MENU
else
  SERVICE_SELECTED=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME_1=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_NAME_1 ]]
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    echo -e "\nWhat time would you like your$SERVICE_SELECTED, $CUSTOMER_NAME?"
    read SERVICE_TIME
    echo -e "\nI have put you down for a$SERVICE_SELECTED at $SERVICE_TIME, $CUSTOMER_NAME."
    INSERT_CUSTOMER_INFO=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
    INSERT_APPOINTMENT_INFO=$($PSQL "INSERT INTO appointments(time) VALUES('$SERVICE_TIME')")
  else
    echo -e "\nWhat time would you like your$SERVICE_SELECTED, $CUSTOMER_NAME_1?"
    read SERVICE_TIME
    echo -e "\nI have put you down for a$SERVICE_SELECTED at $SERVICE_TIME, $CUSTOMER_NAME_1."
    INSERT_APPOINTMENT_INFO=$($PSQL "INSERT INTO appointments(time) VALUES('$SERVICE_TIME')")
  fi
fi
}
MAIN_MENU
