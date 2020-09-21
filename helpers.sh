alias ..="cd .."
alias cit225="cd ~/cit225"
alias update-bash="vim /home/student/cit225/helpers.sh && source /home/student/cit225/helpers.sh"
alias cleanup="rm -rfv !(apply_oracle_*)"
alias sql="sqlplus student/student"
function sqlr {
  lab=${PWD##*/}

  if [ ! -f apply_oracle_$lab.sql ]; then
    echo -e "\n\e[31mHold up! No file for apply_oracle_$lab.sql\e[0m\n"
    return 1
  fi

  if [ ! `git rev-parse --is-inside-work-tree` ]; then
    echo -e "\n\e[31mYou're not in a repository;  I'm going to stop you from screwing this up again...\e[0m\n"
    return 1
  fi

  echo "running sql for $lab"
  exit | sql @apply_oracle_$lab.sql
  rm -rfv !(apply_oracle_$lab*)
}

