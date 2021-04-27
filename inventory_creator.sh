#!/usr/bin/env bash
# <Miguel H.> miguel51atlas@gmail.com
# Script to generate Rundeck inventory.

## Arguments and it's definition.
# $1 = File with your node definition.
# $2 = Define your ENV. Prod, QA. 

file="$1"
env="$2"

prepare_temp_files_multiL () {
 if [ ! -f "$file" ]; then 
    echo "Your file is not present on specified path, check & run this script again."
    exit 1
  elif [ $(cat $file | wc -l ) -gt 1 ] || [ $(cat $file | wc -w ) -eq 1 ]; then
    echo "Let me prepare everything for next steps."
    echo "Step 1: Split everything in short name. Example node01.mycompany.com to node01."
    awk -F '.' '{ print $1 }' $file | tr '\n' ' ' > NODES0.txt
    echo "Step 1 completed!"
    echo "Step 2: Converting multi-lined to single line."
    echo $(cat $1) > NODES1.txt
    echo "Step 2 done!"
  elif [ $(cat $file | wc -w ) -gt 1 ]; then
    echo "Your file is non multi-line. Lets process this with another function."
    no-multi-line
  else
    echo "Your file is empty!"
    exit 1
fi
}

create_inventory () {
  # Declare an array.
  declare -a StringArray=$(cat NODES1.txt )
  declare -a StringArray2=$(cat NODES0.txt) 

  # Iterate over that array.
  for val1 in ${StringArray[@]}; do
    echo "<node name="\""\" tags="\"$env"\" hostname="\"$val1"\" osFamily="\"unix"\" username="\"svc_some"\" sudo-command-enabled="\"true"\" ssh-autentication="\"privateKey"\" ssh-key-storage-path="\"keys/svc_some"\" />"
  done > Pre-step1.txt

  for val2 in ${StringArray2[@]}; do
    echo "<node name="\"$val2.$env"\" tags="\"$env"\" hostname="\""\" osFamily="\"unix"\" username="\"svc_some"\" sudo-command-enabled="\"true"\" ssh-autentication="\"privateKey"\" ssh-key-storage-path="\"keys/svc_some"\" />"
  done > Pre-step2.txt

  # Parse files.
  awk '{$1=$2="";print $0}' Pre-step1.txt > Pre-Step3.txt
  awk '{print $1 " " $2}' Pre-step2.txt > Pre-Step4.txt

  # Generate final XML.
  paste Pre-Step4.txt Pre-Step3.txt | awk '$1=$1' | uniq > resources.xml

  # Deleting files.
  rm -f Pre-* NODES* 1 
}

no-multi-line () {
  echo "Making the inverse process."
  cat $file | xargs -n1 > temporal
  cat temporal > $file && rm -f temporal
  echo "Calling back the first function again."
  prepare_temp_files_multiL $file $env
}

last_details () {
  ## Start string
  echo -e "<project>\n$(cat resources.xml)" > resources.xml
  ## Close string.
  echo "</project>" >> resources.xml 

  echo
  echo
  echo "****************************************"
  echo " Your resources.xml is ready!"
  echo "****************************************"
}

prepare_temp_files_multiL $file $env
create_inventory
last_details
