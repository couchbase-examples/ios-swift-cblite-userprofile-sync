#!/usr/bin/env bash

cd Frameworks
rm -rf iOS
rm -rf macOS
rm -rf tvOS
curl http://packages.couchbase.com/releases/couchbase-lite-ios/2.8.4/couchbase-lite-swift_enterprise_2.8.4.zip > cbl.zip
unzip -n cbl.zip
rm -rf cbl.zip
rm -rf cbl

