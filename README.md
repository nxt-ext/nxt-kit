# Nxt extensions
[Ansible](http://www.ansibleworks.com/) kit for deploying [Nxt](https://bitcointalk.org/index.php?topic=345619.0) instances 

## Features

* deploys nxt @ any number of remote servers (VPSs)
* sets `myAddress` automatically
* hallmarks nodes
* updates them on script re-run (if needed)
* crons restart and health check 

## Dependencies 

* [ansible](http://www.ansibleworks.com/docs/intro_installation.html)
* [openssh-client](http://lmgtfy.com/?q=how+to+install+openssh-client+on+linux)

## How to configure

* remote: create user, add it to [sudoers with NOPASSWD](http://lmgtfy.com/?q=sudo+nopasswd+all+commands) for all commands 
* remote: set up [key authentication](http://lmgtfy.com/?q=ssh+key+authentication)
* local: [add your servers to inventory](http://www.ansibleworks.com/docs/intro_inventory.html) to group `nxts`
* local: copy [latest version of nxt](https://bitcointalk.org/index.php?topic=345619.0) to `distrib/nxt.zip`
* local: replace `nxt_tools_folder: ~/ansible/nxt` @ `playbooks/deploy.yml` with your local path to this repository
* local: add `exec ssh-agent bash` to the end of `~/.profile`
* local: add `ssh-add ~/.ssh/PRIVATE-KEY-FOR-REMOTE-SERVER > /dev/null 2>&1` to the end of the `~/.bashrc` *for each* remote server
* local: relogin

## How to run

`ansible-playbook -f 10 -v path/to/repo/playbooks/deploy.yml`

Tips: [999992273311888788](http://87.230.14.1/nxt/nxt.cgi?action=3000&acc=999992273311888788)
