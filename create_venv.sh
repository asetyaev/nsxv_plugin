#!/bin/bash

export FUEL_RELEASE=90
export VENV_PATH="${HOME}/${FUEL_RELEASE}-venv"


case "${FUEL_RELEASE}" in
  *80* ) export REQS_BRANCH="stable/8.0" ;;
  *70* ) export REQS_BRANCH="stable/7.0" ;;
  *61* ) export REQS_BRANCH="stable/6.1" ;;
  *90* ) export REQS_BRANCH="stable/mitaka"
esac

REQS_PATH="https://raw.githubusercontent.com/openstack/fuel-qa/${REQS_BRANCH}/fuelweb_test/requirements.txt"
REQS_PATH_DEVOPS="https://raw.githubusercontent.com/openstack/fuel-qa/${REQS_BRANCH}/fuelweb_test/requirements-devops-source.txt"

function get_venv_requirements {
  rm -f requirements.*
  wget -O requirements.txt $REQS_PATH
  export REQS_PATH="$(pwd)/requirements.txt"
  wget -O requirements-devops-source.txt $REQS_PATH_DEVOPS
  export REQS_PATH_DEVOPS="$(pwd)/requirements-devops-source.txt"

  if [[ "${REQS_BRANCH}" == "stable/8.0" ]]; then
    # bug: https://bugs.launchpad.net/fuel/+bug/1528193
    sed -i 's/@2.*/@2.9.20/g' $REQS_PATH_DEVOPS
    #echo oslo.i18n >> $REQS_PATH
    echo stable/8.0
  fi
}

## Recreate all an virtual env
function recreate_venv {
   [ -d $VENV_PATH ] && rm -rf ${VENV_PATH} || echo "The directory ${VENV_PATH} doesn't exist"
   virtualenv --clear "${VENV_PATH}"
}
   
function prepare_venv {
    source "${VENV_PATH}/bin/activate"
    easy_install -U pip
    if [[ "${DEBUG}" == "true" ]]; then
        pip install -r "${REQS_PATH}" --upgrade
        pip install -r "${REQS_PATH_DEVOPS}" --upgrade
    else
        pip install -r "${REQS_PATH}" --upgrade > /dev/null 2>/dev/null
        pip install -r "${REQS_PATH_DEVOPS}" --upgrade > /dev/null 2>/dev/null
    fi

    django-admin.py syncdb --settings=devops.settings --noinput
    django-admin.py migrate devops --settings=devops.settings --noinput
    deactivate
}

recreate_venv

get_venv_requirements

[ -d $VENV_PATH ] && prepare_venv || (echo "$VENV_PATH doesn't exist $VENV_PATH will be recreated"; recreate_venv )
source "$VENV_PATH/bin/activate"
