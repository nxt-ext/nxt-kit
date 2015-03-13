# Nxt Kit
* Nxt Kit is an easy way to deploy/update [Nxt](https://bitcointalk.org/index.php?topic=587007.0) on any number of your VPS or Dedicated Servers.
* !!! For the most of the people it is more convenient [not to manage nodes by themselves](https://nxtforum.org/index.php?topic=4706.0).

### Features
* Supports almost any Linux distribution.
* Hallmarks nodes, changes config to make node public.
* Detects malfunctioning and automatically restarts client.
  * Caches valid chain. 

## Usage
To deploy new version of Nxt, download it via `safe-nxt-download.sh`, [check](https://bitcointalk.org/index.php?topic=345619.msg4406124#msg4406124) file signature and execute playbook.

```
cd ~/nxt-kit/distrib
./safe-nxt-download.sh 1.1.4 # replace with the latest version. CHECK FOR OK
ansible-playbook -f 10 -v ~/nxt-kit/playbooks/deploy.yml
```

## Installation
### On managed VPS nodes
1. Satisfy [these requirements](http://docs.ansible.com/intro_installation.html#managed-node-requirements). For the latest Debian/RedHat it would work out of the box.
2. Configure SSH access using [key authentication](http://lmgtfy.com/?q=ssh+key+authentication) without password.
3. If you are **not** paranoid
  * add user to [sudo with NOPASSWD](http://lmgtfy.com/?q=sudo+nopasswd+all+commands) for all commands.
4. If you are paranoid
  * install `openjdk-7-jre` and `unzip` packages manually.
 
### On control machine
1. Install [ansible](http://docs.ansible.com/intro_installation.html#installing-the-control-machine) and [openssh-client](http://lmgtfy.com/?q=how+to+install+openssh-client+on+linux).
2. Add your servers to [inventory group](http://www.ansibleworks.com/docs/intro_inventory.html) `nxts`.
3. Add `exec ssh-agent bash` to the end of `~/.profile`.
4. SSH and exit *to each* of your managed node (to cache their public keys).
5. Add `ssh-add ~/.ssh/PRIVATE-KEY-FOR-REMOTE-SERVER > /dev/null 2>&1` to the end of the `~/.bashrc` *for each* remote server.
6. Relogin.
7. Clone this repo to `~/nxt-kit` via `git clone https://github.com/nxt-ext/nxt-kit.git ~/nxt-kit`.
8. Put valid tarred, gzipped `nxt_db` folder as `~/nxt-kit/distrib/chain-original-conf.tar.gz` (_optional_).
9. If you **was** paranoid on managed nodes installation
  * Remove [dependency install block](https://github.com/nxt-ext/nxt-kit/blob/c546771aad40b52eb113f8dbe368076f2df064b4/playbooks/deploy.yml#L34-L50) from `~/nxt-kit/playbooks/deploy.yml`.
 
## Contacts
* There is a [thread](https://nxtforum.org/public-nodes-vpss/%28nxt-kit%29-vps-management-software-by-emoneyru/) on NXT Forum for this tool. Feel free to discuss it there.
* Also you can PM me (EmoneyRu) on [BCT](https://bitcointalk.org/index.php?action=profile;u=125071;sa=summary) or [NXT Forum](https://nxtforum.org/index.php?action=profile;u=300).

## Donations
* [NXT-VPP6-RFBG-WMAH-54SDX](http://www.nxtexplorer.com/nxt/nxt.cgi?action=3000&acc=4516831954849355428)

