#! /bin/bash

P="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  echo Welcome to My Salon, how can I help you?

  SERVICES=$($P "SELECT * FROM services ORDER BY service_id")
  echo "$SERVICES" | while read SERVICE_ID BAR SERVICE
  do
    echo "$SERVICE_ID) $SERVICE"
  done
  read SERVICE_ID_SELECTED 
  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
  then
    MAIN_MENU "I could not find that service. What would you like today?"
  else
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE
    CUSTOMER_NAME=$($P "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    echo $CUSTOMER_NAME
  if [[ -z $CUSTOMER_NAME ]]
  then
    # get new customer name
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    # insert new customer
    INSERT_CUSTOMER_RESULT=$($P "INSERT INTO customers(name,phone) VALUES('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
    CUSTOMER_ID_IN=$($P "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
    SERVICE_NAME_IN=$($P "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'")
    echo -e "\nWhat time would you like your $SERVICE_NAME_IN, $CUSTOMER_NAME"
    read SERVICE_TIME
    INSERT_APPOINTMENT=$($P "INSERT INTO appointments(time,service_id,customer_id) VALUES('$SERVICE_TIME','$SERVICE_ID_SELECTED','$CUSTOMER_ID_IN')")
    echo -e "\nI have put you down for a $SERVICE_NAME_IN at $SERVICE_TIME, $CUSTOMER_NAME."

  else
    CUSTOMER_ID=$($P "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
    CUSTOMER_NAM=$($P "SELECT name FROM customers WHERE phone= '$CUSTOMER_PHONE' AND customer_id= '$CUSTOMER_ID'")
    SERVICE_NAME=$($P "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'")
    echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAM"
    read TIME
    INSERT_APPOINTMENT=$($P "INSERT INTO appointments(time,service_id,customer_id) VALUES('$TIME','$SERVICE_ID_SELECTED','$CUSTOMER_ID')")
    echo -e "\nI have put you down for a $SERVICE_NAME at $TIME, $CUSTOMER_NAM."

  fi
  fi
   
}

MAIN_MENU
