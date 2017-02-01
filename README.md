# docker-atlassian-jira-software

This is a Docker-Image for Atlassian JIRA Software based on [Alpine Linux](http://alpinelinux.org/), which is kept as small as possible.

## Features

* Small image size
* Setting application context path
* Setting JVM xms and xmx values
* Setting proxy parameters in server.xml to run it behind a reverse proxy (TOMCAT_PROXY_* ENV)

## Variables

* TOMCAT_CONTEXT_PATH: default context path for jira is "/"

Using with HTTP reverse proxy, not necessary with AJP:

* TOMCAT_PROXY_NAME: domain of jira instance
* TOMCAT_PROXY_PORT: e.g. 443
* TOMCAT_PROXY_SCHEME: e.g. "https"

JVM memory management:

* JVM_MEMORY_MIN
* JVM_MEMORY_MAX

Crowd:

* CROWD_SSO: if set to something, activate SSOSeraphAuthenticator as authenticator

Modifies following parameters in crowd.properties:

* CROWD_APP_NAME (modifies application.name)
* CROWD_APP_PASSWORD (modifies application.password)
* CROWD_APP_LOGIN_URL (modifies application.login.url)
* CROWD_SERVER_URL (modifies crowd.server.url)
* CROWD_BASE_URL (modifies crowd.base.url)
* CROWD_VALIDATIONINTERVAL (modifies session.validationinterval)

## Ports
* 8080

## Build container
Specify the application version in the build command:

```bash
docker build --build-arg VERSION=x.x.x .                                                        
```

## Getting started

Run JIRA Software standalone and navigate to `http://[dockerhost]:8080` to finish configuration:

```bash
docker run -tid -p 8080:8080 seibertmedia/atlassian-jira-core:latest
```

Run JIRA Software standalone with customised jvm settings and navigate to `http://[dockerhost]:8080` to finish configuration:

```bash
docker run -tid -p 8080:8080 -e JVM_MEMORY_MIN=2g -e JVM_MEMORY_MAX=4g seibertmedia/atlassian-jira-core:latest
```

Specify persistent volume for JIRA Software data directory:

```bash
docker run -tid -p 8080:8080 -v jira_data:/var/opt/atlassian/application-data/jira seibertmedia/atlassian-jira-core:latest
```

Run JIRA Software behind a reverse (SSL) proxy and navigate to `https://tasks.yourdomain.com`:

```bash
docker run -d -e TOMCAT_PROXY_NAME=tasks.yourdomain.com -e TOMCAT_PROXY_PORT=443 -e TOMCAT_PROXY_SCHEME=https seibertmedia/atlassian-jira-core:latest
```

Run JIRA Software behind a reverse (SSL) proxy with customised jvm settings and navigate to `https://tasks.yourdomain.com`:

```bash
docker run -d -e TOMCAT_PROXY_NAME=tasks.yourdomain.com -e TOMCAT_PROXY_PORT=443 -e TOMCAT_PROXY_SCHEME=https -e JVM_MEMORY_MIN=2g -e JVM_MEMORY_MAX=4g seibertmedia/atlassian-jira-core:latest
```
