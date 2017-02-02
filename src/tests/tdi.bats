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

@test "01 - tdi" {
  # skip
  __setup
  run things inbox > /dev/null
  [ "$status" -eq 0 ]
  assert_line "$INBOX"
}

@test "02 - tdil" {
  # skip
  __setup
  run things inbox list > /dev/null
  [ "$status" -eq 0 ]
  assert_line --partial "$INBOX"
  assert_line "$PWD"
}
