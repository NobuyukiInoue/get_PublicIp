#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Usage : $0 <target InstanceId>"
  exit 1
fi

InstanceId=$1
echo "Target InstanceId: $InstanceId"

result=`aws ec2 describe-instances`

check_PublicIp=false

while read line
do
  if [[ $line =~ ^\"PublicIpAddress\"\: ]]; then
    if $check_PublicIp ; then
      $check_PulicIp=false
      break
    fi

    PublicIp=${line#\"PublicIpAddress\"\: }
    PublicIp=${PublicIp#\"}
    PublicIp=${PublicIp%,}
    PublicIp=${PublicIp%\"}
    check_PublicIp=true
  fi

  if $check_PublicIp ; then
    if [[ $line =~ ^\"InstanceId\"\: ]]; then
      if [[ $line =~ \"$InstanceId\" ]]; then
        echo $PublicIp
        exit 0
      else
        check_PublicIp=false
      fi
    fi
  fi
done << FILE
$result
FILE

echo "Public IP Address Not Found."
exit 1
