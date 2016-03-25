#!/bin/bash

export FUEL_RELEASE=80
export VENV_PATH="${HOME}/${FUEL_RELEASE}-venv"


case "${FUEL_RELEASE}" in
  *80* ) export REQS_BRANCH="stable/8.0" ;;
  *70* ) export REQS_BRANCH="stable/7.0" ;;
  *61* ) export REQS_BRANCH="stable/6.1" ;;
   *   ) export REQS_BRANCH="master"
esac

REQS_PATH="https://raw.githubusercontent.com/openstack/fuel-qa/${REQS_BRANCH}/fuelweb_test/requirements.txt"

function get_venv_requirements {
    rm -f requirements.txt*
    wget $REQS_PATH
    export REQS_PATH="$(pwd)/requirements.txt"

    if [[ "${REQS_BRANCH}" == "stable/8.0" ]]; then
      # bug: https://bugs.launchpad.net/fuel/+bug/1528193
      sed -i 's/python-neutronclient.*/python-neutronclient==3.1.0/' $REQS_PATH
    fi
    ## change version for some package
    #if [[ "${REQS_BRANCH}" != "master" ]]; then
    #  # bug: https://bugs.launchpad.net/fuel/+bug/1528193
    #  sed -i 's/python-novaclient>=2.15.0/python-novaclient==2.35.0/' $REQS_PATH
    #fi
}

## Recreate all an virtual env
function recreate_venv {
   [ -d $VENV_PATH ] && rm -rf ${VENV_PATH} || echo "The directory ${VENV_PATH} doesn't exist"
   virtualenv --clear "${VENV_PATH}"
}
   
function prepare_venv {
    source "${VENV_PATH}/bin/activate"
    pip --version
    [ $? -ne 0 ] && easy_install -U pip
    if [[ "${DEBUG}" == "true" ]]; then
        pip install -r "${REQS_PATH}" --upgrade > /dev/null 2>/dev/null
    else
        pip install -r "${REQS_PATH}" --upgrade > /dev/null 2>/dev/null
    fi

    django-admin.py syncdb --settings=devops.settings --noinput
    django-admin.py migrate devops --settings=devops.settings --noinput
    deactivate
}

recreate_venv

get_venv_requirements

[ -d $VENV_PATH ] && prepare_venv || (echo "$VENV_PATH doesn't exist $VENV_PATH will be recreated"; recreate_venv )
source "$VENV_PATH/bin/activate"
