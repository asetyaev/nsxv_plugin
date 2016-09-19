#!/bin/bash

ENV_NAME='asetyaev-env-80'
VIRTUAL_ENV='/home/asetyaev/90-venv'
export JOB_NAME='system_test'
export WORKSTATION_USERNAME='vmware'
export WORKSTATION_PASSWORD='VMware01'

export WORKSTATION_SNAPSHOT='nsx-t-1.0.1'
export NSXT_PLUGIN_PATH=`ls ~/plugin/nsx-t-1*`
export NSXT_PASSWORD='Qwer!1234'
export WORKSPACE=$(pwd)


ISO_PATH='/storage/downloads/fuel-9.0-mos-495-2016-06-16_18-18-00.iso'
#ISO_PATH='/storage/downloads/fuel-9.0-mos-567.iso'

SYS_TEST="plugin_test/utils/jenkins/system_tests.sh"

USE_EXISTING="YES"

if [ -n  "$USE_EXISTING" ]; then
    KEEPENV_BEFORE_OPT="-k";
else
    dos.py list | grep -q $ENV_NAME && { echo erasing old $ENV_NAME; dos.py erase $ENV_NAME ; }
fi
if [ -z  "$DESTROY_ENV_AFTER" ]; then KEEPENV_AFTER_OPT="-K"; fi


./$SYS_TEST -t test $KEEPENV_BEFORE_OPT $KEEPENV_AFTER_OPT -e $ENV_NAME -w $WORKSPACE  -V $VIRTUAL_ENV -j $JOB_NAME -i "${ISO_PATH}" -o --group=nsxt_smoke
