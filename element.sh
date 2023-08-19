#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

# gets the length of the arguments passed to the function
args=$1
n=${#args}

# checks for an argument, otherwise displays the feedback to user to provide one
if [[ ! $1 ]]
then
  echo "Please provide an element as an argument."

# checks if the argument is a number
elif [[ $1 =~ ^[0-9]+$ ]]
then
  # query the database for the desired information
  RESULT_ATOMIC_NUMBER_QUERY=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number = $1")
  # if nothing found in the dataase the query result will be null
  if [[ -z $RESULT_ATOMIC_NUMBER_QUERY ]]
  then
    # if the query result is null, then send this message to the user
    echo "I could not find that element in the database."
  else
    # if the result was not null, then the user gets given the information
    echo "$RESULT_ATOMIC_NUMBER_QUERY" | while read ATOMIC_NUMBER BAR NAME BAR SYMBOL BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT_CELSIUS BAR BOILING_POINT_CELSIUS; do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
    done
  fi

# cehcks whether the argument is an element name (not a number, and longer than 2 characters - remembering that the data type for the symbol was VARCHAR(2)
elif [[ $n -gt 2 ]]
then
  RESULT_ATOMIC_NUMBER_QUERY=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE name = '$1'")
  if [[ -z $RESULT_ATOMIC_NUMBER_QUERY ]]
  then
    echo "I could not find that element in the database."
  else
    echo "$RESULT_ATOMIC_NUMBER_QUERY" | while read ATOMIC_NUMBER BAR NAME BAR SYMBOL BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT_CELSIUS BAR BOILING_POINT_CELSIUS; do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
    done
  fi

# if the argument is not a number, and is not an element name, then it must be a symbol (or erroneous argument)
else
  RESULT_ATOMIC_NUMBER_QUERY=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE symbol = '$1'")
  if [[ -z $RESULT_ATOMIC_NUMBER_QUERY ]]
  then
    echo "I could not find that element in the database."
  else
    echo "$RESULT_ATOMIC_NUMBER_QUERY" | while read ATOMIC_NUMBER BAR NAME BAR SYMBOL BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT_CELSIUS BAR BOILING_POINT_CELSIUS; do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
    done
  fi
fi
