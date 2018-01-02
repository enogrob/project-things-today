#!/bin/bash
## Crafted (c) 2013~2018 by ZoatWorks Software LTDA.
## Prepared : Roberto Nogueira
## File     : .todayrc_vars.sh
## Version  : PA69
## Date     : 2018-01-02
## Project  : project-things-today
## Reference: bash
##
## Purpose  : Develop a system in order to help TODAY management directory
##            for projects.

# set -x

THINGS=$HOME/THINGS_HOME
TODO_DIR=$HOME/.todo

TODAY_LINK=$HOME/Today
PROJECTS_LINK=$HOME/Projects

AREAS=$THINGS/Areas
PROJECTS=$THINGS/Projects
RESOURCES=$THINGS/Resources
INBOX=$THINGS/Inbox
LOGBOOK=$THINGS/Logbook
SCHEDULED=$THINGS/Scheduled
SOMEDAY=$THINGS/Someday
SOMEDAYLOG=$THINGS/SomedayLog
TODAY=$THINGS/Today

CLOUD=$HOME/Google\ Drive/Things
LOCAL=$HOME/Things
DEBUG=false

TAGSFILE="$PROJECTS/.tags"
