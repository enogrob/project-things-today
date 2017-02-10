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

__save_today_and_tasks(){
  if [ ! -e "/tmp/Today" ]; then
    mkdir -p /tmp/Today
  fi

  cp -R "$TODAY/." /tmp/Today/
  cp "$TODO_DIR/todo.txt" /tmp
}

__restore_today_and_tasks(){
  find "$TODAY" -type l -delete
  cp -R /tmp/Today/. "$TODAY/"
  cp /tmp/todo.txt "$TODO_DIR/todo.txt"
  rm -f /tmp/todo.txt
  rm -rf /tmp/Today
}

@test "01 - tds" {
  # skip
  __setup
  run things scheduled > /dev/null
  [ "$status" -eq 0 ]
  assert_line "$SCHEDULED"
}

@test "02 - tdsl" {
  # skip
  __setup
  run things scheduled list > /dev/null
  [ "$status" -eq 0 ]
  assert_line --partial "$SCHEDULED"
  assert_line "$PWD"
}

@test "03 - tdsi and tdse" {
  # skip
  __setup
  __rm_if_exists project-test

  #checking sucessful execution
  things projects new project-test > /dev/null
  run things scheduled start > /dev/null
  [ "$status" -eq 0 ]

  #checking existence project symlink in Someday
  PROJECTDIR=`find "$SCHEDULED" -maxdepth 1 -name "*project-test"`
  [ -n "$PROJECTDIR" ] && readlink "$PROJECTDIR"
  [ "$status" -eq 0 ]

  #checking sucessful execution
  run things scheduled stop > /dev/null
  [ "$status" -eq 0 ]

  #checking non-existence project symlink in Someday
  PROJECTDIR=`find "$SCHEDULED" -maxdepth 1 -name "*project-test"`
  [ -z "$PROJECTDIR" ]

  __rm_if_exists project-test
}

@test "04 - tdsi and tdse <project>" {
  # skip
  __setup
  __rm_if_exists project-test

  #checking sucessful execution
  things projects new project-test > /dev/null
  run things scheduled start project-test > /dev/null
  [ "$status" -eq 0 ]

  #checking existence project symlink in Someday
  PROJECTDIR=`find "$SCHEDULED" -maxdepth 1 -name "*project-test"`
  [ -n "$PROJECTDIR" ] && readlink "$PROJECTDIR"
  [ "$status" -eq 0 ]

  #checking sucessful execution
  run things scheduled stop project-test > /dev/null
  [ "$status" -eq 0 ]

  #checking non-existence project symlink in Someday
  PROJECTDIR=`find "$SCHEDULED" -maxdepth 1 -name "*project-test"`
  [ -z "$PROJECTDIR" ]

  __rm_if_exists project-test
}

@test "05 - tdsi bad nr of args" {
  # skip
  __setup

  run things scheduled start mon tue project-test > /dev/null
  [ "$status" -eq 1 ]
  echo "$output" | grep "Error: Bad number of arguments"
}

@test "06 - tdse bad nr of args" {
  # skip
  __setup

  run things scheduled stop mon tue project-test  > /dev/null
  [ "$status" -eq 1 ]
  echo "$output" | grep "Error: Bad number of arguments"
}

@test "07 - tdsi bad day" {
  # skip
  __setup
  __rm_if_exists project-test

  things projects new project-test > /dev/null
  run things scheduled start xxx project-test > /dev/null
  [ "$status" -eq 1 ]
  echo "$output" | grep "Error: Bad day"

  __rm_if_exists project-test
}

@test "08 - tdsi bad arg" {
  # skip
  __setup

  run things scheduled start mon project-test > /dev/null
  [ "$status" -eq 1 ]
  echo "$output" | grep "Error: Bad argument"
}

@test "08 - tdse bad arg" {
  # skip
  __setup

  run things scheduled stop project-test > /dev/null
  [ "$status" -eq 1 ]
  echo "$output" | grep "Error: Bad argument"
}

@test "09 - tdss" {
  # skip
  __setup

  run things scheduled summary > /dev/null
  [ "$status" -eq 0 ]
  assert_line --partial "mon tue wed thu fri sat sun"
}

@test "10 - tdss <tags>" {
  # skip
  __setup

  run things scheduled summary project > /dev/null
  [ "$status" -eq 0 ]
  assert_line --partial "mon tue wed thu fri sat sun"
}

@test "11 - tdss bad nr of args" {
  # skip
  __setup

  run things scheduled summary project project > /dev/null
  [ "$status" -eq 1 ]
  echo "$output" | grep "Error: Bad number of arguments"
}
