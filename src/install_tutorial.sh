#!/usr/bin/env bash
  
PARENT_PATH=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
echo num pars = $#
if [ $# -eq 0 ]
then
  echo "undefined release number"
else
  if [ $# = 1 ]
  then
    target="cbl.zip"
    release="https://packages.couchbase.com/releases/couchbase-lite-ios/"$1"/couchbase-lite-swift_xc_enterprise_"$1".zip"
    echo Retrieving $release
    echo Creating $target

    pushd $PARENT_PATH

    rm -rf Frameworks
    mkdir -p Frameworks
    cd Frameworks

    rm -rf iOS
    rm -rf macOS
    rm -rf tvOS
    curl $release > $target
    unzip -n $target
    rm -rf $target
    rm -rf cbl

    popd
  else
    echo "too many parameters provided -- just need release number of package to download"
  fi
fi    
