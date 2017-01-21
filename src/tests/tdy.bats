#!/usr/bin/env bats
#!./test/libs/bats/bin/bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'

__setup() {
  source ~/.todayrc
}

__rm_if_exists() {
  if [ -d "$PROJECTS/$1" ]; then
    if [ -n "$1"  ]; then
      rm -Rf "$PROJECTS/$1"
    fi
  fi
}

@test "01 - tdy" {
  __setup
  run things today > /dev/null
  [ "$status" -eq 0 ]
  assert_line "$TODAY"
}

@test "02 - tdyi" {
  __setup
  __rm_if_exists project-test
  things projects new project-test > /dev/null
  run things today start > /dev/null
  [ "$status" -eq 0 ]

  PROJECTDIR=`find "$TODAY" -maxdepth 1 -name "*project-test"`
  echo $PROJECTDIR
  LINK=`basename $PROJECTDIR`
  echo $LINK
  [ -L "$TODAY/$LINK" ]

  things today stop > /dev/null
  __rm_if_exists project-test
}

@test "03 - tdy with two parameters" {
  skip
}

@test "04 - tdy with more than two argument" {
  skip
}
