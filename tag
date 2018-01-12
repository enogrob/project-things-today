#!/bin/bash
## Crafted (c) 2013~2018 by ZoatWorks Software LTDA.
## Prepared : Roberto Nogueira
## File     : .todayrc_linux.sh
## Version  : PA09
## Date     : 2018-01-12
## Project  : project-things-today
## Reference: bash
##
## Purpose  : Develop a system in order to help TODAY management directory
##            for projects.

# set -x

__contains() {
    local n=$#
    local value=${!n}
    for ((i=1;i < $#;i++)) {
        if [[ ${!i} == "${value}" ]]; then
            echo "y"
            return 0
        fi
    }
    echo "n"
    return 1
}

source ~/.todayrc_vars.sh

case $1 in
  -l)
    if [ $2 == "." ]; then
      P=`basename "$PWD"`
    else
      P=`basename "$2"`
    fi
    grep "^$P\s" $TAGSFILE
    ;;
  -lN)
    if [ $2 == "." ]; then
      P=`basename "$PWD"`
    else
      P=`basename "$2"`
    fi
    grep "^$P\s" $TAGSFILE | awk '{print $2}'
    ;;
  -a)
    if [ $3 == "." ]; then
      P=`basename "$PWD"`
    else
      P=`basename "$3"`
    fi
    PROJNAME=(`grep "^$P\s" $TAGSFILE | awk '{print $1}'`)
    if [ -z $PROJNAME ]; then
      TAGS=(`echo $2 | sed 's/,/ /g'`)
      TAGS=($(echo "${TAGS[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))
      TAGS=`echo "${TAGS[@]}" | sed 's/ /,/g'`
      echo -e "$P $TAGS" >> $TAGSFILE
    else
      TAGS=(`grep "^$P\s" $TAGSFILE | awk '{print $2}' | sed 's/,/ /g'`)
      TAGS+=(`echo $2 | sed 's/,/ /g'`)
      TAGS=($(echo "${TAGS[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))
      TAGS=`echo "${TAGS[@]}" | sed 's/ /,/g'`
      sed -i "/^$P\s.*/c $P $TAGS" $TAGSFILE
    fi
    ;;
  -r)
    if [ $3 == "." ]; then
      P=`basename "$PWD"`
    else
      P=`basename "$3"`
    fi
    TAGS=(`grep "^$P\s" $TAGSFILE | awk '{print $2}' | sed 's/,/ /g'`)
    TAGSDEL=(`echo $2 | sed 's/,/ /g'`)
    for del in ${TAGSDEL[@]}
    do
      TAGS=("${TAGS[@]/$del}") #Quotes when working with strings
    done
    TAGS=($(echo "${TAGS[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))
    TAGS=`echo "${TAGS[@]}" | sed 's/ /,/g'`
    sed -i "/^$P\s.*/c $P $TAGS" $TAGSFILE
    ;;
  -m)
    TAGS=(`echo $2 | sed 's/,/ /g'`)
    while read line; do
      PROJTAGS=(`echo $line | awk '{print $2}' | sed 's/,/ /g'`)
      PROJNAME=(`echo $line | awk '{print $1}'`)
      for _tag in ${TAGS[@]}
      do
        if [ $(__contains "${PROJTAGS[@]}" "$_tag") == "y" ]; then
          echo "$PROJNAME"
        fi
      done
    done < $TAGSFILE
    ;;
esac
