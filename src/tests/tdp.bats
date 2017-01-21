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

@test "01 - tdp with no parameter" {
  __setup
  run things projects > /dev/null
  [ "$status" -eq 0 ]
  assert_line "$PROJECTS"
}

@test "02 - tdpl with no parameter" {
  __setup
  run things projects list > /dev/null
  [ "$status" -eq 0 ]
  echo "$output" | grep "$PROJECTS"
}

@test "03 - tdpl with one parameter" {
  __setup
  run things projects list erlang,elixir,cpp > /dev/null
  [ "$status" -eq 0 ]
  echo "$output" | grep "==> Projects with tag(s):*.*erlang,elixir,cpp"
}

@test "04 - tdpl with more than one argument" {
  __setup
  run things projects list erlang elixir > /dev/null
  [ "$status" -eq 1 ]
  echo "$output" | grep "Error: Bad number of arguments"
}

@test "05 - tdpn with no argument" {
  __setup
  run things projects new > /dev/null
  [ "$status" -eq 1 ]
  echo "$output" | grep "Error: Bad number of arguments"
}

@test "06 - tdpn with one argument" {
  __setup
  __rm_if_exists project-test
  run things projects new project-test > /dev/null
  [ "$status" -eq 0 ]
  assert [ -e "$PROJECTS/project-test" ]
  assert_line "$PROJECTS/project-test	project"
}

@test "07 - tdpn with two arguments" {
  __setup
  __rm_if_exists project-test
  run things projects new project-test udemy > /dev/null
  [ "$status" -eq 0 ]
  assert [ -e "$PROJECTS/project-test" ]
  assert_line "$PROJECTS/project-test	udemy"
}

@test "08 - tdpn with three arguments one type" {
  __setup
  __rm_if_exists project-test
  run things projects new Project Test udemy > /dev/null
  [ "$status" -eq 0 ]
  assert [ -e "$PROJECTS/project-test" ]
  assert_line "$PROJECTS/project-test	udemy"
  __rm_if_exists project-test
}

@test "09 - tdpn with three arguments no type" {
  __setup
  __rm_if_exists project-test-notype
  run things projects new Project Test NoType > /dev/null
  [ "$status" -eq 0 ]
  assert [ -e "$PROJECTS/project-test-notype" ]
  assert_line "$PROJECTS/project-test-notype	project"
  __rm_if_exists project-test-notype
}

@test "10 - tdpj with no parameter" {
  __setup
  run things projects jump > /dev/null
  [ "$status" -eq 0 ]
  assert_line "$PROJECTS"
}

@test "11 - tdpl with one parameter" {
  __setup
  __rm_if_exists project-test
  run things projects new project-test > /dev/null
  run things projects jump project-test > /dev/null
  [ "$status" -eq 0 ]
  echo "$output" | grep "$PROJECTS/project-test"
  __rm_if_exists project-test
}

@test "12 - tdpl with one parameter but bad argument" {
  __setup
  __rm_if_exists project-test
  run things projects new project-test > /dev/null
  run things projects jump project-xxxx > /dev/null
  [ "$status" -eq 1 ]
  echo "$output" | grep "Error: Bad argument project-xxxx"
  __rm_if_exists project-test
}

@test "13 - tdpl with more than one argument" {
  __setup
  __rm_if_exists project-test
  run things projects new project-test > /dev/null
  run things projects jump project-test project > /dev/null
  [ "$status" -eq 1 ]
  echo "$output" | grep "Error: Bad number of arguments"
  __rm_if_exists project-test
}

@test "14 - tdphi with no parameter" {
  __setup
  __rm_if_exists project-test
  things projects new project-test > /dev/null
  run things projects home start > /dev/null
  [ "$status" -eq 0 ]
  echo "$output" | grep "$PROJECTS/project-test"
  __rm_if_exists project-test
}

@test "15 - tdph with no parameter" {
  __setup
  __rm_if_exists project-test
  things projects new project-test > /dev/null
  things projects home start > /dev/null
  run things today > /dev/null
  [ "$status" -eq 0 ]
  echo "$output" | grep "$TODAY"
  run things projects home > /dev/null
  [ "$status" -eq 0 ]
  echo "$output" | grep "$PROJECTS/project-test"
  __rm_if_exists project-test
}
