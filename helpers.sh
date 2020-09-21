alias ..="cd .."
alias cit225="cd ~/cit225"
alias update-bash="vim ~/.bashrc && source ~/.bashrc"
alias cleanup="rm -rfv !(apply_oracle_*)"
alias sql="sqlplus student/student"
function sqlr {
  lab=${PWD##*/}
  echo "running sql for $lab"
  exit | sql @apply_oracle_$lab.sql
  rm -rfv !(apply_oracle_$lab*)
}

