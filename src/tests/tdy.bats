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
      rm -Rf "$PROJECTS/$1";
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
  skip
}

@test "03 - tdy with two parameters" {
  skip
}

@test "04 - tdy with more than two argument" {
  skip
}
