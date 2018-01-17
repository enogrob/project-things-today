#!/bin/bash
## Crafted (c) 2013~2017 by ZoatWorks Software LTDA.
## Prepared : Roberto Nogueira
## File     : .todayrc_install.sh
## Version  : PA04
## Date     : 2017-12-30
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
  if [ ! -d "$HOME/bin" ]; then
    mkdir -p "$HOME/bin"
    chown $USER:$USER "$HOME/bin"
  fi
  cp ./tag ~/bin
  if [ ! -L "/Users" ]; then
      ln -sf /home /Users
      chown $USER:$USER /Users
  fi
  if [ ! -d "$HOME/Books" ]; then
    mkdir -p "$HOME/Books"
    chown $USER:$USER "$HOME/Books"
    touch $HOME/Books/My_Kindle_Content
    ln -sf "$HOME/Books/Calibre Library" "Calibre Library"
    ln -sf /media/psf/Calibre\ Library/ 'Calibre Library'
    ln -sf /media/psf/Calibre\ Library/ "$HOME/Books/Calibre Library"
    ln -sf /media/psf/My_Kindle_Content "$HOME/Books/My_Kindle_Content"
  fi
  if [ ! -d "/Volumes/Data HD" ]; then
      mkdir -p /Volumes/Data\ HD
      chown $USER:$USER /Volumes/Data\ HD
      ln -sf /home/$USER /Volumes/Data\ HD/$USER
      chown $USER:$USER /Volumes/Data\ HD/$USER
  fi
  if [ ! -f "$TAGSFILE" ]; then
    cp ./.tags "$PROJECTS"
  fi
fi

if [ ! -d "$HOME/Things" ]; then
  cp -rf ./Things "$HOME"
  chown $USER:$USER $HOME/Things
  ln -sf $LOCAL $HOME/THINGS_HOME
  ln -sf /media/psf/Home/Things $HOME/THINGS_HOME
else
  if [ ! -L $HOME/Things/Areas ] && [ ! -d $HOME/Things/Areas ]; then
    cp -rf ./Things/Areas $HOME/Things/Areas
    chown $USER:$USER $HOME/Things/Areas
  fi
  if [ ! -L $HOME/Things/Inbox ] && [ ! -d $HOME/Things/Inbox ]; then
    cp -rf ./Things/Inbox $HOME/Things/Inbox
    chown $USER:$USER $HOME/Things/Inbox
  fi
  if [ ! -L $HOME/Things/Logbook ] && [ ! -d $HOME/Things/Logbook ]; then
    cp -rf ./Things/Logbook $HOME/Things/Logbook
    chown $USER:$USER $HOME/Things/Logbook
  fi
  if [ ! -L $HOME/Things/Projects ] && [ ! -d $HOME/Things/Projects ]; then
    cp -rf ./Things/Projects $HOME/Things/Projects
    chown $USER:$USER $HOME/Things/Projects
  fi
  if [ ! -L $HOME/Things/Resources ] && [ ! -d $HOME/Things/Resources ]; then
    cp -rf ./Things/Resources $HOME/Things/Resources
    chown $USER:$USER $HOME/Things/Resources
  fi
  if [ ! -L $HOME/Things/Scheduled ] && [ ! -d $HOME/Things/Scheduled ]; then
    cp -rf ./Things/Scheduled $HOME/Things/Scheduled
    chown $USER:$USER $HOME/Things/Scheduled
  fi
  if [ ! -L $HOME/Things/Someday ] && [ ! -d $HOME/Things/Someday ]; then
    cp -rf ./Things/Someday $HOME/Things/Someday
    chown $USER:$USER $HOME/Things/Someday
  fi
  if [ ! -L $HOME/Things/SomedayLog ] && [ ! -d $HOME/Things/SomedayLog ]; then
    cp -rf ./Things/SomedayLog $HOME/Things/SomedayLog
    chown $USER:$USER $HOME/Things/SomedayLog
  fi
  if [ ! -L $HOME/Things/Trash ] && [ ! -d $HOME/Things/Trash ]; then
    cp -rf ./Things/Trash $HOME/Things/Trash
    chown $USER:$USER $HOME/Things/Trash
  fi
fi

if [ ! -L "$HOME/THINGS_HOME" ]; then
  ln -sf $LOCAL $HOME/THINGS_HOME
fi
if [ ! -L "$HOME/Projects" ]; then
  ln -sf $PROJECTS $HOME/Projects
  ln -sf /media/psf/Projects $HOME/Projects
fi
if [ ! -L "$HOME/Today" ]; then
  ln -sf $TODAY $HOME/Today
  ln -sf /media/psf/Today $HOME/Today
fi

exec bash
