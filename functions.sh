
# from bash hacker's wiki, of course.
asksure() {
    echo -n "$1 (y/n)"
    while read -r -n 1 -s answer; do
      if [[ $answer = [YyNn] ]]; then
        [[ $answer = [Yy] ]] && retval=0
        [[ $answer = [Nn] ]] && retval=1
        break
      fi
    done

    echo # just a final linefeed, optics...

    return $retval
}

cleanup() {
    if [ -e $1 ]
    then
        rm -rf $1 
    fi
}
