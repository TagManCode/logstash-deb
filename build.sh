#!/bin/bash

if [[ $# -eq 0 ]]; then
  echo "Please specify version number. E.g.: 1.2.1"
  exit 1
fi

PKG_NAME="logstash"
BUILD_TIMESTAMP="$(date '+%a, %d %b %Y %R:%S %z')"
UPSTREAM_VERSION=${1}
JAR_URL="https://download.elasticsearch.org/logstash/logstash/logstash-${UPSTREAM_VERSION}-flatjar.jar"


# install build dependencies
sudo apt-get install -y git pbuilder debootstrap devscripts apt-file \
  git debhelper ubuntu-dev-tools debhelper aptitude

# Prepare pbuilder environment
if [ ! -e ${HOME}/pbuilder/precise-base.tgz ]; then
  pbuilder-dist precise amd64 create
fi

# generate a debian/changelog
mv debian/changelog.template debian/changelog

sed -e "s/%VERSION%/$UPSTREAM_VERSION/g" \
    -e "s/%PKG_NAME%/$PKG_NAME/g" \
    -e "s/%TIMESTAMP%/$BUILD_TIMESTAMP/g" \
    -i debian/changelog

# Clean up previous packaging files
rm -f ../${PKG_NAME}_*

PKG_VERSION="$(dpkg-parsechangelog -ldebian/changelog | awk '/^Version: / {print $2}' | cut -d'-' -f1)"
PKG_RELEASE="$(dpkg-parsechangelog -ldebian/changelog | awk '/^Version: / {print $2}' | cut -d'-' -f2)"

# create an orig tarball
tar -czf ../${PKG_NAME}_${PKG_VERSION}.orig.tar.gz \
    --exclude="debian" \
    --exclude=".git" .

# build the source package
debuild -S -us -uc

# build the binary package
cd .. && pbuilder-dist precise build ${PKG_NAME}_${PKG_VERSION}-${PKG_RELEASE}.dsc --buildresult .
