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

@test "02 - tdyi and tdye" {
  __setup
  __rm_if_exists project-test

  #checking sucessful execution
  things projects new project-test > /dev/null
  run things today start > /dev/null
  [ "$status" -eq 0 ]

  #checking existence project symlink in Today
  PROJECTDIR=`find "$TODAY" -maxdepth 1 -name "*project-test"`
  [ -n "$PROJECTDIR" ] && readlink "$PROJECTDIR"
  [ "$status" -eq 0 ]

  #checking existent project task
  TASK=$($TODOTXT list $PROJECT | head -1)
  [ -n "$TASK" ]

  #checking sucessful execution
  run things today stop > /dev/null
  [ "$status" -eq 0 ]

  #checking non-existence project symlink in Today
  PROJECTDIR=`find "$TODAY" -maxdepth 1 -name "*project-test"`
  [ -z "$PROJECTDIR" ]

  #checking non-existent project task
  $TODOTXT archive
  TASK=$($TODOTXT list $PROJECT | head -1)
  [ -z "$TASK" ] && echo true

  __rm_if_exists project-test
}
