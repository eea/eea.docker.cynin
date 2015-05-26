##  Cynin 3.2.2 Docker image

This is EEA's base image for Cynin instance.

### Repository
- [hub.docker.com](https://registry.hub.docker.com/u/eeacms/cynin/)

### Projects
- [EEA Community](https://github.com/eea/eea.docker.community)

### Tags (version of Cynin Instance)
- latest

### Environment variables
You can create new images by modifying these variables:
 - CYNIN_PATH
 - CYNIN_BUILDOUT
 - CYNIN_NAME
 - INSTANCEDIR

### How to use this image
  
  **Create a Cynin instance**
  
    FROM eeacms/cynin
    
    RUN bin/instance fg
