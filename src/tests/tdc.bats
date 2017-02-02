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
  if [ -d "$CLOUD/Projects/$1" ]; then
    if [ -n "$1"  ]; then
      rm -Rf "$CLOUD/Projects/$1"
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

@test "01 - tdc" {
  # skip
  __setup

  run things cloud > /dev/null
  [ "$status" -eq 0 ]
  assert_line --partial "=> Listing TODAY configuration..."
  assert_line --partial "-- THINGS  :"
  assert_line --partial "$THINGS"
}

@test "02 - tdci" {
  # skip
  __setup

  run things cloud start > /dev/null
  [ "$status" -eq 0 ]
  assert_line --partial "=> Configuring THINGS to CLOUD..."
  assert_line --partial "-- THINGS  :"
  assert_line --partial "$CLOUD"

  run things cloud stop > /dev/null
}

@test "03 - tdci already to CLOUD" {
  # skip
  __setup
  things cloud start > /dev/null

  run things cloud start > /dev/null
  [ "$status" -eq 0 ]
  assert_line --partial "=> THINGS already to CLOUD"

  run things cloud stop > /dev/null
}

@test "04 - tdce" {
  # skip
  __setup
  things cloud start > /dev/null

  run things cloud stop > /dev/null
  [ "$status" -eq 0 ]
  assert_line --partial "=> Configuring THINGS to LOCAL..."
  assert_line --partial "-- THINGS  :"
  assert_line --partial "$LOCAL"
}

@test "05 - tdce already to LOCAL" {
  # skip
  __setup
  things cloud stop > /dev/null

  run things cloud stop > /dev/null
  [ "$status" -eq 0 ]
  assert_line --partial "=> THINGS already to LOCAL"
}

@test "06 - tdcc" {
  # skip
  __setup
  __rm_if_exists project-test

  things projects new project-test > /dev/null
  run things cloud copy > /dev/null
  [ "$status" -eq 0 ]
  [ -e "$CLOUD/Projects/$PROJECT" ]

  __rm_if_exists project-test
}
