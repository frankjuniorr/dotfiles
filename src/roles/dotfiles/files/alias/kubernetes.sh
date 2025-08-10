#################################################################
# Kubernetes Functions
#################################################################

# ----------------------------------------------------------------------
k8s-reset-all-pods() {
  k delete pods --all --all-namespaces
}

# ----------------------------------------------------------------------
k8s-list-all-resources() {
  k get all --all-namespaces
}

# ----------------------------------------------------------------------
# Exploration functions
k8s-get-deployment() {
  local deploy_name=$1

  test -z $deploy_name && echo "Type deployment name by parameter" && return 1

  echo "Searching: $deploy_name"
  echo
  echo "------------------------------------"
  echo "Deployments"
  echo "------------------------------------"
  k get deploy -l app=${deploy_name}

  echo
  echo "------------------------------------"
  echo "ReplicaSets"
  echo "------------------------------------"
  k get rs -l app=${deploy_name}

  echo
  echo "------------------------------------"
  echo "Pods"
  echo "------------------------------------"
  k get po -l app=${deploy_name}

  echo
  echo "------------------------------------"
  echo "Rollout history"
  echo "------------------------------------"
  k rollout history deployment/${deploy_name}
}
