#!/bin/sh
target=$1
debug=$2


if [ "$#" -eq 0 ] 
  then
  echo "usage: ./httpoxy-scan.sh url [debug]"
  echo "any setting for debug other than blank will print out http return values of checks"
  echo "url must be fully qualified and valid with http or https"
  echo "This program attempts to check a site for the httpoxy MTM vunerability"
  echo "It is noisy, and will show in the server logs that you have crawled the site"
  echo "Copyright Darryl Lewis 2016"
  exit 1
fi

echo "phase 1: crawling site"
wget --no-check-certificate -e robots=off --spider -r -nd -nv -H -l 1 -o run1.log $target

echo "phase 2: extracting links"
cat run1.log |grep URL|sed 's/.*URL://g'|sed 's/^ //g'|sed 's/ .*//g'>run2.log


echo "phase 3: checking for httpoxy"
while read target
  do
echo $target
result=`curl -sL -w "%{http_code}" $target -o /dev/null`
if [ $debug ]
  then 
  echo $result
fi
if [ $result -eq 200 ]
  then
  poxyresult=`curl -sL --header "Proxy: vulnerable" -w "%{http_code}" $target -o /dev/null`
  if [ $debug ]
    then 
    echo $poxyresult
   fi
  if [ $poxyresult -ne 200 ]
    then
    echo "*********"
    echo "vunerable"
    echo "*********"
  fi
fi

done<run2.log
