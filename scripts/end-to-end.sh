#!/usr/bin/env bash

# Prerequisite:
# Install httpie       - https://httpie.org/doc#installation
# Have hal : >= 0.1.10 - https://github.com/halkyonio/hal/releases/tag/v0.1.10
# How to use it
# - Be logged to ocp/k8s
# - Launch the following script
#
# ./scripts/new-end-to-end.sh OCP_PROJECT

PROJECT=${1:-test}

function printTitle() {
  r=$(
    typeset i=${#1} c="=" s=""
    while ((i)); do
      ((i = i - 1))
      s="$s$c"
    done
    echo "$s"
  )
  printf "\n%s\n%s\n" "$1" "$r"
}

tempDir=$(mktemp -d)
pushd $tempDir

printTitle "Create Temp project : $(pwd)"
oc new-project $PROJECT

printTitle "Create Pom parent file"
cat <<EOF > pom.xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>me.fruitstand</groupId>
    <artifactId>parent</artifactId>
    <version>1.0.0-SNAPSHOT</version>
    <name>Spring Boot - Demo</name>
    <description>Spring Boot - Demo</description>
    <packaging>pom</packaging>
    <modules>
        <module>fruit-backend-sb</module>
        <module>fruit-client-sb</module>
    </modules>
</project>
EOF

printTitle "Scaffold maven projects"

hal component spring-boot \
   -i fruit-backend-sb \
   -g me.fruitsand \
   -p me.fruitsand.demo \
   -s 2.1.6.RELEASE \
   -t crud \
   -v 1.0.0-SNAPSHOT \
   --supported=false  \
   fruit-backend-sb

 hal component spring-boot \
   -i fruit-client-sb \
   -g me.fruitsand \
   -p me.fruitsand.demo \
   -s 2.1.6.RELEASE \
   -t client \
   -v 1.0.0-SNAPSHOT \
   --supported=false  \
   fruit-client-sb

printTitle "Do Maven package"
mvn package -f fruit-client-sb
mvn package -f fruit-backend-sb -Pkubernetes

printTitle "Create components"
hal component create -c fruit-client-sb
hal component create -c fruit-backend-sb

printTitle "Create Capability"
hal capability create -n postgres-db -g database -t postgres -v 10 -p DB_NAME=sample-db -p DB_PASSWORD=admin -p DB_USER=admin
sleep 15s

printTitle "Link"
hal link create -n backend-to-db -t fruit-backend-sb -s postgres-db-config
hal link create -n client-to-backend -t fruit-client-sb -e KUBERNETES_ENDPOINT_FRUIT=http://fruit-backend-sb:8080/api/fruits

printTitle "Push"
sleep 45s
hal component push -c fruit-client-sb
hal component push -c fruit-backend-sb

printTitle "Wait and call respectively the Bakcend endpoint to create fruits and next the client endpoint to got them"
sleep 100s

BACKEND_URL=$(oc get routes/fruit-backend-sb --template={{.spec.host}})
http -s solarized POST "http://${BACKEND_URL}/api/fruits" name=Orange
http -s solarized POST "http://${BACKEND_URL}/api/fruits" name=Banana
http -s solarized POST "http://${BACKEND_URL}/api/fruits" name=Pineapple
http -s solarized POST "http://${BACKEND_URL}/api/fruits" name=Apple
http -s solarized POST "http://${BACKEND_URL}/api/fruits" name=Pear

FRONTEND_URL=$(oc get routes/fruit-client-sb --template={{.spec.host}})
http "http://${FRONTEND_URL}/api/client" -s solarized

printTitle "Delete resources"
oc delete all --all -n $PROJECT

popd
rm -rf $tempDir

