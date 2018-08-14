#!/bin/bash

result=`aws ec2 describe-instances`

while read line
do
  if [[ $line =~ ^\"InstanceId\"\: ]]; then
    InstanceId=${line#\"InstanceId\"\: }
    InstanceId=${InstanceId#\"}
    InstanceId=${InstanceId%,}
    InstanceId=${InstanceId%\"}
    echo $InstanceId
  fi
done << FILE
$result
FILE

exit 0
