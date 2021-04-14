# This is project run Sonaqube on Openshift

## Sonarqube version = 7.9.6

## Build Container
```bash
 $ docker build --rm --no-cache --buid-arg SONAR_VERSION:7.9.6 <YOUR_REGISTRY>/sonarqube:7.9.6
```

## Createa and select project
```bash
$ oc new-project sonarqube --description="CI/CD Tools" --display-name="Sonarqube"

$ oc project sonarqube
```

## Deployment on Openshift
```bash
$ oc new-app -f manifest/sonarqube-postgresql.yml --param=SONARQUBE_VERSION=7.9.6
```