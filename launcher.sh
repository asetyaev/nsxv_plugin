#!/bin/bash

ENV_NAME='asetyaev-env-80'
VIRTUAL_ENV='/home/asetyaev/80-venv'
export JOB_NAME='system_test'
export WORKSTATION_USERNAME='vmware'
export WORKSTATION_PASSWORD='VMware01'

export VCENTER_PASSWORD='Qwer!1234'
export WORKSTATION_SNAPSHOT='nsxv_6.2'
export NSXV_PLUGIN_PATH=`ls ~/plugin/nsxv-2*`
export NSXV_PASSWORD='r00tme'
export WORKSPACE=$(pwd)


ISO_PATH='/storage/downloads/fuel-8.0-570-2016-02-15_13-42-00.iso'
SYS_TEST="plugin_test/utils/jenkins/system_tests.sh"

USE_EXISTING="YES"

if [ -n  "$USE_EXISTING" ]; then
    KEEPENV_BEFORE_OPT="-k";
else
    dos.py list | grep -q $ENV_NAME && { echo erasing old $ENV_NAME; dos.py erase $ENV_NAME ; }
fi
if [ -z  "$DESTROY_ENV_AFTER" ]; then KEEPENV_AFTER_OPT="-K"; fi


#./$SYS_TEST -t test $KEEPENV_BEFORE_OPT $KEEPENV_AFTER_OPT -e $ENV_NAME -w $WORKSPACE  -V $VIRTUAL_ENV -j $JOB_NAME -i "${ISO_PATH}" -o --group=nsxv_smoke
#./$SYS_TEST -t test $KEEPENV_BEFORE_OPT $KEEPENV_AFTER_OPT -e $ENV_NAME -w $WORKSPACE  -V $VIRTUAL_ENV -j $JOB_NAME -i "${ISO_PATH}" -o --group=nsxv_create_and_delete_vms
./$SYS_TEST -t test $KEEPENV_BEFORE_OPT $KEEPENV_AFTER_OPT -e $ENV_NAME -w $WORKSPACE  -V $VIRTUAL_ENV -j $JOB_NAME -i "${ISO_PATH}" -o --group=nsxv_add_delete_controller
#./$SYS_TEST -t test $KEEPENV_BEFORE_OPT $KEEPENV_AFTER_OPT -e $ENV_NAME -w $WORKSPACE  -V $VIRTUAL_ENV -j $JOB_NAME -i "${ISO_PATH}" -o --group=nsxv_connectivity_via_exclusive_router
