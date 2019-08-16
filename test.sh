#!/bin/bash

api=api.cluster-b4ce.b4ce.events.opentlc.com:6443
pwd=r3dh4t1!
guid=4
guid_server=8b9c
sandbox_uid=354
ssh_machine=bastion.$guid_server.sandbox$sandbox_uid.opentlc.com
ssh_machine=bastion.$guid.events.opentlc.com

# SSH to your lab environment by specifying your lab environment $GUID in the following commands:
# export GUID=<<your-GUID-from-the-web-page>>
# ssh lab-user@workstation-$GUID.rhpds.opentlc.com
# ssh lab-user@bastion.<GUID>.sandbox<SANDBOX_NUMBER>.opentlc.com
# When prompted, enter password: r3dh4t1!
# ssh lab_user@$ssh_machine

# oc adm policy add-scc-to-user privileged system:serviceaccount:user1:build-bot

for i in {1..1}
do
   user=user$i
   oc login $api -u admin -p $pwd
   # oc new-project $user
   # oc apply -f deploy/tekton -n $user
   # oc get pods -n $user -w
done
