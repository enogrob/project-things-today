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

@test "01 - tdgi, tdg and tdge" {
  # skip
  __setup
  __rm_if_exists project-test

  things projects new project-test > /dev/null
  run things git start > /dev/null
  [ "$status" -eq 0 ]
  assert_line --partial "Initialized empty Git repository in /Users/enogrob/Things/Projects/project-test/.git/"
  assert_line --partial "Updating origin"
  assert_line --partial "created repository: enogrob/project-test"
  assert_line --partial "first commit"
  assert_line --partial "To git@github.com:enogrob/project-test.git"
  assert_line --partial "* [new branch]      master -> master"

  rm -f README.md

  run things git > /dev/null
  [ "$status" -eq 0 ]
  assert_line " D README.md"

  run things git stop performed update > /dev/null
  [ "$status" -eq 0 ]
  assert_line --partial "performed update"
  assert_line --partial "1 file changed"
  assert_line --partial "To git@github.com:enogrob/project-test.git"

  __rm_if_exists project-test
}
