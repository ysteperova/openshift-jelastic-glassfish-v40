#!/bin/bash

# Simple deploy and undeploy scenarios for GlassFish4

WGET=$(which wget);
AS_ADMIN="/opt/repo/versions/4.0/bin/asadmin";
include output;

function _deploy(){
     [ "x${context}" == "xROOT" ] && deploy_context="/" || deploy_context=$context;
     [ -f "${WEBROOT}/${context}.war" ] &&  rm -f "${WEBROOT}/${context}.war";
     $WGET --no-check-certificate --content-disposition -O "/tmp/${context}.war" "$package_url";
     $AS_ADMIN  deploy --force  --contextroot "$deploy_context" "/tmp/${context}.war" >> $ACTIONS_LOG 2>&1;
     local result=$?;
     [ -f "/tmp/${context}.war" ] && rm "/tmp/${context}.war";
     return $result;
}

function _undeploy(){
     [ "x${context}" == "xROOT" ] && context="root";
     $AS_ADMIN  undeploy   "$context"  >> $ACTIONS_LOG 2>&1;
}
