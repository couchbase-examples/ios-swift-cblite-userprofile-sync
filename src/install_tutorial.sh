#!/usr/bin/env bash
  echo num pars = $#
  if [ $# -eq 0 ]
  then
    echo "undefined release number"
  else
    if [ $# = 1 ]
    then
      target="cbl.zip"
      release="https://packages.couchbase.com/releases/couchbase-lite-ios/"$1"/couchbase-lite-swift_enterprise_"$1".zip"
      echo Retrieving $release
      echo Creating $target
      cd Frameworks
      rm -rf iOS
      rm -rf macOS
      rm -rf tvOS
      curl $release > $target
      unzip -n $target
      rm -rf $target
      rm -rf cbl
    else
      echo "too many parameters provided -- just need release number of package to download"
    fi
  fi
