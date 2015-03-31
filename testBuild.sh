#!/usr/bin/env bash

cd /vagrant/bigbluebutton-client
ant locales

ant

sudo bbb-conf --clean