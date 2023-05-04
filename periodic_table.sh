#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
ELEM="SELECT * FROM elements WHERE"

table_response() {
  QUERY="$($PSQL "SELECT * FROM elements FULL JOIN properties ON elements.atomic_number=properties.atomic_number WHERE elements.atomic_number='$1'")"
  echo $QUERY | while IFS='|' read NUM SYM NAME NUM MASS MELT BOIL TYPE
  do
  REALTYPE="$($PSQL "SELECT type FROM types WHERE type_id=$TYPE")"
  echo "The element with atomic number $NUM is $NAME ($SYM). It's a $REALTYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
  done
}

argument_test() {
#test if argument is an atomic_number
if [[ "$1" = [0-9]* && $($PSQL "$ELEM atomic_number=$1") ]]
then
  NUM=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
  table_response $NUM

# test if argument is atomic symbol
elif [[ $($PSQL "$ELEM symbol='$1'") ]]
then
  NUM=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1'")
  table_response $NUM
# test if argument is atomic name
elif [[ $($PSQL "$ELEM name='$1'") ]]
then
  NUM=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1'")
  table_response $NUM
# if no argument or argument not in database
elif [[ -z $1 ]]
then
  echo Please provide an element as an argument.
else
  echo I could not find that element in the database.
fi
}

argument_test $1
