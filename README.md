# Nxt Kit
Nxt Kit is an easy way to deploy/update [Nxt](https://bitcointalk.org/index.php?topic=345619.0) on any number of your VPS or Dedicated Servers. 

### Features
* Supports almost any Linux distribution and FREE [OpenShift](https://www.openshift.com/).
* Hallmarks nodes, changes config to make node public.
* Detects malfunctioning and automatically restarts client.
  * Caches valid chain. 

## Usage
To deploy new version of Nxt, download it locally to distrib/ folder, [check](https://bitcointalk.org/index.php?topic=345619.msg4406124#msg4406124) file signature, create symbolic link and execute playbook. 

```
cd ~/nxt-kit/distrib
./safe-nxt-download.sh 1.1.4 # replace with the latest version. CHECK FOR OK
ansible-playbook -f 10 -v ~/nxt-kit/playbooks/deploy.yml
```

You should execute OpenShift's playbook from specific folder due to RedHat's limitations.  
Standart playbook should be executed from any folder **except** OpenShift's.
```
cd ~/nxt-kit/playbooks/openshift
ansible-playbook -f 10 -v deploy.yml
```

## Installation
### On managed VPS nodes
1. Satisfy [these requirements](http://docs.ansible.com/intro_installation.html#managed-node-requirements). For latest Debian/RedHat it would work out of the box.
2. Configure SSH access using [key authentication](http://lmgtfy.com/?q=ssh+key+authentication) without password.
3. If you are **not** paranoid
  * add user to [sudo with NOPASSWD](http://lmgtfy.com/?q=sudo+nopasswd+all+commands) for all commands.
4. If you are paranoid
  * install `openjdk-7-jre` and `unzip` packages manually.
 
### On managed FREE OpenShift nodes
1. [Register](https://www.openshift.com/app/account/new).
2. Select [Add Application…](https://openshift.redhat.com/app/console/application_types).
3. At the bottom select [Do-It-Yourself 0.1](https://openshift.redhat.com/app/console/application_type/cart!diy-0.1).
4. Choose any URL, ignore `Git` field and create an application.
5. Go to the [Applications tab](https://openshift.redhat.com/app/console/applications) and choose created app. 
6. Press "Or, see the entire list of cartridges you can add" and add "Cron 1.4" cartridge.
7. On the app page press "Want to log in to your application?" to get the SSH user and host names. 
 
### On control machine
1. Install [ansible](http://docs.ansible.com/intro_installation.html#installing-the-control-machine) and [openssh-client](http://lmgtfy.com/?q=how+to+install+openssh-client+on+linux).
2. [Add](https://forums.nxtcrypto.org/viewtopic.php?p=1064#p1064) your servers to [inventory group](http://www.ansibleworks.com/docs/intro_inventory.html) `nxts`.
3. Add your OpenShifts to inventory group `openshifts`. Don't forget to set [ansible_ssh_user](https://forums.nxtcrypto.org/viewtopic.php?p=3688#p3688).
4. Add `exec ssh-agent bash` to the end of `~/.profile`.
5. SSH to each of your managed node (to cache their public keys).
6. Add `ssh-add ~/.ssh/PRIVATE-KEY-FOR-REMOTE-SERVER > /dev/null 2>&1` to the end of the `~/.bashrc` *for each* remote server.
7. Relogin.
8. Clone this repo to `~/nxt-kit` via `git clone https://github.com/nxt-ext/nxt-kit.git ~/nxt-kit`.
9. Add valid `nxt_db` gzipped-tar folder to `~/nxt-kit/distrib/chain-original.tar.gz` (_optional_).
10. If you **was** paranoid on managed nodes installation
  * Remove [dependency install block](https://github.com/nxt-ext/nxt-kit/blob/c546771aad40b52eb113f8dbe368076f2df064b4/playbooks/deploy.yml#L34-L50) from `~/nxt-kit/playbooks/deploy.yml`.
 
## Contacts
Check official [forum thread](https://forums.nxtcrypto.org/viewtopic.php?f=39&t=230), irc channel [#nxtalk](https://bitcointalk.org/index.php?topic=345619.msg5410724#msg5410724) or PM me (EmoneyRu) on [BCT](https://bitcointalk.org/index.php?action=profile;u=125071;sa=summary) or [NXTCrypto](https://forums.nxtcrypto.org/memberlist.php?mode=viewprofile&u=212). 

## Donations
NXT: [999992273311888788](http://87.230.14.1/nxt/nxt.cgi?action=3000&acc=999992273311888788)
