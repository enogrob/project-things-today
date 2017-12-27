#!/bin/bash
## Crafted (c) 2013~2017 by ZoatWorks Software LTDA.
## Prepared : Roberto Nogueira
## File     : .todayrc_install.sh
## Version  : PA02
## Date     : 2018-12-27
## Project  : project-things-today
## Reference: bash
##
## Purpose  : Develop a system in order to help TODAY management directory
##            for projects.

# set -x

cp ./.todayrc.sh ~/
cp ./.todayrc_vars.sh ~/

source ./.todayrc_vars.sh

OS=`uname`
if [ $OS == "Linux" ]; then
  cp ./tag ~/bin
  if [ ! -L "/Users" ]; then
      ln -sf /home /Users
  fi
  if [ ! -d "$HOME/Books" ]; then
    mkdir -p "$HOME/Books"
    chown enogrob:enogrob "$HOME/Books"
    touch $HOME/Books/My_Kindle_Content
    touch $HOME/Books/Calibre\ Library
  fi
  if [ ! -d "/Volumes/Data HD" ]; then
      mkdir -p /Volumes/Data\ HD
      chown enogrob:enogrob /Volumes/Data\ HD
      chmod 777 /Volumes/Data\ HD
      ln -sf /home/enogrob /Volumes/Data\ HD/enogrob
  fi
  if [ ! -f "$TAGSFILE" ]; then
    cp ./.tags "$PROJECTS"
  fi
fi

if [ ! -d "$HOME/Things" ]; then
  cp -rf ./Things "$HOME"
  ln -sf $LOCAL $HOME/THINGS_HOME
else
  if [ ! -L $HOME/Things/Areas ] && [ ! -d $HOME/Things/Areas ]; then
    cp -rf ./Things/Areas $HOME/Things/Areas
  fi
  if [ ! -L $HOME/Things/Inbox ] && [ ! -d $HOME/Things/Inbox ]; then
    cp -rf ./Things/Inbox $HOME/Things/Inbox
  fi
  if [ ! -L $HOME/Things/Logbook ] && [ ! -d $HOME/Things/Logbook ]; then
    cp -rf ./Things/Logbook $HOME/Things/Logbook
  fi
  if [ ! -L $HOME/Things/Projects ] && [ ! -d $HOME/Things/Projects ]; then
    cp -rf ./Things/Projects $HOME/Things/Projects
  fi
  if [ ! -L $HOME/Things/Resources ] && [ ! -d $HOME/Things/Resources ]; then
    cp -rf ./Things/Resources $HOME/Things/Resources
  fi
  if [ ! -L $HOME/Things/Scheduled ] && [ ! -d $HOME/Things/Scheduled ]; then
    cp -rf ./Things/Scheduled $HOME/Things/Scheduled
  fi
  if [ ! -L $HOME/Things/Someday ] && [ ! -d $HOME/Things/Someday ]; then
    cp -rf ./Things/Someday $HOME/Things/Someday
  fi
  if [ ! -L $HOME/Things/SomedayLog ] && [ ! -d $HOME/Things/SomedayLog ]; then
    cp -rf ./Things/SomedayLog $HOME/Things/SomedayLog
  fi
  if [ ! -L $HOME/Things/Trash ] && [ ! -d $HOME/Things/Trash ]; then
    cp -rf ./Things/Trash $HOME/Things/Trash
  fi
fi

if [ ! -L "$HOME/THINGS_HOME" ]; then
  ln -sf $LOCAL $HOME/THINGS_HOME
fi
if [ ! -L "$HOME/Projects" ]; then
  ln -sf $PROJECTS $HOME/Projects
fi
if [ ! -L "$HOME/Today" ]; then
  ln -sf $TODAY $HOME/Today
fi

exec bash
