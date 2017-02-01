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

@test "01 - tdl" {
  # skip
  __setup
  run things logbook > /dev/null
  [ "$status" -eq 0 ]
  assert_line "$LOGBOOK"
}

@test "02 - tdll" {
  # skip
  __setup
  run things logbook list > /dev/null
  [ "$status" -eq 0 ]
  assert_line --partial "$LOGBOOK"
  assert_line "$PWD"
}

@test "03 - tdli and tdle" {
  # skip
  __setup
  __rm_if_exists project-test

  #checking sucessful execution
  things projects new project-test > /dev/null
  run things projects logbook start > /dev/null
  [ "$status" -eq 0 ]

  #checking existence project symlink in Logbook
  PROJECTDIR=`find "$LOGBOOK" -maxdepth 1 -name "*project-test"`
  [ -n "$PROJECTDIR" ] && readlink "$PROJECTDIR"
  [ "$status" -eq 0 ]

  #checking sucessful execution
  run things logbook stop > /dev/null
  [ "$status" -eq 0 ]

  #checking non-existence project symlink in Logbook
  PROJECTDIR=`find "$LOGBOOK" -maxdepth 1 -name "*project-test"`
  [ -z "$PROJECTDIR" ]

  __rm_if_exists project-test
}

@test "04 - tdli and tdle <project>" {
  # skip
  __setup
  __rm_if_exists project-test

  #checking sucessful execution
  things projects new project-test > /dev/null
  run things projects logbook start project-test > /dev/null
  [ "$status" -eq 0 ]

  #checking existence project symlink in Logbook
  PROJECTDIR=`find "$LOGBOOK" -maxdepth 1 -name "*project-test"`
  [ -n "$PROJECTDIR" ] && readlink "$PROJECTDIR"
  [ "$status" -eq 0 ]

  #checking sucessful execution
  run things logbook stop project-test > /dev/null
  [ "$status" -eq 0 ]

  #checking non-existence project symlink in Logbook
  PROJECTDIR=`find "$LOGBOOK" -maxdepth 1 -name "*project-test"`
  [ -z "$PROJECTDIR" ]

  __rm_if_exists project-test
}

@test "05 - tdli bad number of args" {
  # skip
  __setup

  run things logbook start project-test project > /dev/null
  [ "$status" -eq 1 ]
  echo "$output" | grep "Error: Bad number of arguments"
}

@test "06 - tdle bad number of args" {
  # skip
  __setup

  run things logbook stop project-test project > /dev/null
  [ "$status" -eq 1 ]
  echo "$output" | grep "Error: Bad number of arguments"
}

@test "07 - tdli bad arg" {
  # skip
  __setup

  run things logbook start project-test > /dev/null
  [ "$status" -eq 1 ]
  echo "$output" | grep "Error: Bad argument"
}

@test "08 - tdle bad arg" {
  # skip
  __setup

  run things logbook stop project-test > /dev/null
  [ "$status" -eq 1 ]
  echo "$output" | grep "Error: Bad argument"
}
