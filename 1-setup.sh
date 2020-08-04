#!/bin/bash

echo 'Assumes you have Tekton & Knative Serving pre-installed'

oc new-project apipes

kubectl apply -f pvc-workspace.yaml

kubectl create -f https://raw.githubusercontent.com/tektoncd/catalog/master/task/git-clone/0.1/git-clone.yaml
kubectl create -f task-list-directory.yaml

kubectl apply -f https://raw.githubusercontent.com/redhat-developer-demos/tekton-tutorial/master/install/utils/nexus.yaml

kubectl create cm maven-settings \
  --from-file=settings.xml=maven-settings.xml

kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/master/task/maven/0.1/maven.yaml

kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/master/task/buildah/0.1/buildah.yaml

kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/master/task/kn/0.1/kn.yaml

curl -sSL \
  https://raw.githubusercontent.com/tektoncd/catalog/master/task/kn/0.1/kn-deployer.yaml \
  | yq w - -d0 metadata.namespace apipes \
  | yq w - -d2 subjects.[0].namespace apipes \
  | kubectl apply -f -

kubectl create -f pipeline-git-mvn-buildah-kn.yaml

echo 'Everything Setup'

tkn tasks list
tkn pipelines list
