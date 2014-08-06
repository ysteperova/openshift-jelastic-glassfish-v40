#!/bin/bash

# Simple deploy and undeploy scenarios for Jetty9

WGET=$(which wget);
AS_ADMIN="/opt/repo/versions/4.0/bin/asadmin";


function _deploy(){
     [ "x${context}" == "xROOT" ] && context="root";
     [ -f "${WEBROOT}/${context}.war" ] &&  rm -f "${WEBROOT}/${context}.war";
     $WGET --no-check-certificate --content-disposition -O "/tmp/${context}.war" "$package_url";
     $AS_ADMIN  deploy --force  --contextroot "$context" "/tmp/${context}.war";
     local result=$?;
     [ -f "/tmp/${context}.war" ] && rm "/tmp/${context}.war";
     return $result;
}

function _undeploy(){
     [ "x${context}" == "xROOT" ] && context="root";
     #[ -f "${WEBROOT}/${context}.war" ] && rm -f "${WEBROOT}/${context}.war";
     $AS_ADMIN  undeploy --force  --contextroot "$context"
}

