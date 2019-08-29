#!/bin/sh

#
#  ./it.sh agnosticd/ansible/roles ANSIBLE_DIR ACTION GUID ENV

ANSIBLE_DIR=$1
ACTION=${2:-create}
GUID=${3:-namur-7027}
ENV=${4:-prod}
OCP_WORKLOAD="ocp-workload-dekorate-component-operator"
SSH_PRIVATE_KEY="id_rsa"

# Prod environment
# RHPDS
# OCP_USERNAME="cmoulliard-redhat.com"
# HOST_GUID="namur-dfb4"
# GUID=$HOST_GUID
# TARGET_HOST="bastion.$HOST_GUID.openshiftworkshop.com"
prod () {
  echo "=== PROD env ===="
  OCP_USERNAME="cmoulliard-redhat.com"
  HOST_GUID=${GUID}
  GUID=$HOST_GUID
  TARGET_HOST="bastion.$HOST_GUID.open.redhat.com"
}

# Development environment
#
# ocp console : console-openshift-console.apps.shared-dev.dev.openshift.opentlc.com
# ocp api :     https://api.shared-dev.dev.openshift.opentlc.com:6443
# user: cmoulliard-redhat.com
dev () {
  echo "=== DEV env ===="
  # sudo user
  OCP_USERNAME="ec2-user"
  # OCP_USERNAME="opentlc-mgr"
  GUID="snowdroptest"
  TARGET_HOST=bastion.dev.openshift.opentlc.com
}

echo "Provision the environment to be used"
if [ "${ENV}" == "prod" ]; then
  prod
else
  dev
fi

# Define the user to be used to ssh
SSH_USER=$OCP_USERNAME

# ansible-playbook -i $TARGET_HOST, ./scripts/ocp-workload.yml \
#     -e "ansible_roles_path=$ANSIBLE_DIR" \
#     -e "ansible_ssh_private_key_file=~/.ssh/${SSH_PRIVATE_KEY}" \
#     -e "ansible_user=${OCP_USERNAME}" \
#     -e "ocp_username=${OCP_USERNAME}" \
#     -e "ocp_workload=${OCP_WORKLOAD}" \
#     -e "silent=False" \
#     -e "guid=${GUID}" \
#     -e "ACTION=$ACTION" \
#     -v

