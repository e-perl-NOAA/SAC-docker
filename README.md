# The sac-docker Docker Image
### Table of Contents
- [SAC Docker Image Contents](#sac-docker-image-contents)
- [How to Use this Docker Image](#how-to-use-this-docker-image)
  - [Simple Usage (not saving files)](#simple-usage-not-saving-files)
  - [Save Work by Copying Scenarios and Bookmarks to a GitHub Repository](#save-work-by-copying-scenarios-and-bookmarks-to-a-github-repository)
  - [Save Work by Creating a Fork of the SAC Tool and Pushing Changes to That](#save-work-by-creating-a-fork-of-the-sac-tool-and-pushing-changes-to-that)
  - [Mount .gitconfig File when Starting Container (only suitable for Docker Desktop)](#mount-gitconfig-file-when-starting-container-only-suitable-for-docker-desktop)
- [Connect to GitHub](#connect-to-github)
- [Stop the Image](#stop-the-image)
## SAC Docker Image Contents
- Uses the [rocker/tidyverse image](https://rocker-project.org/images/versioned/rstudio.html)
- ADMB & SS3 in $PATH
  - Builds ADMB from source and puts it in the $PATH
  - Builds [Stock Synthesis (SS3)](https://github.com/nmfs-ost/ss3-source-code) version 3.30.22.1 and puts in $PATH
  - *These steps are not necessary since the SAC tool comes with SS3 executables contained within the repository, but it does allow you to run SS3 and ADMB outside of the SAC tool if desired.*
- Installs R packages using associated with SS3 including:
  - {[r4ss](https://github.com/r4ss/r4ss)} - Also contains the get_ss3_exe() function to download the SS3 executable if the user would like to use this option; see the {r4ss} [documentation](https://r4ss.github.io/r4ss/articles/r4ss-intro-vignette.html) for more details
  - {[ss3sim](https://github.com/ss3sim/ss3sim)}
  - {[ss3diags](https://github.com/jabbamodel/ss3diags)}
  - {[HandyCode](https://github.com/chantelwetzel-noaa/HandyCode)}
  - {[nwfscDiag](https://github.com/nwfsc-assess/nwfscDiag)}
- Installs R packages for plotting and parallel processing
  - {ggplot2}
  - {purrr}
  - {furrr}
  - {parallelly}
  - {shiny}
  - etc. (see [install_r_packages.R](https://github.com/e-perl-NOAA/build-admb-ss3-docker/blob/main/install_r_packages.R) for the full list of installed packages)
- Clones the [SAC Tool repository](https://github.com/shcaba/SS-DL-tool) to the container and sets it as the working directory.

## How to Use this Docker Image
### Simple Usage (not saving files)
To use this Docker image locally you will need to have Docker Desktop installed on your computer (if you are with NMFS, this will likely involve IT). You can also use this image in GitHub Codespaces.

I suggest that you use the following workflow to pull and run this Dockerfile:
- Run these commands in your terminal/command line:
  ```
  docker pull egugliotti/sac-docker:main
  docker run -it --rm -p 8787:8787 -e PASSWORD=a egugliotti/sac-docker:main
  ```
- Open up your preferred browser and type in http://localhost:8787 **OR** go to *Ports* in the container (Docker or Codespaces) and there is a globe icon ( :globe_with_meridians: ) that you can click on (you may have to hover over a portion of where the port is displayed to see the icon) and it will bring up the port in a browser.
- Enter the Username (`rstudio` unless configured otherwise by including `-e USERNAME=username` in the `docker run` command) and the Password (the password you set up in the `docker run` command, in this case, its `a`).

**Without saving the work you did some way, either by committing to a GitHub repository or downloading the files, anything that you did will disappear**

### Save Work by Copying Scenarios and Bookmarks to a GitHub Repository
- Create a GitHub repository that will house your scenarios and input bookmarks. All this repository needs to get you started is a README file with a short description.
- Open up a Codespace in this repository or open up Docker Desktop.
- Run these commands in your terminal/command line:
  ```
  docker pull egugliotti/sac-docker:main
  docker run -it --rm -p 8787:8787 -e PASSWORD=a egugliotti/sac-docker:main
  ```
- Open up the Port and use the SAC tool to run a scenario.
- Use the `docker ps` command to find the container ID (its the first thing in the list).
- Go back to the Codespace or your terminal if using Docker desktop and enter the following commands:
  ```
  sudo docker cp container-id:/home/rstudio/SS-DL-tool/Scenarios/ /workspaces/YOUR-REPOSITORY-NAME
  sudo docker cp container-id:/home/rstudio/SS-DL-tool/shiny_bookmarks /workspaces/YOUR-REPOSITORY-NAME
  ```
  *If using Docker Desktop you may not need the sudo command and instead of /workspaces/YOUR-REPOSITORY-NAME you would put where on your machine you would like the folder to be saved.*
- Save the changes in your repository and you will be able to use them later.
- You can copy these files back to the docker container with the reverse of the commands previously used, still doing `docker ps` first to make sure you have the correct container ID.
  ```
  sudo docker cp /workspaces/YOUR-REPOSITORY-NAME container-id:/home/rstudio/SS-DL-tool/Scenarios/
  sudo docker cp /workspaces/YOUR-REPOSITORY-NAME container-id:/home/rstudio/SS-DL-tool/shiny_bookmarks
  ```
### Save Work by Creating a Fork of the SAC Tool and Pushing Changes to That
- Create a Fork of the SAC Tool
- Open up a Codespace in this repository or use Docker desktop to use Docker.
- Run these commands in your terminal/command line:
  ```
  docker pull egugliotti/sac-docker:main
  docker run -it --rm -p 8787:8787 -e PASSWORD=a egugliotti/sac-docker:main
  ```
- Open up the port.
- Click `File` in the lefthand corner, then `New Project`.
- Choose `Version Control` > `Git`.
- Copy the repository URL (you can find this under the `<> Code` button `Local` option where it will say "Clone").
- Give the project directory a name (e.g., SS-DL-tool-fork) and click `Create Project`.
- Go to the .gitignore file and comment out the Scenarios and the shiny_bookmarks lines so that git tracks those files too.
- Go through the [connect to GitHub](#connect-to-github) steps.
- Run the SAC tool IN YOUR FORK (you can do this with your files and specifications or example bookmarked input and files).
- Commit and push the changes to your fork of the SAC tool.

### Mount .gitconfig File when Starting Container (only suitable for Docker Desktop)
- Follow the [connect to GitHub](#connect-to-github) steps on your local machine (you can do these from a normal terminal) including the step to add your token to the .gitconfig file.
- Now run the following whenever you run the docker container so that you don't have to re-enter your git credentials every time you run the container.
  ```
  docker run \
  -it \
  --rm \
  -p 8787:8787 \
  -e PASSWORD=a \
  --mount type=bind,source=$HOME/.gitconfig,target=/home/rstudio/.gitconfig \
  egugliotti/sac-docker:main
  ```
  *`source` is where you have your file stored on your machine, `target` is where you will have your file stored on the container.*
- **Please remember to add the .gitconfig file to your .gitignore file, you do not want this stored on your GitHub repository**

## Connect to GitHub
### Using git config
**This step is essential if you would like to make/save changes in a GitHub repository.**
- Open up a terminal in RStudio and enter the following:
  ```
  git config --global user.name "your-username"
  git config --global user.email "yourname@your.com"
  git config --global credential.helper store
  ```
- Go to your GitHub profile settings and scroll down to `<> Developer settings` > `Personal Access Tokens` > `Tokens (classic)`.
- Create a new Personal Access Token, give it a name that is descriptive, and the permissions you want it to have and click `Generate Token`.
- Save the token somewhere that you can find it again (I have a notes file with my Personal Access Tokens).
- When you go to push your commits to GitHub, you will be asked for your username and password, the Personal Access Token string is that password.
- **You can add your token to your .gitconfig file but ONLY if you are using Docker Desktop/do not save you .gitconfig file in a repository.**
  - Run git config --global --edit
  - Add the following lines to your .gitconfig file:
    ```
    [github]
  	    user = your-username
        token = YOUR-TOKEN-STRING
    ``` 
### Using Credentials Manager
- [Instructions on how to use the {usethis} package to manage GitHub credentials](https://gist.github.com/Z3tt/3dab3535007acf108391649766409421).
  
## Stop the Image
- Run the following command:
  ```
  docker ps
  ```
  which will return a list of images running similarly to the following where the value of "NAMES" changes each time:
  ```
  CONTAINER ID   IMAGE                               COMMAND   CREATED          STATUS          PORTS                    NAMES
  e7cde94f3768   e-gugliotti/sac-docker   "/init"   56 seconds ago   Up 55 seconds   0.0.0.0:8787->8787/tcp   gifted_meitner
  ```
- Run the following command, replacing `gifted_meitner` with the name returned from `docker ps`.
  ```
  docker stop gifted_meitner
  ```
- You can also use the Docker Desktop GUI to stop the image.
