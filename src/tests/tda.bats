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

@test "01 - tda" {
  # skip
  __setup
  run things areas > /dev/null
  [ "$status" -eq 0 ]
  assert_line "$AREAS"
}

@test "02 - tdal" {
  # skip
  __setup
  run things areas list > /dev/null
  [ "$status" -eq 0 ]
  assert_line --partial "$AREAS"
  assert_line "$PWD"
}

@test "03 - tdai and tdae" {
  # skip
  __setup
  __rm_if_exists project-test

  #checking sucessful execution
  things projects new project-test > /dev/null
  run things areas start project > /dev/null
  [ "$status" -eq 0 ]

  #checking existence project symlink in Areas
  PROJECTDIR=`find "$AREAS/$AREA" -maxdepth 1 -name "*project-test"`
  [ -n "$PROJECTDIR" ] && readlink "$PROJECTDIR"
  [ "$status" -eq 0 ]

  #checking existence project symlink in Today
  PROJECTDIR=`find "$TODAY/$AREA" -maxdepth 1 -name "*project-test"`
  [ -n "$PROJECTDIR" ] && readlink "$PROJECTDIR"
  [ "$status" -eq 0 ]

  #checking sucessful execution
  run things areas stop > /dev/null
  [ "$status" -eq 0 ]

  #checking non-existence project symlink in Someday
  PROJECTDIR=`find "$AREAS/$AREA" -maxdepth 1 -name "*project-test"`
  [ -z "$PROJECTDIR" ]

  #checking non-existence project symlink in Someday
  PROJECTDIR=`find "$TODAY/$AREA" -maxdepth 1 -name "*project-test"`
  [ -z "$PROJECTDIR" ]

  __rm_if_exists project-test
}

@test "04 - tdai bad number of args" {
  # skip
  __setup

  run things areas start xxx project-test > /dev/null
  [ "$status" -eq 1 ]
  echo "$output" | grep "Error: Bad number of arguments"
}

@test "06 - tdai bad project type" {
  # skip
  __setup

  run things areas start xxx > /dev/null
  [ "$status" -eq 1 ]
  echo "$output" | grep "Error: Bad project type"
}

@test "07 - tdai bad arg" {
  # skip
  __setup
  __CURR_DIR=$PWD
  cd $TODAY

  run things areas start project  > /dev/null
  [ "$status" -eq 1 ]
  echo "$output" | grep "Error: Bad argument"

  cd $__CURR_DIR
}

@test "08 - tdae bad arg" {
  # skip
  __setup
  __CURR_DIR=$PWD
  cd $TODAY

  run things areas stop  > /dev/null
  [ "$status" -eq 1 ]
  echo "$output" | grep "Error: Bad argument"

  cd $__CURR_DIR
}
