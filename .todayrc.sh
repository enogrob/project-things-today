#!/bin/bash
## Crafted (c) 2013~2019 by ZoatWorks Software LTDA.
## Prepared : Roberto Nogueira
## File     : .todayrc.sh
## Version  : PA86
## Date     : 2020-10-01
## Project  : project-things-today
## Reference: bash
##
## Purpose  : Develop a system in order to help TODAY management directory
##            for projects.

# set -x

source ~/.todayrc_vars.sh

shopt -s extglob

TAGSPROJECTS='+(aws|chrome|codewars|conf|coursera|ebook|edx|exercism|futurelearn|graphacademy|hackerrank|javabrains|job|krishnamurti|lab360|linkedin|linuxacademy|oreilly|phoenix|pragmaticstudio|project|rails|sololearn|specialization|tutorial|tutorialspoint|udemy|jetbrains|research)'
TAGSCONTEXTS='+(anki|bash|bigdata|bluemix|bootstrap|chartjs|cpp|css|delphi|design|devops|docker|elixir|elm|erlang|grails|groovy|hadoop|html|java|javascript|jekyll|jquery|nodejs|neo4j|phoenix|python|r|rails|reactjs|roblox|rspec|ruby|scratch|spring|sinatra|springboot|sql|sveltejs|unix|vim|vuejs|webpack|youtube|stimulusreflex)'

TODOTXT=$HOME/.todo/todo.sh

alias rc='__print $(rvm current) red'
alias t='$TODOTXT'
alias tl='$TODOTXT list'
alias reload='exec bash'
alias projects='cd projects;tree'

alias tdy='things today'
alias tdyl='things today list'
alias tdyi='things today start'
alias tdye='things today stop'
alias tdyia='things today startall'
alias tdyea='things today stopall'
alias tdyj='things today jump'
alias tdya='things today archive'

alias tdp='things projects'
alias tdpl='things projects list'
alias tdpn='things projects new'
alias tdpj='things projects jump'
alias tdph='things projects home'
alias tdphi='things projects home start'

alias tda='things areas'
alias tdal='things areas list'
alias tdai='things areas start'
alias tdae='things areas stop'

alias tdl='things logbook'
alias tdll='things logbook list'
alias tdli='things logbook start'
alias tdle='things logbook stop'

alias tdsd='things someday'
alias tdsdl='things someday list'
alias tdsdi='things someday start'
alias tdsde='things someday stop'
alias tdsdr='things someday random'
alias tdsdrl='things someday random list'
alias tdsdrs='things someday random scheduled'
alias tdsdri='things someday random start'
alias tdsdre='things someday random stop'

alias tdsdlg='things somedaylog'
alias tdsdlgl='things somedaylog list'
alias tdsdlgi='things somedaylog start'
alias tdsdlge='things somedaylog stop'

alias tdc='things cloud'
alias tdci='things cloud start'
alias tdce='things cloud stop'
alias tdcc='things cloud copy'

alias tdi='things inbox'
alias tdil='things inbox list'

alias tdg='things git'
alias tdgi='things git start'
alias tdge='things git stop'
alias tdgl='things git log'
alias tdglg='things git graph'

alias tds='things scheduled'
alias tdsl='things scheduled list'
alias tdss='things scheduled summary'
alias tdsi='things scheduled start'
alias tdse='things scheduled stop'
alias tdsia='things scheduled startall'
alias tdsea='things scheduled stopall'

alias tdei='exercism configure --dir=$PWD'
alias tdti='__templates_init'
alias tdd='cd ~/Downloads'

title(){
  title=$1
  if [ -z "$title" ]; then
    title=$(basename "$PWD")
  fi
  export PROMPT_COMMAND='echo -ne "\033]0;${title##*/}\007"'
}

src(){
  cd src
  if [ -e ".ruby-gemset" ] && [ -e ".ruby-version" ]; then
    __print $(rvm current) red
  fi
  tree -L 1
}

logshell(){
  P2=$*
  FILENAME=`echo $P2 | sed 's/ /-/g'`
  FILELOG=$(date +%Y%m%d%H%M)"_$FILENAME.log"
  script $FILELOG
}

mdread(){
    pandoc "$1" -f markdown -t html | lynx -stdin
}

__tdsdrl() {
  local tags
  IFS=$'\n' read -d '' -ra tags
  if [ ! ${#tags[@]} -eq 0 ]; then
    for i in "${tags[@]}"; do
      things someday random list ${tags[$i]}
    done
  fi
  unset tags
}

__random() {
  local projects_list
  IFS=$'\n' read -d '' -ra projects_list
  i=$(( $RANDOM % ${#projects_list[@]} ))
  # echo ${#projects_list[@]}
  echo ${projects_list[$i]}
  unset project_list
}

__contains() {
    local n=$#
    local value=${!n}
    for ((i=1;i < $#;i++)) {
        if [[ ${!i} == *"${value}"* ]]; then
            echo "y"
            return 0
        fi
    }
    echo "n"
    return 1
}

__gettag() {
    local n=$#
    local value=${!n}
    for ((i=1;i < $#;i++)) {
        if [[ ${!i} == *"${value}"* ]]; then
            echo ${!i}
            return 0
        fi
    }
    echo ""
}

__print(){
    if [ $# -eq 0 ]; then
        echo -e ""
    elif [ $# -eq 1 ]; then
        echo -e "\033[1;39m$1 \033[0m"
    elif [ $# -eq 2 ]; then
        case $2 in
            red)
                echo -e "\033[31m$1 \033[0m"
                ;;
            green)
                echo -e "\033[32m$1 \033[0m"
                ;;
            yellow)
                echo -e "\033[33m$1 \033[0m"
                ;;
            blue)
                echo -e "\033[34m$1 \033[0m"
                ;;
            magenta)
                echo -e "\033[35m$1 \033[0m"
                ;;
            cyan)
                echo -e "\033[36m$1 \033[0m"
                ;;
            lightred)
                echo -e "\033[1;91m$1 \033[0m"
                ;;
            lightgreen)
                echo -e "\033[1;92m$1 \033[0m"
                ;;
            lightyellow)
                echo -e "\033[1;93m$1 \033[0m"
                ;;
            lightblue)
                echo -e "\033[1;94m$1 \033[0m"
                ;;
            lightmagenta)
                echo -e "\033[1;95m$1 \033[0m"
                ;;
            lightcyan)
                echo -e "\033[1;96m$1 \033[0m"
                ;;
            *)
                echo -e "\033[1;39m$1 \033[0m"
                ;;
        esac
    else
        __printerr "=> Error: Bad number of arguments."
        __print
        return 1
    fi
}

__printerr(){
    echo -e "\033[31m$1 \033[0m"
}

__is_Things() {
if [ "$1" == "`readlink $THINGS`" ]
  then
    # 0 = true
    return 0
  else
    # 1 = false
    return 1
  fi
}

__templates_init(){
  cp $RESOURCES/templates/* .
}

__icon(){
  __replace_icon "$PWD" "$RESOURCES/images/$1"
  tag -a $1 "$PWD"
}

__replace_icon(){
    droplet=$1
    icon=$2".icns"
    if [[ $icon =~ ^https?:// ]]; then
        curl -sLo /tmp/icon $icon
        icon=/tmp/icon
    fi
    if [ -e $droplet$'/Icon\r' ]; then
      rm -rf $droplet$'/Icon\r'
    fi
    sips -i $icon >/dev/null
    DeRez -only icns $icon > /tmp/icns.rsrc
    Rez -append /tmp/icns.rsrc -o $droplet$'/Icon\r'
    SetFile -a C $droplet
    SetFile -a V $droplet$'/Icon\r'
}

__task_name(){
    local TASKNAME=`basename $1`
    local TASKTAGS=(`tag -lN $1 | sed 's/,/ /g'`)

    for n in "${TASKTAGS[@]}"
    do
        case $n in
            $TAGSPROJECTS)
                TASKNAME=$TASKNAME" +"$n
                ;;
        esac
    done
    for n in "${TASKTAGS[@]}"
    do
        case $n in
            $TAGSCONTEXTS)
                TASKNAME=$TASKNAME" @"$n
                ;;
        esac
    done
    echo $TASKNAME
}

__tag_contexts(){
    local PROJECTNAME=`basename $1`
    local PROJECTTAGS=(`echo $PROJECTNAME | sed 's/-/ /g'`)

    for n in "${PROJECTTAGS[@]}"
    do
        case $n in
            $TAGSCONTEXTS)
            tag -a $n "$1"
            ;;
        esac
    done
    return 0
}

__scheduled(){
    if [ $# -eq 0 ]; then
        local DAYOFWEEK=$(echo $(date +"%a") | awk '{print tolower($0)}')
        pushd . &>/dev/null
        cd "$PROJECTS"
        tag -m scheduled > $PROJECTS/PROJECTS-SCHEDULED.txt
        __print "mon tue wed thu fri sat sun  start        stop" green
        while read line; do
            local PROJTAGS=(`tag -lN $line | sed 's/,/ /g'`)
            local SCHEDULED=""
            if [ $(__contains "${PROJTAGS[@]}" "mon") == "y" ]; then
                SCHEDULED=" x |";
            else
                SCHEDULED="   |";
            fi
            if [ $(__contains "${PROJTAGS[@]}" "tue") == "y" ]; then
                SCHEDULED=$SCHEDULED" x |";
            else
                SCHEDULED=$SCHEDULED"   |";
            fi
            if [ $(__contains "${PROJTAGS[@]}" "wed") == "y" ]; then
                SCHEDULED=$SCHEDULED" x |";
            else
                SCHEDULED=$SCHEDULED"   |";
            fi
            if [ $(__contains "${PROJTAGS[@]}" "thu") == "y" ]; then
                SCHEDULED=$SCHEDULED" x |";
            else
                SCHEDULED=$SCHEDULED"   |";
            fi
            if [ $(__contains "${PROJTAGS[@]}" "fri") == "y" ]; then
                SCHEDULED=$SCHEDULED" x |";
            else
                SCHEDULED=$SCHEDULED"   |";
            fi
            if [ $(__contains "${PROJTAGS[@]}" "sat") == "y" ]; then
                SCHEDULED=$SCHEDULED" x |";
            else
                SCHEDULED=$SCHEDULED"   |";
            fi
            if [ $(__contains "${PROJTAGS[@]}" "sun") == "y" ]; then
                SCHEDULED=$SCHEDULED" x |";
            else
                SCHEDULED=$SCHEDULED"   |";
            fi

            if [ $(__is_scheduled_with_dates "$line") == "y" ];
            then
              DATESTART=$(__gettag "${PROJTAGS[@]}" "start")
              IFS=':' read -ra DATETAG <<< "$DATESTART"
              SCHEDULED=$SCHEDULED" ${DATETAG[1]} |";
              DATESTOP=$(__gettag "${PROJTAGS[@]}" "stop")
              IFS=':' read -ra DATETAG <<< "$DATESTOP"
              SCHEDULED=$SCHEDULED" ${DATETAG[1]} |";
            else
              SCHEDULED=$SCHEDULED"            |";
              SCHEDULED=$SCHEDULED"            |";
            fi

            if [ $(__is_scheduled_with_dates "$line") == "y" ];
            then
              if [ $(__is_active "$line") == "y" ];
              then
                if [ $(__contains "${PROJTAGS[@]}" $DAYOFWEEK) == "y" ]; then
                    __print "$SCHEDULED $line"
                else
                    __print "$SCHEDULED $line" cyan
                fi
              else
                __print "$SCHEDULED $line" red
              fi
            else
              if [ $(__contains "${PROJTAGS[@]}" $DAYOFWEEK) == "y" ]; then
                  __print "$SCHEDULED $line"
              else
                  __print "$SCHEDULED $line" cyan
              fi
            fi

        done < $PROJECTS/PROJECTS-SCHEDULED.txt
    else
        local DAYOFWEEK=$1
        pushd . &>/dev/null
        cd "$PROJECTS"
        DAYOFWEEK=(`echo $DAYOFWEEK | sed 's/,/ /g'`)

        for m in "${DAYOFWEEK[@]}"
        do
          case $m in
              mon|tue|wed|thu|fri|sat|sun|scheduled)
                  tag -m "${m}" >> $PROJECTS/PROJECTS-SCHEDULED.txt
                  ;;
              *)  tag -m "${m},scheduled" >> $PROJECTS/PROJECTS-SCHEDULED.txt
                  ;;
          esac
        done

        cat $PROJECTS/PROJECTS-SCHEDULED.txt | sort | uniq > $PROJECTS/PROJECTS-SCHEDULED_TEMP.txt
        rm -f $PROJECTS/PROJECTS-SCHEDULED.txt
        mv $PROJECTS/PROJECTS-SCHEDULED_TEMP.txt $PROJECTS/PROJECTS-SCHEDULED.txt

        __print "mon tue wed thu fri sat sun  start        stop" green
        while read line; do
            local PROJTAGS=(`tag -lN $line | sed 's/,/ /g'`)
            local SCHEDULED=""
            if [ $(__contains "${PROJTAGS[@]}" "mon") == "y" ]; then
                SCHEDULED=" x |";
            else
                SCHEDULED="   |";
            fi
            if [ $(__contains "${PROJTAGS[@]}" "tue") == "y" ]; then
                SCHEDULED=$SCHEDULED" x |";
            else
                SCHEDULED=$SCHEDULED"   |";
            fi
            if [ $(__contains "${PROJTAGS[@]}" "wed") == "y" ]; then
                SCHEDULED=$SCHEDULED" x |";
            else
                SCHEDULED=$SCHEDULED"   |";
            fi
            if [ $(__contains "${PROJTAGS[@]}" "thu") == "y" ]; then
                SCHEDULED=$SCHEDULED" x |";
            else
                SCHEDULED=$SCHEDULED"   |";
            fi
            if [ $(__contains "${PROJTAGS[@]}" "fri") == "y" ]; then
                SCHEDULED=$SCHEDULED" x |";
            else
                SCHEDULED=$SCHEDULED"   |";
            fi
            if [ $(__contains "${PROJTAGS[@]}" "sat") == "y" ]; then
                SCHEDULED=$SCHEDULED" x |";
            else
                SCHEDULED=$SCHEDULED"   |";
            fi
            if [ $(__contains "${PROJTAGS[@]}" "sun") == "y" ]; then
                SCHEDULED=$SCHEDULED" x |";
            else
                SCHEDULED=$SCHEDULED"   |";
            fi

            if [ $(__is_scheduled_with_dates "$line") == "y" ];
            then
              DATESTART=$(__gettag "${PROJTAGS[@]}" "start")
              IFS=':' read -ra DATETAG <<< "$DATESTART"
              SCHEDULED=$SCHEDULED" ${DATETAG[1]} |";
              DATESTOP=$(__gettag "${PROJTAGS[@]}" "stop")
              IFS=':' read -ra DATETAG <<< "$DATESTOP"
              SCHEDULED=$SCHEDULED" ${DATETAG[1]} |";
            else
              SCHEDULED=$SCHEDULED"            |";
              SCHEDULED=$SCHEDULED"            |";
            fi

            if [ $(__is_scheduled_with_dates "$line") == "y" ];
            then
              if [ $(__is_active "$line") == "y" ];
              then
                if [ $(__contains "${PROJTAGS[@]}" $DAYOFWEEK) == "y" ]; then
                    __print "$SCHEDULED $line"
                else
                    __print "$SCHEDULED $line" cyan
                fi
              #else
              #  __print "$SCHEDULED $line" red
              fi
            else
              if [ $(__contains "${PROJTAGS[@]}" $DAYOFWEEK) == "y" ]; then
                  __print "$SCHEDULED $line"
              else
                  __print "$SCHEDULED $line" cyan
              fi
            fi

        done < $PROJECTS/PROJECTS-SCHEDULED.txt
    fi
    rm -f $PROJECTS/PROJECTS-SCHEDULED.txt
    popd &>/dev/null
}

__is_scheduled_with_dates() {
  local PROJECT=$1
  local PROJTAGS=(`tag -lN "$PROJECTS/$PROJECT" | sed 's/,/ /g'`)

if [ $(__contains "${PROJTAGS[@]}" "start") == "y" ] && [ $(__contains "${PROJTAGS[@]}" "stop") == "y" ];
then
  echo "y"
else
  echo "n"
fi
}

__is_active() {
  local PROJECT=$1
  local PROJTAGS=(`tag -lN "$PROJECTS/$PROJECT" | sed 's/,/ /g'`)
  local DAYOFWEEK=$(echo $(date +"%a") | awk '{print tolower($0)}')

  if [ $(__contains "${PROJTAGS[@]}" "scheduled") == "y" ]; then
    if [ $(__contains "${PROJTAGS[@]}" "mon") == "y" ] || \
       [ $(__contains "${PROJTAGS[@]}" "tue") == "y" ] || \
       [ $(__contains "${PROJTAGS[@]}" "wed") == "y" ] || \
       [ $(__contains "${PROJTAGS[@]}" "thu") == "y" ] || \
       [ $(__contains "${PROJTAGS[@]}" "fri") == "y" ] || \
       [ $(__contains "${PROJTAGS[@]}" "sat") == "y" ] || \
       [ $(__contains "${PROJTAGS[@]}" "sun") == "y" ]; then
       if [ $(__is_scheduled_with_dates "$1") == "y" ]; then
         DATETODAY=$(date +%s)
         for i in "${PROJTAGS[@]}"; do
           if [ $(__contains "$i" "start") == "y" ]; then
             IFS=':' read -ra DATETAG <<< "$i"
             DATESTART=$(date -j -f '%Y-%m-%d' "${DATETAG[1]}" '+%s')
           fi
           if [ $(__contains "$i" "stop") == "y" ]; then
             IFS=':' read -ra DATETAG <<< "$i"
             DATESTOP=$(date -j -f '%Y-%m-%d' "${DATETAG[1]}" '+%s')
           fi
         done
         if [ $DATETODAY -ge $DATESTART ] && [ $DATETODAY -le $DATESTOP ]; then
           echo "y"
         else
           echo "n"
         fi
       else
         echo "y"
       fi
     else
       echo "n"
     fi
  else
    echo "n"
  fi
}

__remove_random_tag_from(){
pushd .
if [ $1 = "$TODAY" ]; then
  tag -m random | awk '{print $3}' | awk '{print var"/"$1}' var="$PROJECTS" | xargs -t -L 1 tag -r random
else
  tag -m random | awk '{print $1}' | awk '{print var"/"$1}' var="$PROJECTS" | xargs -t -L 1 tag -r random
fi
popd
}

__remove_today_tags(){
pushd .
  tag -m today | awk '{print $1}' | awk '{print var"/"$1}' var="$PROJECTS" | xargs -t -L 1 tag -r today
popd
}

__remove_from_Someday() {
  if [ -e "$SOMEDAY/$PROJECT" ]; then
      tag -r someday "$SOMEDAY/$PROJECT"
      rm -f "$SOMEDAY/$PROJECT";
  fi
}

__remove_from_SomedayLog() {
  if [ -e "$SOMEDAYLOG/$PROJECT" ]; then
      tag -r somedaylog "$SOMEDAYLOG/$PROJECT"
      rm -f "$SOMEDAYLOG/$PROJECT";
      PROJTAGS=(`tag -lN "$PROJECTS/$PROJECT" | sed 's/,/ /g'`)
      for i in "${PROJTAGS[@]}"; do
        if [ $(__contains "$i" "random") == "y" ]; then
          tag -r random "$PROJECTS/$PROJECT"
        fi
      done
  fi
}

__remove_from_LogBook() {
  if [ -e "$LOGBOOK/$PROJECT" ]; then
      tag -r logbook "$LOGBOOK/$PROJECT"
      rm -f "$LOGBOOK/$PROJECT";
    fi
}

__remove_from_Scheduled() {
  if [ -e "$SCHEDULED/$PROJECT" ]; then
      rm -f "$SCHEDULED/$PROJECT";
  fi
  DAYOFWEEK=(`tag -lN "$PROJECTS/$PROJECT" | sed 's/,/ /g'`)
  for m in "${DAYOFWEEK[@]}"
  do
    case $m in
      mon|tue|wed|thu|fri|weekday)
          tag -r $m "$PROJECTS/$PROJECT"
          ;;
      sat|sun|weekend)
          tag -r $m "$PROJECTS/$PROJECT"
          ;;
      scheduled)
          tag -r $m "$PROJECTS/$PROJECT"
          ;;
      everyday)
          tag -r $m "$PROJECTS/$PROJECT"
          ;;
    esac
    if [ $(__contains $m "start") == "y" ]; then
      tag -r $m "$PROJECTS/$PROJECT"
    fi
    if [ $(__contains $m "stop") == "y" ]; then
      tag -r $m "$PROJECTS/$PROJECT"
    fi
  done
}

__insert_in_Today(){
  local PROJECT=$1
  local PROJECTDIR=`find "$PROJECTS" -maxdepth 1 -name "$1"`
  echo $PROJECTDIR
  if [ -n "$PROJECTDIR" ]; then
      PROJECTDIR=`find "$TODAY" -maxdepth 1 -lname "$PROJECTS/$1"`
      if [ -z "$PROJECTDIR" ]; then
          $TODOTXT -t add $(__task_name "$PROJECTS/$1") #due:$(date +"%Y-%M-%d")
          ln -sf "$PROJECTS/$1" "$TODAY/$($TODOTXT -@+ list | grep -w "$1" | head -1)"
          tag -a today "$PROJECTS/$1"
      fi
  fi
}

__remove_from_Today(){
if [ -L "$TODAY/$($TODOTXT -@+ list | grep -w "$PROJECT" | head -1)" ]; then
    rm -f "$TODAY/$($TODOTXT -@+ list | grep -w "$PROJECT" | head -1)"
    TASK=$($TODOTXT list $PROJECT)
    TASK=$(echo $TASK | grep -o -E '^[0-9]+')
    $TODOTXT -a do $TASK
    tag -r today "$PROJECTS/$PROJECT"
fi
}

things() {
    case $1 in
        areas)
            shift
            case $1 in
                list)
                    tree -L 1 -Cd -l "$AREAS"
                    pwd
                    #open -g "$AREAS"
                    ;;

                start)
                    shift
                    if [ $# -eq 1 ]; then
                        PROJECT=`basename "$PWD"`
                        AREA=$1
                    else
                        __printerr "==> Error: Bad number of arguments."
                        __print
                        return 1
                    fi
                    case $AREA in
                         $TAGSPROJECTS)
                         ;;
                         *)
                         __printerr "==> Error: Bad project type."
                         __print
                         return 1
                         ;;
                    esac
                    PROJECTDIR=`find "$PROJECTS" -maxdepth 1 -name "$PROJECT"`
                    if [ -n "$PROJECTDIR" ]; then
                        if [ ! -L "$AREAS/$AREA/$($TODOTXT -@+ list $PROJECT | head -1)" ]; then
                            ln -sf "$PWD" "$AREAS/$AREA/$($TODOTXT -@+ list | grep -w "$PROJECT" | head -1)";
                        fi
                        if [ ! -L "$TODAY/$AREA" ]; then ln -sf "$AREAS/$AREA" "$TODAY/$AREA" ; fi
                    else
                        __printerr "==> Error: Bad argument $PROJECT."
                        __print
                        return 1
                    fi
                    #open -g "$TODAY"
                    ;;

                stop)
                    PROJECT=`basename "$PWD"`
                    AREADIR=`find "$AREAS" -name $PROJECT`
                    if [ -n "$AREADIR" ]; then
                       AREADIRNAME=`dirname "$AREADIR"`
                       AREA=`basename "$AREADIRNAME"`
                       if [ -L "$AREAS/$AREA/$($TODOTXT -@+ list | grep -w "$PROJECT" | head -1)" ]; then
                           rm -f "$AREAS/$AREA/$($TODOTXT -@+ list | grep -w "$PROJECT" | head -1)";
                       fi
                       if [ -L "$TODAY/$AREA" ]; then
                          files=("$AREAS/$AREA/*")
                          if [ ${#files[@]} -lt 2 ]; then rm -f "$TODAY/$AREA"; fi
                       fi
                    else
                      __printerr "==> Error: Bad argument $PROJECT."
                      __print
                      return 1
                    fi
                    cd "$TODAY"
                    #open -g .
                    ;;

                *)
                    cd "$AREAS"
                    pwd
                    #open -g .
                    ;;
            esac
            ;;

        projects)
            shift
            case $1 in
                list)
                    shift
                    pushd . &>/dev/null
                    cd "$PROJECTS"
                    if [ $# -eq 0 ]; then
                        ls -la | awk '{print $9}' | tr -d '/' >> $PROJECTS/PROJECTS.txt
                        #open -g "$PROJECTS"
                    elif [ $# -eq 1 ]; then
                        local PROJTAGS=$1
                        PROJTAGS=(`echo $PROJTAGS | sed 's/,/ /g'`)

                        for m in "${PROJTAGS[@]}"
                        do
                            tag -m "${m}" >> $PROJECTS/PROJECTS.txt
                        done
                    else
                        __printerr "==> Error: Bad number of arguments."
                        __print
                        return 1
                    fi
                    cat $PROJECTS/PROJECTS.txt | sort | uniq > $PROJECTS/PROJECTS_TEMP.txt
                    rm -f $PROJECTS/PROJECTS.txt
                    mv $PROJECTS/PROJECTS_TEMP.txt $PROJECTS/PROJECTS.txt
                    # printf "==> Projects with tag(s): "
                    # __print $1 green
                    while read line; do
                            __print $line cyan
                    done < $PROJECTS/PROJECTS.txt
                    rm -f $PROJECTS/PROJECTS.txt
                    popd &>/dev/null
                    ;;

                new)
                    shift

                    if [ $# -eq 0 ]; then
                        __printerr "==> Error: Bad number of arguments."
                        __print
                        return 1
                    elif [ $# -eq 1 ]; then
                        export PROJECT=`echo $1 | awk '{print tolower($0)}'`
                        export PROJECT_TYPE=project
                    else
                       length=$(($#-1))
                        P1=${@:1:$length}
                        export PROJECT_TYPE=${@: -1}
                        P2=`echo $P1 | awk '{print tolower($0)}'`
                        export PROJECT=`echo $P2 | sed 's/ /-/g'`
                        case $PROJECT_TYPE in
                            $TAGSPROJECTS)
                                ;;
                            *)  length=$(($#))
                                P1=${@:1:$length}
                                P2=`echo $P1 | awk '{print tolower($0)}'`
                                PROJECT=`echo $P2 | sed 's/ /-/g'`
                                PROJECT_TYPE=project
                                ;;
                        esac
                    fi
                    case $PROJECT_TYPE in
                        $TAGSPROJECTS)
                            cp -rf "$RESOURCES/project-types/$PROJECT_TYPE" "$PROJECTS/$PROJECT"
                            tag -a $PROJECT_TYPE "$PROJECTS/$PROJECT"
                            __tag_contexts "$PROJECTS/$PROJECT"
                            ;;
                        *)  __printerr "==> Error: Bad project type."
                            __print
                            return 1
                            ;;
                    esac
                    cd "$PROJECTS/$PROJECT"
                    #open -g .
                    tag -l "$PROJECTS/$PROJECT"
                    ;;

                jump)
                    shift
                    if [ $# -eq 0 ]; then
                        cd "$PROJECTS"
                    elif [ $# -eq 1 ]; then
                        if [ -e "$PROJECTS/$1" ]; then
                                cd "$PROJECTS/$1"
                                title "$1"
                            else
                                __printerr "==> Error: Bad argument $1."
                                __print
                                return 1
                            fi
                    else
                        __printerr "==> Error: Bad number of arguments."
                        __print
                        return 1
                    fi
                    pwd
                    ;;

                home)
                    shift
                    if [ $# -eq 0 ]; then
                        CURRENT_PROJECT=`echo $PWD | awk -F"/" '{print $6}'`
                        cd "$PROJECTS/$CURRENT_PROJECT"
                    elif [ $# -eq 1 ]; then
                      case $1 in
                        start)
                          export PROJECT=`basename "$PWD"`
                          ;;

                        *)
                          __printerr "==> Error: Bad argument $1."
                          __print
                          return 1
                          ;;
                      esac
                    else
                      __printerr "==> Error: Bad number of arguments."
                      __print
                      return 1
                    fi
                    pwd
                    ;;

                *)
                    cd "$PROJECTS"
                    #open -g .
                    pwd
                    ;;
            esac
            ;;

        today)
            shift
            if [ $# -eq 0 ]; then
                cd "$TODAY"
                #open -g .
                pwd
            elif [ $# -eq 1 ]; then
                case $1 in
                    start)
                        PROJECT=`basename "$PWD"`
                        __insert_in_Today "$PROJECT"
                        tree -L 1 -Cd -l "$TODAY"
                        $TODOTXT list
#                        open -g "$TODAY"
                        ;;

                    stop)
                        PROJECT=`basename "$PWD"`
                        PROJECTDIR=`find "$PROJECTS" -maxdepth 1 -name "$PROJECT"`
                        if [ -n "$PROJECTDIR" ]; then
                            AREADIR=`find "$AREAS" -name "$($TODOTXT -@+ list $PROJECT | head -1)"`
                            if [ -n "$AREADIR" ]; then
                               AREADIRNAME=`dirname "$AREADIR"`
                               AREA=`basename "$AREADIRNAME"`
                               if [ -e "$AREAS/$AREA/$($TODOTXT -@+ list | grep -w "$PROJECT" | head -1)" ]; then
                                   rm -f "$AREAS/$AREA/$($TODOTXT -@+ list | grep -w "$PROJECT" | head -1)";
                               fi
                               if [ -e "$TODAY/$AREA" ]; then
                                  files=($AREAS/$AREA/*)
                                  if [ ${#files[@]} -lt 2 ]; then rm -f "$TODAY/$AREA"; fi
                               fi
                            fi
                            if [ -L "$TODAY/$($TODOTXT -@+ list | grep -w "$PROJECT" | head -1)" ]; then
                                rm -f "$TODAY/$($TODOTXT -@+ list | grep -w "$PROJECT" | head -1)"
                                tag -r today "$PROJECTS/$PROJECT"

                                PROJTAGS=(`tag -lN "$PROJECTS/$PROJECT" | sed 's/,/ /g'`)
                                for i in "${PROJTAGS[@]}"; do
                                  if [ $(__contains "$i" "random") == "y" ]; then
                                    things somedaylog start
                                  fi
                                done

                                TASK=$($TODOTXT list $PROJECT)
                                TASK=$(echo $TASK | grep -o -E '^[0-9]+')
                                $TODOTXT -a do $TASK
                                if [ $(__is_scheduled_with_dates $PROJECT) == "y" ];
                                then
                                  DATETODAY=$(date +%s)
                                  PROJTAGS=(`tag -lN "$PROJECTS/$PROJECT" | sed 's/,/ /g'`)
                                  for i in "${PROJTAGS[@]}"; do
                                    if [ $(__contains "$i" "start") == "y" ]; then
                                      IFS=':' read -ra DATETAG <<< "$i"
                                      DATESTART=$(date -j -f '%Y-%m-%d' "${DATETAG[1]}" '+%s')
                                    fi
                                    if [ $(__contains "$i" "stop") == "y" ]; then
                                      IFS=':' read -ra DATETAG <<< "$i"
                                      DATESTOP=$(date -j -f '%Y-%m-%d' "${DATETAG[1]}" '+%s')
                                    fi
                                  done
                                  if [ $DATETODAY -ge $DATESTART ] && [ $DATETODAY -ge $DATESTOP ];
                                  then
                                    __remove_from_Scheduled
                                  fi
                                fi
                            fi

                        fi
                        cd "$TODAY"
                        $TODOTXT list
                        #open -g .
                        ;;

                    startall)
                        DAYOFWEEK=`echo $(date +"%a") | awk '{print tolower($0)}'`
                        cd "$PROJECTS"
                        RESULT=(`tag -m $DAYOFWEEK`)
                        for m in "${RESULT[@]}"
                        do
                          PROJECT="${m}"
                          PROJTAGS=(`tag -lN $PROJECT | sed 's/,/ /g'`)
                          if [ $(__is_scheduled_with_dates "$PROJECT") == "y" ];
                          then
                            if [ $(__is_active $PROJECT) == "y" ];
                            then
                              __insert_in_Today "$PROJECT"
                            fi
                          else
                            __insert_in_Today "$PROJECT"
                          fi
                        done
                        cd "$TODAY"
                        $TODOTXT list
                        #open -g .
                        ;;

                    stopall)
                        __remove_random_tag_from "$TODAY"
                        __remove_today_tags
                        find "$TODAY" -type l -delete
                        cat /dev/null > $TODO_DIR/todo.txt
                        cd "$TODAY"
                        $TODOTXT list
                        #open -g .
                        ;;

                    list)
                        #open -g "$TODAY"
                        tree -L 1 -Cd -l "$TODAY"
                        # $TODOTXT list
                        ;;

                    jump)
                        cd "$TODAY"
                        title "$PROJECT"
                        pwd
                        ;;

                    archive)
                        find "$TODAY" -type l -delete
                        $TODOTXT archive
                        $TODOTXT -p+@ list > $TODAY/TODOLIST.txt
                        while read line; do
                            PROJECT=`echo $line | awk '{print  $3}'`
                            if [ ! -e "$TODAY/$PROJECT" ]; then
                                if [ -e "$PROJECTS/$PROJECT" ]; then
                                    ln -sf "$PROJECTS/$PROJECT" "$TODAY/$line"
                                fi
                            fi
                        done < $TODAY/TODOLIST.txt
                        rm -f $TODAY/TODOLIST.txt
                        cd "$TODAY"
                        $TODOTXT list
                        #open -g .
                        ;;
                esac
            elif [ $# -eq 2 ]; then
                case $1 in
                    start)
                        shift
                        if [ $# -eq 0 ]; then
                          PROJECT=`basename "$PWD"`
                        elif [ $# -eq 1 ]; then
                          PROJECTDIR=`find "$PROJECTS" -maxdepth 1 -name "$1"`
                          if [ -n "$PROJECTDIR" ]; then
                            PROJECT=$1
                          else
                            PROJTAGS=$1
                            pushd . &>/dev/null
                            cd "$PROJECTS"
                            PROJTAGS=(`echo $PROJTAGS | sed 's/,/ /g'`)

                            for m in "${PROJTAGS[@]}"
                            do
                              tag -m "${m}" >> $PROJECTS/PROJECTS.txt
                            done

                            cat $PROJECTS/PROJECTS.txt | sort | uniq > $PROJECTS/PROJECTS_TEMP.txt
                            rm -f $PROJECTS/PROJECTS.txt
                            mv $PROJECTS/PROJECTS_TEMP.txt $PROJECTS/PROJECTS.txt

                            IFS=$'\n' read -d '' -ra PROJECTSLIST < $PROJECTS/PROJECTS.txt

                            i=$(( $RANDOM % ${#PROJECTSLIST[@]} ))
                            PROJECT=${PROJECTSLIST[$i]}
                            rm -f $PROJECTS/PROJECTS.txt
                            popd &>/dev/null
                          fi
                        else
                          __printerr "==> Error: Bad number of arguments."
                          __print
                          return 1
                        fi
                        __insert_in_Today "$PROJECT"
                        tree -L 1 -Cd -l "$TODAY"
                        $TODOTXT list
                        #open -g "$TODAY"
                        ;;

                    jump)
                        shift
                        re='^[0-9]+$'
                        if [[ $1 =~ $re ]] ; then
                            cd "$PROJECTS"
                            PROJECT=$($TODOTXT list | grep "^$1" | awk {'print $3'})
                            if [ -n "$PROJECT" ]; then
                              cd $PROJECT
                              title "$PROJECT"
                              pwd
                            else
                              __printerr "==> Error: Bad argument $1."
                              __print
                              return 1
                            fi
                        else
                            __printerr "==> Error: Bad argument $1."
                            __print
                            return 1
                        fi
                        ;;
                esac
            else
                __printerr "==> Error: Bad number of arguments."
                __print
                return 1
            fi
            ;;

        inbox)
            shift
            case $1 in
                list)
                    tree -L 1 -Cd -l "$INBOX"
                    pwd
                    #open -g "$INBOX"
                    ;;
                *)
                    cd "$INBOX"
                    pwd
                    #open -g .
            esac
            ;;

        logbook)
            shift
            case $1 in
                list)
                    tree -L 1 -Cd -l "$LOGBOOK"
                    pwd
                    #open -g "$LOGBOOK"
                    ;;

                start)
                    shift
                    if [ $# -eq 0 ]; then
                        PROJECT=`basename "$PWD"`
                    elif [ $# -eq 1 ]; then
                        PROJECT=$1
                    else
                        __printerr "==> Error: Bad number of arguments."
                        __print
                        return 1
                    fi
                    PROJECTDIR=`find "$PROJECTS" -maxdepth 1 -name $PROJECT`
                    if [ -n "$PROJECTDIR" ]; then
                        if [ ! -e "$LOGBOOK/$PROJECT" ]; then
                            ln -sf "$PWD" "$LOGBOOK/$PROJECT";
                            tag -a logbook "$LOGBOOK/$PROJECT"
                        fi
                        __remove_from_Scheduled
                        __remove_from_Someday
                        __remove_from_Today
                    else
                        __printerr "==> Error: Bad argument $PROJECT."
                        __print
                        return 1
                    fi
                    #open -g "$LOGBOOK"
                    ;;

                stop)
                    shift
                    if [ $# -eq 0 ]; then
                        PROJECT=`basename "$PWD"`
                    elif [ $# -eq 1 ]; then
                        PROJECT=$1
                    else
                        __printerr "==> Error: Bad number of arguments."
                        __print
                        return 1
                    fi
                    PROJECTDIR=`find "$PROJECTS" -maxdepth 1 -name $PROJECT`
                    if [ -n "$PROJECTDIR" ]; then
                        __remove_from_LogBook
                    else
                        __printerr "==> Error: Bad argument $PROJECT."
                        __print
                        return 1
                    fi
                    #open -g "$LOGBOOK"
                    ;;

                *)
                    cd "$LOGBOOK"
                    pwd
                    #open -g .
            esac
            ;;

        scheduled)
            shift
            case $1 in
                list)
                    tree -L 1 -Cd -l "$SCHEDULED"
                    pwd
                    #open -g "$SCHEDULED"
                    ;;

                summary)
                    shift
                    if [ $# -eq 0 ]; then
                        __scheduled
                    elif [ $# -eq 1 ]; then
                        __scheduled $1
                    else
                        __printerr "==> Error: Bad number of arguments."
                        __print
                        return 1
                    fi
                    ;;

                start)
                    shift
                    if [ $# -eq 0 ]; then
                        PROJECT=`basename "$PWD"`
                        DAYOFWEEK=(`echo $(date +"%a") | awk '{print tolower($0)}'`)
                    elif [ $# -eq 1 ]; then
                        PROJECTDIR=`find "$PROJECTS" -maxdepth 1 -name $1`
                        if [ -n "$PROJECTDIR" ]; then
                            PROJECT=$1
                            DAYOFWEEK=(`echo $(date +"%a") | awk '{print tolower($0)}'`)
                        else
                            PROJECT=`basename "$PWD"`
                            DAYOFWEEK=(`echo $1 | sed 's/,/ /g'`)
                        fi
                    elif [ $# -eq 2 ]; then
                        PROJECT=$2
                        DAYOFWEEK=(`echo $1 | sed 's/,/ /g'`)
                    else
                        __printerr "==> Error: Bad number of arguments."
                        __print
                        return 1
                    fi
                    PROJECTDIR=`find "$PROJECTS" -maxdepth 1 -name $PROJECT`
                    if [ -n "$PROJECTDIR" ]; then
                        if [ ! -e ""$SCHEDULED"/$PROJECT" ]; then
                            ln -sf "$PWD" "$SCHEDULED/$PROJECT";
                        fi
                        for m in "${DAYOFWEEK[@]}"
                        do
                          case $m in
                              mon|tue|wed|thu|fri)
                                tag -a "scheduled,weekday,$m" "$PROJECTS/$PROJECT"
                                ;;
                              sat|sun)
                                tag -a "scheduled,weekend,$m" "$PROJECTS/$PROJECT"
                                ;;
                              everyday)
                                tag -a "scheduled,everyday,weekend,mon,tue,wed,thu,fri,sat,sun" "$PROJECTS/$PROJECT"
                                ;;
                              weekday)
                                tag -a "scheduled,weekday,mon,tue,wed,thu,fri" "$PROJECTS/$PROJECT"
                                ;;
                              weekend)
                                tag -a "scheduled,weekend,sat,sun" "$PROJECTS/$PROJECT"
                                ;;

                              *)
                                if [ $(__contains $m "start") == "y" ]; then
                                  tag -a "$m" "$PROJECTS/$PROJECT"
                                elif [ $(__contains $m "stop") == "y" ]; then
                                  tag -a "$m" "$PROJECTS/$PROJECT"
                                else
                                  __printerr "==> Error: Bad day: $m"
                                  __print
                                  return 1
                                fi
                                ;;
                          esac
                        done
                        __remove_from_Someday
                        __remove_from_SomedayLog
                        __remove_from_LogBook
                      else
                        __printerr "==> Error: Bad argument $PROJECT."
                        __print
                        return 1
                      fi
                    ;;

                stop)
                    shift
                    if [ $# -eq 0 ]; then
                        PROJECT=`basename "$PWD"`
                    elif [ $# -eq 1 ]; then
                        PROJECT=$1
                    else
                        __printerr "==> Error: Bad number of arguments."
                        __print
                        return 1
                    fi
                    PROJECTDIR=`find "$PROJECTS" -maxdepth 1 -name $PROJECT`
                    if [ -n "$PROJECTDIR" ]; then
                        __remove_from_Scheduled
                        __remove_from_Today
                    else
                        __printerr "==> Error: Bad argument $PROJECT."
                        __print
                      return 1
                    fi
                    ;;

                startall)
                    pushd . &>/dev/null
                    cd "$PROJECTS"
                    tag -m scheduled > $PROJECTS/PROJECTS-SCHEDULED.txt
                    while read line; do
                        ln -sf "$PROJECTS/$line" "$SCHEDULED/$line"
                    done < $PROJECTS/PROJECTS-SCHEDULED.txt
                    rm -f $PROJECTS/PROJECTS-SCHEDULED.txt
                    popd &>/dev/null
                    #open -g "$SCHEDULED"
                    ;;

                stopall)
                    find "$SCHEDULED" -type l -delete
                    #open -g "$SCHEDULED"
                    ;;
                *)
                    cd "$SCHEDULED"
                    pwd
                    #open -g .
            esac
            ;;

        someday)
            shift
            case $1 in
                list)
                    shift
                    pushd . &>/dev/null
                    cd "$PROJECTS"
                    if [ $# -eq 0 ]; then
                        tag -m "someday" >> $SOMEDAY/PROJECTS.txt
                        #open -g "$SOMEDAY"
                    elif [ $# -eq 1 ]; then
                        local PROJTAGS=$1
                        PROJTAGS=(`echo $PROJTAGS | sed 's/,/ /g'`)

                        for m in "${PROJTAGS[@]}"
                        do
                            tag -m "someday,$m" >> $SOMEDAY/PROJECTS.txt
                        done
                    else
                        __printerr "==> Error: Bad number of arguments."
                        __print
                        return 1
                    fi
                    cat $SOMEDAY/PROJECTS.txt | sort | uniq > $SOMEDAY/PROJECTS_TEMP.txt
                    rm -f $SOMEDAY/PROJECTS.txt
                    mv $SOMEDAY/PROJECTS_TEMP.txt $SOMEDAY/PROJECTS.txt
                    # printf "==> Projects with tag(s): "
                    # __print $1 green
                    while read line; do
                      __print $line cyan
                    done < $SOMEDAY/PROJECTS.txt
                    rm -f $SOMEDAY/PROJECTS.txt
                    popd &>/dev/null
                    ;;

                start)
                    shift
                    if [ $# -eq 0 ]; then
                        PROJECT=`basename "$PWD"`
                    elif [ $# -eq 1 ]; then
                        PROJECT=$1
                    else
                        __printerr "==> Error: Bad number of arguments."
                        __print
                        return 1
                    fi
                    PROJECTDIR=`find "$PROJECTS" -maxdepth 1 -name $PROJECT`
                    if [ -n "$PROJECTDIR" ]; then
                        if [ ! -e "$SOMEDAY/$PROJECT" ]; then
                            ln -sf "$PROJECTS/$PROJECT" "$SOMEDAY/$PROJECT";
                            tag -a someday "$PROJECTS/$PROJECT"
                        fi
                        __remove_from_SomedayLog
                        __remove_from_Scheduled
                        __remove_from_LogBook
                        __remove_from_Today
                    else
                        __printerr "==> Error: Bad argument $PROJECT."
                        __print
                        return 1
                    fi
                    #open -g "$SOMEDAY"
                    ;;

                stop)
                    shift
                    if [ $# -eq 0 ]; then
                        PROJECT=`basename "$PWD"`
                    elif [ $# -eq 1 ]; then
                        PROJECT=$1
                    else
                        __printerr "==> Error: Bad number of arguments."
                        __print
                        return 1
                    fi

                    PROJECTDIR=`find "$PROJECTS" -name $PROJECT`
                    if [ -n "$PROJECTDIR" ]; then
                      __remove_from_Someday
                    else
                      __printerr "==> Error: Bad argument $PROJECT."
                      __print
                      return 1
                    fi
                    #open -g "$SOMEDAY"
                    ;;

                random)
                    shift
                    if [ $# -eq 0 ]; then
                      PROJECT=`things someday list | __random | sed "s,$(printf '\033')\\[[0-9;]*[a-zA-Z],,g"`
                      PROJECT=`echo $PROJECT | tr -d '\n'`
                      tag -a random "$PROJECTS/$PROJECT"
                      __insert_in_Today "$PROJECT"
                      __remove_from_Someday "$PROJECT"
                      tree -L 1 -Cd -l "$TODAY"
                      $TODOTXT list
                      # open -g "$TODAY"
                    elif [ $# -eq 1 ]; then
                      case $1 in
                        scheduled)
                          pushd .
                          cd "$SOMEDAY/.random"
                          tag -l *
                          popd
                          ;;

                        start)
                        pushd .
                          cd "$SOMEDAY/.random"
                          if [[ $(date +%u) -eq 1 ]] ; then
                            # monday
                            tag -m mon | __tdsdrl
                          elif [[ $(date +%u) -eq 2 ]] ; then
                            # tuesday
                            tag -m tue | __tdsdrl
                          elif [[ $(date +%u) -eq 3 ]] ; then
                            # wednesday
                            tag -m wed | __tdsdrl
                          elif [[ $(date +%u) -eq 4 ]] ; then
                            #thursday
                            tag -m thu | __tdsdrl
                          elif [[ $(date +%u) -eq 5 ]] ; then
                            #friday
                            tag -m fri | __tdsdrl
                          elif [[ $(date +%u) -eq 6 ]] ; then
                            # saturday
                            tag -m sat | __tdsdrl
                          else
                            # sunday
                            tag -m sun | __tdsdrl
                          fi
                          popd
                          ;;

                        stop)
                          find "$SOMEDAY/.random" -type d -empty -delete -mindepth 1
                          tree -L 1 -Cd -l "$SOMEDAY/.random"
                          ;;

                        *)
                          __printerr "==> Error: Bad argument $1."
                          __print
                          return 1
                          ;;
                      esac
                    elif [ $# -eq 2 ]; then
                      pushd .
                      cd "$SOMEDAY/.random"
                      case $1 in
                        mon|tue|wed|thu|fri|sat|sun)
                          if [ -n "$2" ]; then
                            mkdir $2
                          fi
                          tag -a $1 $2
                          tag -l $2
                          popd
                          ;;

                        list)
                            if [ $2 = "none" ] || [ -z $2 ]; then
                              PROJECT=`things someday list | __random | sed "s,$(printf '\033')\\[[0-9;]*[a-zA-Z],,g"`
                            else
                              PROJECT=`things someday list $2 | __random | sed "s,$(printf '\033')\\[[0-9;]*[a-zA-Z],,g"`
                            fi
                            echo $PROJECT
                            PROJECT=`echo $PROJECT | tr -d '\n'`
                            tag -a random "$PROJECTS/$PROJECT"
                            __insert_in_Today "$PROJECT"
                            __remove_from_Someday "$PROJECT"
                            tree -L 1 -Cd -l "$TODAY"
                            $TODOTXT list
                            # open -g "$TODAY"
                            popd
                            ;;
                        *)
                          __printerr "==> Error: Bad argument $1."
                          __print
                          popd
                          return 1
                          ;;
                      esac
                    else
                      __printerr "==> Error: Bad number of arguments."
                      __print
                      return 1
                    fi
                    ;;

                *)
                    cd "$SOMEDAY"
                    pwd
                    #open -g .
            esac
            ;;


        somedaylog)
            shift
            case $1 in
                list)
                    tree -L 1 -Cd -l "$SOMEDAYLOG"
                    pwd
                    #open -g "$SOMEDAYDAY"
                    ;;

                start)
                    shift
                    if [ $# -eq 0 ]; then
                        PROJECT=`basename "$PWD"`
                    elif [ $# -eq 1 ]; then
                        PROJECT=$1
                    else
                        __printerr "==> Error: Bad number of arguments."
                        __print
                        return 1
                    fi
                    PROJECTDIR=`find "$PROJECTS" -maxdepth 1 -name $PROJECT`
                    if [ -n "$PROJECTDIR" ]; then
                        if [ ! -e "$SOMEDAYLOG/$PROJECT" ]; then
                            ln -sf "$PROJECTS/$PROJECT" "$SOMEDAYLOG/$PROJECT";
                            tag -a somedaylog "$PROJECTS/$PROJECT"
                            PROJTAGS=(`tag -lN "$PROJECTS/$PROJECT" | sed 's/,/ /g'`)
                            for i in "${PROJTAGS[@]}"; do
                              if [ $(__contains "$i" "random") == "y" ]; then
                                things somedaylog start
                              fi
                            done
                        fi
                        __remove_from_Someday
                        __remove_from_Scheduled
                        __remove_from_LogBook
                        __remove_from_Today
                    else
                        __printerr "==> Error: Bad argument $PROJECT."
                        __print
                        return 1
                    fi
                    #open -g "$SOMEDAYLOG"
                    ;;

                stop)
                    shift
                    if [ $# -eq 0 ]; then
                        PROJECT=`basename "$PWD"`
                    elif [ $# -eq 1 ]; then
                        PROJECT=$1
                    else
                        __printerr "==> Error: Bad number of arguments."
                        __print
                        return 1
                    fi

                    PROJECTDIR=`find "$PROJECTS" -name $PROJECT`
                    if [ -n "$PROJECTDIR" ]; then
                      __remove_from_SomedayLog
                    else
                      __printerr "==> Error: Bad argument $PROJECT."
                      __print
                      return 1
                    fi
                    #open -g "$SOMEDAYLOG"
                    ;;
                *)
                    cd "$SOMEDAYLOG"
                    pwd
                    #open -g .
            esac
            ;;

        git)
            shift
            case $1 in
                start)
                    git init  && \
                    hub create && \
                    git add . && \
                    git commit -am "performed-first-commit" && \
                    git push -u origin master #&& \
                    # hub browse .
                    ;;

                stop)
                    shift
                    git add . && \
                    git commit -am "$*" && \
                    git push -u origin master && \
                    hub browse .
                    ;;

                  log)
                    git log --oneline
                    ;;
                  graph)
                    git log --graph --oneline --decorate --all
                    ;;

                *)  git status -s
                    ;;
            esac
            ;;

        cloud)
            shift
            case $1 in
                start)
                    if __is_Things "$CLOUD"; then
                        __print "=> THINGS already to CLOUD."
                        __print
                    else
                        __print "=> Configuring THINGS to CLOUD..."
                        __print
                        unlink $TODAY_LINK
                        unlink $PROJECTS_LINK
                        ln -sf "$CLOUD/Today" $TODAY_LINK
                        ln -sf "$CLOUD/Projects" $PROJECTS_LINK
                        unlink $THINGS
                        ln -sf "$CLOUD" $THINGS
                        __print "-- THINGS  :"
                        ls -l $THINGS
                        __print
                    fi
                    ;;
                stop)
                    if __is_Things $LOCAL; then
                        __print "=> THINGS already to LOCAL."
                        __print
                    else
                        __print "=> Configuring THINGS to LOCAL..."
                        __print
                        unlink $TODAY_LINK
                        unlink $PROJECTS_LINK
                        ln -sf "$LOCAL/Today" $TODAY_LINK
                        ln -sf "$LOCAL/Projects" $PROJECTS_LINK
                        unlink $THINGS
                        ln -sf "$LOCAL" $THINGS
                        __print "-- THINGS  :"
                        ls -l $THINGS
                        __print
                    fi
                    ;;
                copy)
                    PROJECT=`basename $PWD`
                    PROJECTDIR=`find $PROJECTS -maxdepth 1 -name $PROJECT`
                    if [ -n "$PROJECTDIR" ]; then
                        if [ ! -e "$CLOUD/Projects/$PROJECT" ]; then
                            rsync -avErL $PWD "$CLOUD/Projects"
                        fi
                    fi
                    #open -g "$CLOUD/Projects/"
                    ;;
                *)
                    __print "=> Listing TODAY configuration..."
                    __print
                    __print "-- THINGS  :"
                    if [ ! -L $THINGS ]; then
                      __print "THINGS do not exist."
                      __print
                    else
                      ls -l $THINGS
                      __print
                    fi
                    ;;
            esac
            ;;

        *)
            if [ ! -L "$THINGS" ]; then
                ln -sf "$LOCAL" $THINGS
                ln -sf "$LOCAL/Today" $TODAY_LINK
                ln -sf "$LOCAL/Projects" $PROJECTS_LINK
            fi
            cd "$THINGS"
            #open -g .
            ;;
    esac
}
