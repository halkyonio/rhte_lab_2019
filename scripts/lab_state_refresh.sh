tekton_project=tekton-pipelines
operators_project=operators


updateOperators() {
    oc patch deploy/halkyon-operator \
       --patch '{"spec":{"template":{"spec":{"containers":[{"name":"halkyon-operator", "image":"quay.io/halkyonio/operator:v0.1.8"}]}}}}' \
       -n $operators_project \
       --as=system:admin
}

scaleOperators() {

  oc scale --replicas=1 deployment halkyon-operator -n $operators_project --as=system:admin

  oc scale --replicas=1 deployment tekton-pipelines-webhook -n $tekton_project --as=system:admin
  oc scale --replicas=1 deployment tekton-pipelines-controller -n $tekton_project --as=system:admin

}

updateOperators
scaleOperators

