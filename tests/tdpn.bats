#!/usr/bin/env bats
#!./test/libs/bats/bin/bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'

source ~/.todayrc

__setup() {
  if [ -d "$PROJECTS/$1" ]; then
    rm -Rf "$PROJECTS/$1";
  fi
}

@test "01 - tdpn with no arguments" {
  run things projects new
  [ "$status" -eq 1 ]
  echo "$output" | grep "Error: Bad number of arguments"
}

@test "02 - tdpn with one argument" {
  __setup project-test
  run things projects new project-test
  [ "$status" -eq 0 ]
  assert [ -e "$PROJECTS/project-test" ]
  assert_equal "$(tag -l $PROJECTS/project-test)" "$PROJECTS/project-test	project"
}

@test "03 - tdpn with two arguments" {
  __setup project-test
  run things projects new project-test udemy > /dev/null
  [ "$status" -eq 0 ]
  assert [ -e "$PROJECTS/project-test" ]
  assert_equal "$(tag -l $PROJECTS/project-test)" "$PROJECTS/project-test	udemy"
}

@test "04 - tdpn with three arguments one type" {
  __setup project-test
  run things projects new Project Test udemy > /dev/null
  [ "$status" -eq 0 ]
  assert [ -e "$PROJECTS/project-test" ]
  assert_equal "$(tag -l $PROJECTS/project-test)" "$PROJECTS/project-test	udemy"
}

@test "05 - tdpn with three arguments no type" {
  __setup project-test-notype
  run things projects new Project Test NoType > /dev/null
  [ "$status" -eq 0 ]
  assert [ -e "$PROJECTS/project-test-notype" ]
  assert_equal "$(tag -l $PROJECTS/project-test-notype)" "$PROJECTS/project-test-notype	project"
}
