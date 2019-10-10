tekton_project=tekton-pipelines
operators_project=operators

scaleOperators() {

  oc scale --replicas=1 deployment halkyon-operator -n $operators_project --as=system:admin

  oc scale --replicas=1 deployment tekton-pipelines-webhook -n $tekton_project --as=system:admin
  oc scale --replicas=1 deployment tekton-pipelines-controller -n $tekton_project --as=system:admin

}

scaleOperators

