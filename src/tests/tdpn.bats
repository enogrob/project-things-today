#!/usr/bin/env bats
#!./test/libs/bats/bin/bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'

source ~/.todayrc

__rm_if_exists() {
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
  __rm_if_exists project-test
  run things projects new project-test
  [ "$status" -eq 0 ]
  assert [ -e "$PROJECTS/project-test" ]
  assert_line "$PROJECTS/project-test	project"
}

@test "03 - tdpn with two arguments" {
  __rm_if_exists project-test
  run things projects new project-test udemy > /dev/null
  [ "$status" -eq 0 ]
  assert [ -e "$PROJECTS/project-test" ]
  assert_line "$PROJECTS/project-test	udemy"
}

@test "04 - tdpn with three arguments one type" {
  __rm_if_exists project-test
  run things projects new Project Test udemy > /dev/null
  [ "$status" -eq 0 ]
  assert [ -e "$PROJECTS/project-test" ]
  assert_line "$PROJECTS/project-test	udemy"
  __rm_if_exists project-test
}

@test "05 - tdpn with three arguments no type" {
  __rm_if_exists project-test-notype
  run things projects new Project Test NoType > /dev/null
  [ "$status" -eq 0 ]
  assert [ -e "$PROJECTS/project-test-notype" ]
  assert_line "$PROJECTS/project-test-notype	project"
  __rm_if_exists project-test-notype
}
