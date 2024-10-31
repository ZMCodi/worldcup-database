#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games";)

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # add teams into teams table
  # add winners first
  if [[ $WINNER != 'winner' ]]
  then
    # check if team_id exists in teams table
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER';")
    # if not found
    if [[ -z $TEAM_ID ]]
    then
      # insert new team
      INSERT_NEW_TEAM=$($PSQL "INSERT INTO teams (name) VALUES ('$WINNER');")
      if [[ $INSERT_NEW_TEAM == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $WINNER
      fi
    fi
  fi


  # add opponents
  if [[ $OPPONENT != 'opponent' ]]
  then
     # check if team_id exists in teams table
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT';")
    # if not found
    if [[ -z $TEAM_ID ]]
    then
      # insert new team
      INSERT_NEW_TEAM=$($PSQL "INSERT INTO teams (name) VALUES ('$OPPONENT');")
      if [[ $INSERT_NEW_TEAM == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $OPPONENT
      fi
    fi
  fi
done

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
    # add games into games table
  if [[ $YEAR != 'year' ]]
  then
    # get winner id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER';")
    # get opponent id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT';")

    # add entries
    INSERT_GAME=$($PSQL "INSERT INTO games (year, winner_id, opponent_id, winner_goals, opponent_goals, round) VALUES ($YEAR, $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS, '$ROUND');")
    if [[ $INSERT_GAME == "INSERT 0 1" ]]
    then
      echo inserted game $YEAR, $ROUND, $WINNER vs $OPPONENT
    fi

  fi
done



