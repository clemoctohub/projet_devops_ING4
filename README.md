# Projet Devops ING4

##### *Authors : Clément Fages & Anne-Charlotte Vignon*

This repository contains a description of the features we have done for the project. Screenshots and explication are provide for each feature. We will also provide instructions to run the different applications (eg. k8s, docker or vagrant file).

[TOC]

* Clone this repository, from your local machine:
  ```bash
  git https://github.com/clemoctohub/projet_devops_ING4.git
  cd projet_devops_ING4
  ```

To run the different features, you will need the following resources :

- Nodejs & npm
- Git
- Docker
- Kubernetes with Minikube
- Istio
- Vagrant



## 1. Create a web application

The first step to do devops & SRE is to create a web application. The aim is to deploy this application on many different platforms.

This application is an API that provides some features to create or get some elements from a redis database. We created two main folders. The first one is for the app, it is the source code. In there, there are the different files to launch the server and the files for the route and API. In the second folder there are the files to run test to check if our API and routes are working correctly.

But, we don't stop at a simple create/read API. We added all the elements in the route and API files to have a complete CRUD application. We also added tests to test these functionalities. Everything is stored in the redis database.

You can do the following to run the app :

```bash
$ cd userapi
$ npm install
```

*This will install the necessary resources to run the application.*

Then you have to run redis to provide database (exclusively on Linux) :

```bash
$ sudo apt update
$ sudo pat install redis-server
```

Then you can choose which command to run :

```bash
# run the application
$ npm start
# run the tests
$ npm test
```

Then you can see this in your terminal if you run the app in the console :

![image-20211222101217677](C:\Users\clemf\AppData\Roaming\Typora\typora-user-images\image-20211222101217677.png)

On the web :

![image-20211222121454809](C:\Users\clemf\AppData\Roaming\Typora\typora-user-images\image-20211222121454809.png)

Or this if you test it :

```bash
PS C:\Users\clemf\Documents\GitHub\projet_devops_ING4\userapi> npm test

> ece-userapi@1.1.0 test C:\Users\clemf\Documents\GitHub\projet_devops_ING4\userapi        
> mocha test/*.js

Server listening the port 3000


  Configure
    ✔ load default json configuration file
    ✔ load custom configuration

  Redis
    ✔ should connect to Redis

  User
    Create
      ✔ create a new user
      ✔ passing wrong user parameters
      ✔ avoid creating an existing user
    Get
      ✔ get a user by username
      ✔ can not get a user when it does not exist
    Update
      ✔ update a user with username
      ✔ can not update a user when it does not exist
    Delete
      ✔ can not delete a user when it does not exist
      ✔ delete a user by username

  User REST API
    POST /user
      ✔ create a new user (70ms)
      ✔ pass wrong parameters
    GET /user
      ✔ get an existing user
      ✔ can not get a user when it does not exist
    DELETE /user
      ✔ delete an existing user
      ✔ cannot delete if pass wrong parameters
    PUT /user
      ✔ update an existing user
      ✔ cannot update if pass wrong parameters


  20 passing (188ms)
```

*Note: the answer was to big to provide a screenshot*

## 2. CI/CD pipeline

In this part we created a CI/CD pipeline with Github Actions and Heroku.

On pull or push actions on defined branches, some tests are run on Github in the tab Github Action. There we can see if our app is passing all kind of test.

If you want to see the execution of the test by yourself, you have to edit a file and make a push :

```bash
# install git
$ sudo apt-get install git
# after editing a file do this :
$ git add .
$ git commit -m "run github action"
$ git push
```

If you go on our repository, you can see in the tab Actions the different results of our test. On our project you can go in the *.github* folder to see our code to run the application.

```bash
$ cd .github/workflows
# for atom
$ atom .
# for vscode
$ code .
```

The first test are the application test, this is the continuous integration part.

![image-20211222104312442](C:\Users\clemf\AppData\Roaming\Typora\typora-user-images\image-20211222104312442.png)

First the application initialize containers then it installs the necessary tools (eg. Nodejs) and it run the tests and give a check if everything was ok.

Then, once the tests and everything are working correctly, we can deploy our app the Heroku platform.

Here are the results for automatic deployment on Heroku :

![image-20211222104551201](C:\Users\clemf\AppData\Roaming\Typora\typora-user-images\image-20211222104551201.png)

We had to add a Heroku key and put it in the access keys of our repository so the connection is secure between Github and Heroku but it also links my Heroku account to the Github repository.

**You can find our app deploy on Heroku at this address : [https://devops-project2021-2022.herokuapp.com/](https://devops-project2021-2022.herokuapp.com/)**

*Note: To run the app we add to enter a credit card otherwise we couldn't add redis to the service.*

## 3. Infrastructure as code

In this part, we had to configure a Virtual Machine (VM) with vagrant and run it under Linux. Then we had to provision this machine to run our app using Ansible.

For this part we need to install vagrant.

You can go in the *iac* folder to see the different files and tasks we have done.

We created our VM and added our files in it using **syncfolder**. We used ubuntu distribution instead of centos because we thought it was easier to use. Then, we ran playbooks. We can tell to Ansible what we want to run using a *run.yml* file at the root of the playbooks folder.

We installed the following resources :

- Redis
- Node
- Npm

Once these packages are installed, we installed the packages to run our application using *npm install*. We also installed *forever* to run *npm start* then otherwise the task is blocked at this point.

To finish, we added health checks. We checked that redis was running correctly and we checked that the test of the app ran correctly.

*Note: we can run the test only if we didn't run the application otherwise we got an error.*

If you want to create the VM and see the different tasks played by ansible you can do what's following :

```bash
# go to the folder
$ cd iac
# run vagrant to create the VM
$ vagrant up
# if you want to stop the VM
$ vagrant destroy
```

Then if you ran the VM, you can then enter in it and check the import folder etc..

```bash
# enter the VM
$ vagrant ssh
```

We got the following result :

```bash
==> ubuntu_server: Running provisioner: ansible_local...
    ubuntu_server: Installing Ansible...
    ubuntu_server: Running ansible-playbook...

PLAY [ubuntu_server] ***********************************************************

TASK [Gathering Facts] *********************************************************
ok: [ubuntu_server]

TASK [app/database : Update] ***************************************************
changed: [ubuntu_server]

TASK [app/database : Installing Redis] *****************************************
changed: [ubuntu_server]

TASK [app/node : Install curl] *************************************************
ok: [ubuntu_server]

TASK [app/node : Get node repo] ************************************************
changed: [ubuntu_server]

TASK [app/node : N LTS] ********************************************************
changed: [ubuntu_server]

TASK [app/node : Install node] *************************************************
changed: [ubuntu_server]

TASK [app/node : Upgrade npm] **************************************************
changed: [ubuntu_server]

TASK [app/install : Install packages using npm] ********************************
changed: [ubuntu_server]

TASK [app/install : Install forever (to run Node.js app).] *********************
changed: [ubuntu_server]

TASK [app/install : Check list of Node.js apps running.] ***********************
ok: [ubuntu_server]

TASK [app/install : Start app] *************************************************
changed: [ubuntu_server]

TASK [app/healthchecks : Check Redis health] ***********************************
changed: [ubuntu_server]

TASK [app/healthchecks : Print Redis health] ***********************************
ok: [ubuntu_server] => {
    "msg": "PONG"
}

PLAY RECAP *********************************************************************
ubuntu_server              : ok=14   changed=10   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

```

*Note: Result was too long for screenshot*

![img](https://cdn.discordapp.com/attachments/911549366450417696/923160372129726484/unknown.png)

Vagrant ssh, show that app is running and node and npm also.

## 4. Docker

In this step, we are going to containerize our application to make it run on different environment. We will use Docker to do so.

We created a Dockerfile where we first install the packages (after copying package.json) and then we copy only the userapi folder and run npm start so our app is running in the container and expose it on the port we wrote. We also created a .*dockerignore* file to ignore the file and folders in the *userapi* folder we don't want to put in our container.

Here is how we build and ran our container :

```bash
# build container
$ docker build -t projet-devops-test .
# run our container
$ docker run -p 3000:3000 projet-devops-test

# then if everything ok we can push docker on repository
# tag container
$ docker tag projet-devops-test redseahorse/projet-devops-test
# login
$ docker login
# push image
$ docker push redseahorse/projet-devops-test
```

Our image is accessible under the name **redseahorse/projet-devops-test** or you can see it on this link : [redseahorse/projet-devops-test](https://hub.docker.com/repository/docker/redseahorse/projet-devops-test)

After running the container :

![image-20211222115911815](C:\Users\clemf\AppData\Roaming\Typora\typora-user-images\image-20211222115911815.png)

After creating our container, we need to orchestrate it with redis container so the app run correctly.

## 5. Docker Compose

In this part we are going to present you the docker compose orchestration. It enables to connect multiple containers under the same network and create connection between each other. Our app needs to connect to redis which will run in another container.

In our docker compose file, we created two services. The first service enables to run redis. We define the port on which the service run. We pull the redis image from the docker hub. We added a volume to store data. Also we provide a health check on it. Indeed, the second service needs redis to run correctly before running otherwise it will give an error and will not be able to connect to redis. So we run a command in the redis container to check if it is running. When it is, the second service can be created. 

This second service pulls the image we have created just before of our application. We define also a volume to keep the data generate by the application. Finally, we added environment variables for the host and port of redis. So if the application is deployed on external environment, the application can still communicate with redis.

When we first ran the application we had one error because of redis connection issue. To fix it, we changed the environment variable when we create redis client just like this :

```javascript
host: process.env.REDIS_HOST || "127.0.0.1",
port: process.env.REDIS_PORT || 6379,
```

If you want to run the docker compose file do as follow :

```bash
# run docker compose (you can add -d option to run it in background)
$ docker-compose up
# to stop the docker compose
$ docker-compose down
```

Here are the results :

![image-20211222143154847](C:\Users\clemf\AppData\Roaming\Typora\typora-user-images\image-20211222143154847.png)

*In the console*

![image-20211222143217309](C:\Users\clemf\AppData\Roaming\Typora\typora-user-images\image-20211222143217309.png)

*On the web*

If we refresh the page, the variable increments because data is stored.

![image-20211222143554677](C:\Users\clemf\AppData\Roaming\Typora\typora-user-images\image-20211222143554677.png)

## 6. Kubernetes

In this part we are going to use Kubernetes to make container orchestration.

To make our app running under kubernetes, we have to create two services covering two different deployments.

The first deployment concerns redis. We create one pod under this deployment and we define the container running in it. It is a container that pulls the redis image. We also define a volume with this deployment to persist redis data but we will talk about the volumes just after. Once we declare the deployment with the port of the container.. we define a service linked to this deployment.

The second deployment will deploy our application. We do the same thing as we did for the first deployment but we don't persist volumes and we took our image to run it under the deployment. We define environment variables so we can expose our deployment on external services. Then we create our service.

We just created two services : one for the database (redis) and one for our API (userapi).

To store redis data we use persistent volumes. This volume will be stored in Minikube (in the master cluster). To create this volume we use our persistent volume file (you can check it on our repository). Then we made a file to claim for persistent volume (this is the persistent volume claim) and link it to our application (here redis). So if our pod crash or whatever, the data will be still stored and put back on the pod once it is regenerated.

To run the different files you can do as follow :

```bash
# go to k8s
$ cd k8s
# create persistent volume
$ kubectl apply -f PVolume.yaml
# create persistent volume claim
$ kubectl apply -f PVClaim.yaml
# create redis service
$ kubectl apply -f redis.yaml
# create api service
$ kubectl apply -f service.yaml
```

Once done, we have the following results :

![unknown.png (1338×145)](https://cdn.discordapp.com/attachments/703532874997170256/922819679544823838/unknown.png)

*Persistent volume and persistent volume claim linked*.

![image-20211222153349579](C:\Users\clemf\AppData\Roaming\Typora\typora-user-images\image-20211222153349579.png)

*Get logs of pods to see if there are running correctly.*

To finish on Kubernetes, we had a problem to connect API pod to redis pod because of the retry strategy. There was no retry strategy so when the pod started it couldn't connect to redis and didn't retry the connection. We change the retry strategy, that's why now there is no more connection issue.

```javascript
retry_strategy: (options) => {
    if (options.total_retry_time > 1000 * 60 * 60) {
      // The connection is never going to get up again
      // kill the client with the error event
      return new Error('Retry time exhausted');
    }
    // attempt reconnect after this delay
    return Math.min(options.attempt * 100, 3000)
  }
```

## 7. Istio

