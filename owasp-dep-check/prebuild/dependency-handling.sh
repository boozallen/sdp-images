#!/bin/bash

#move to dependency directory
#TARGET = directory to perform script in
TARGET="mono-complete"
cd /root/prebuild/dependencies/$TARGET

#create list of dependencies
ls | grep ".rpm" > manifest.txt
yum update -y

while read -r line; do
  #Grabbing name of package
  echo ${line%%-[0-9]*} > tmp.txt
  STR=$(cat tmp.txt)
  yum list $STR > list.txt
  echo $STR
#check if yum contains dependency
  if cat list.txt <<< "$STR"; then
    #check version of packages
    if [[ "$STR" == "python36" ]];then
      #python36 has a unique file name, requiring special configuration
      echo ${line%%.x86*} > tmp.txt
      PWR=$(cat tmp.txt)
      echo ${PWR#*+} > tmp.txt
      VRSN=$(cat tmp.txt)
      tail -n 1 list.txt | awk '{print $2}' > tmp2.txt
      PWR=$(cat tmp2.txt)
      echo ${PWR#*el8.1.0+} > tmp2.txt
      PWR=$(cat tmp2.txt)
    else
      echo ${line%%.el8*} > tmp.txt
      PWR=$(cat tmp.txt)
      echo ${PWR##$STR-} > tmp.txt
      VRSN=$(cat tmp.txt)
      tail -n 1 list.txt | awk '{print $2}' > tmp2.txt
      PWR=$(cat tmp2.txt)
      echo ${PWR%.el8*} > tmp2.txt
      PWR=$(cat tmp2.txt)
    fi
    if [[ "$PWR" == "$VRSN" ]]; then
      #Checked if what is available is the same as what is in the dependency bundle
      echo "Moving to next dependency"
    elif [[ "$PWR" < "$VRSN" ]]; then
      #Checked if dependency bundle is better
      echo "Manual inspection of dependency suggested"
    elif [[ "$PWR" == "metadata" ]]; then
      echo "File not found in YUM list: $line"
    else
      echo "Update Found for $STR"
      rm /root/prebuild/dependencies/$TARGET/$line
      dnf download $STR  -y --resolve --destdir /root/prebuild/dependencies/$TARGET/
      echo "$STR has been downloaded"
    fi
  fi
done < manifest.txt
#cleanup temporary files
rm tmp.txt
rm tmp2.txt
rm manifest.txt
rm list.txt
