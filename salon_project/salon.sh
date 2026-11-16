#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

OPTIONS=$($PSQL "SELECT * FROM services")

MAIN_MENU() {

  # if [[ $1 ]]
  # then
  #   echo -e "\n$1"
  # fi

  echo -e "What would you like to schedule?\n"

  echo "$OPTIONS" | while read ID BAR SERVICE
  do
    echo "$ID) $SERVICE"
  done

  

  
   read SERVICE_ID_SELECTED
   SERVICE_CHOICE=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED")
   if [[ -z $SERVICE_CHOICE ]]
   then
     MAIN_MENU "Please enter a valid service"
  else
    echo -e "\nWhat is your phone number?"
    read CUSTOMER_PHONE

    # get info
    CUSTOMER_NAME="$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")"
    
    # if cust not exist
    if [[ -z $CUSTOMER_NAME ]]
    then
      # get new info
      echo -e "\nWhat is your name?"
      read CUSTOMER_NAME

      # insert
      INSERT_CUSTOMER_RESULT="$($PSQL "INSERT INTO customers(name,phone) VALUES('$CUSTOMER_NAME','$CUSTOMER_PHONE')")"
    fi

    # get id for appt
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

    # get appt time
    echo -e "\nWhat time would you like your appointment to be?"
    read SERVICE_TIME

    # schedule appt
    INSERT_APPT_RESULT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")
    SERVICE="$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")"
    echo -e "\nI have put you down for a$SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
   fi

  
}

echo -e "\n~~~ Salon ~~\n"

MAIN_MENU