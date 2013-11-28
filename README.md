# Logstash Ubuntu Package Build

This repo does not contain an actual package (committing binary files to git is
really a bad idea!).

It contains required files and scripts to build a proper Ubuntu package for
logstash as well as separate upstart scripts for both shipper and indexer
services and a sample config file.


## Requirements

* Ubuntu 12.04 or newer (may work with other versions)
* root (to install pbuilder and dev tools)
* common sense


## Howto

You can use a Jenkins or any Ubuntu vagrant instance if you don't want to
install dev tools on your main OS.

```
git clone https://github.com/TagManCode/logstash-deb
cd logstash-deb
./build.sh 1.2.1
```

`build.sh` script takes one argument - logstash upstream version, it uses that
to fetch the right logstash jar file, so make sure that the version you want to
build actually exists.

This will produce a properly built deb package with all the necessary bits included.

Happy logstashing!

## Authors
* Vaidas Jablonskis [@vaijab](https://twitter.com/vaijab)
