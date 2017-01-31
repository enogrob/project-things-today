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

@test "01 - tdy" {
  # skip
  __setup
  run things today > /dev/null
  [ "$status" -eq 0 ]
  assert_line "$TODAY"
}

@test "02 - tdyi and tdye" {
  # skip
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

@test "03 - tdyia" {
  # skip
  __setup
  __save_today_and_tasks
  run things today startall > /dev/null
  [ "$status" -eq 0 ]
  __restore_today_and_tasks
}

@test "04 - tdyea" {
  # skip
  __setup
  __save_today_and_tasks

  run things today stopall > /dev/null
  [ "$status" -eq 0 ]
  assert_line "TODO: 0 of 0 tasks shown"
  [ ! -s "$TODO_DIR/todo.txt" ]

__restore_today_and_tasks
}

@test "05 - tdyl" {
  # skip
  __setup
  run things today list > /dev/null
  [ "$status" -eq 0 ]
}

@test "06 - tdyj" {
  # skip
  __setup
  run things today jump > /dev/null
  [ "$status" -eq 0 ]
  assert_line "$TODAY"
}

@test "07 - tdyj <task>" {
  # skip
  __setup
  __rm_if_exists project-test
  __save_today_and_tasks

  things today stopall > /dev/null
  things projects new project-test > /dev/null
  things today start > /dev/null
  run things today jump 1 > /dev/null
  [ "$status" -eq 0 ]
  assert_line "$PROJECTS/project-test"

  things today stop > /dev/null
  __rm_if_exists project-test
  __restore_today_and_tasks
}

@test "08 - tdyj <task> bad arg" {
  # skip
  __setup
  __rm_if_exists project-test
  __save_today_and_tasks

  things today stopall > /dev/null
  things projects new project-test > /dev/null
  things today start > /dev/null
  run things today jump A > /dev/null
  [ "$status" -eq 1 ]
  echo "$output" | grep "Error: Bad argument"

  things today stop > /dev/null
  __rm_if_exists project-test
  __restore_today_and_tasks
}

@test "09 - tdyj <task> bad nr of args" {
  skip

}

@test "10 - tdyj bad nr of args" {
  skip

}

@test "11 - tdya" {
  # skip
  __setup
  run things today archive > /dev/null
  [ "$status" -eq 0 ]
  assert_line "TODO: /Users/enogrob/.todo/todo.txt archived."
}
