##  Cynin 3.2.2 Docker image

This is EEA's base image for Cynin instance.

## Base docker image

- [hub.docker.com](https://registry.hub.docker.com/r/eeacms/cynin)

## Source code

  - [github.com](http://github.com/eea/eea.docker.cynin)

### Projects

- [EEA Community](https://github.com/eea/eea.docker.community)

### Tags (version of Cynin Instance)

- latest

### Environment variables

You can customize your deployment by modifying this variable:

 - `SERVICES=zope` will start only www1 Zope instance inside container
 - `SERVICES=zeo` will start only Zeo server inside container

### How to use this image

    $ docker run -e SERVICES=zeo --name=zeo eeacms/cynin
    $ docker run -e SERVICES=zope --link=zeo --name=zope -p 8080:8080 eeacms/cynin
