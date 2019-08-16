#!/bin/sh

#
#  ./it.sh agnosticd/ansible/roles

ANSIBLE_DIR=$1
ACTION=${2:-create}
OCP_WORKLOAD="ocp-workload-dekorate-component-operator"

# Prod environment
# RHPDS
# OCP_USERNAME="cmoulliard-redhat.com"
# HOST_GUID="namur-dfb4"
# GUID=$HOST_GUID
# TARGET_HOST="bastion.$HOST_GUID.openshiftworkshop.com"
prod () {
  echo "=== PROD env ===="
  OCP_USERNAME="cmoulliard-redhat.com"
  HOST_GUID="namur-dfb4"
  GUID=$HOST_GUID
  TARGET_HOST="bastion.$HOST_GUID.openshiftworkshop.com"
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

SSH_USER=$OCP_USERNAME
SSH_PRIVATE_KEY="id_rsa"

echo "Environment to call"
prod

ansible-playbook -i $TARGET_HOST, ./scripts/ocp-workload.yml \
    -e "ansible_roles_path=$ANSIBLE_DIR" \
    -e "ansible_ssh_private_key_file=~/.ssh/${SSH_PRIVATE_KEY}" \
    -e "ansible_user=${SSH_USER}" \
    -e "ocp_username=${OCP_USERNAME}" \
    -e "ocp_workload=${OCP_WORKLOAD}" \
    -e "silent=False" \
    -e "guid=${GUID}" \
    -e "ACTION=$ACTION" \
    -e become \
    -v