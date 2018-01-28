# Nxt Kit
* Nxt Kit is an easy way to deploy/update [Nxt](https://bitcointalk.org/index.php?topic=587007.0) on any number of your VPS or Dedicated Servers.
* !!! For the most of the people it is more convenient [not to manage nodes by themselves](https://nxtforum.org/index.php?topic=4706.0).

### Features
* Supports almost any Linux distribution.
* Hallmarks nodes, changes config to make node public.
* Detects malfunctioning and automatically restarts client.
  * Caches valid chain.
  * Supports blockchain snapshots from [Jelurida](https://www.jelurida.com/).

## Usage
To deploy new version of Nxt, download it via `safe-nxt-download.sh`, [check](https://bitcointalk.org/index.php?topic=345619.msg4406124#msg4406124) file signature and execute playbook.

```
cd ~/nxt-kit/distrib
./safe-nxt-download.sh 1.1.4 # replace with the latest version. CHECK FOR OK
ansible-playbook -f 10 -v ~/nxt-kit/playbooks/deploy.yml
```

You can also save the outbound traffic of the control machine by downloading a snapshot from [Jelurida](https://www.jelurida.com/) _before_ running the playbook.

```
ansible nxts -m get_url -a "url=https://www.jelurida.com/NXT-nxt_db.zip dest=~/nxt-kit-deployed/distrib/chain-original-conf.zip force=yes" -f 10 -v
```

## Installation
### On managed VPS nodes
1. Satisfy [these requirements](http://docs.ansible.com/ansible/intro_installation.html#managed-node-requirements). For the latest Ubuntu/Debian/RedHat it would work out of the box.
2. Configure SSH access using [key authentication](http://lmgtfy.com/?q=ssh+key+authentication) without password.
3. If you are **not** paranoid
  * add user to [sudo with NOPASSWD](http://lmgtfy.com/?q=sudo+nopasswd+all+commands) for all commands.
4. If you are paranoid
  * install `oracle-java8-installer` and `unzip` packages manually.
 
### On control machine
1. Install [ansible](http://docs.ansible.com/ansible/intro_installation.html#installing-the-control-machine) and [openssh-client](http://lmgtfy.com/?q=how+to+install+openssh-client+on+linux).
2. Add your servers to [inventory group](http://docs.ansible.com/ansible/intro_inventory.html) `nxts`.
3. Add `exec ssh-agent bash` to the end of `~/.profile`.
4. SSH and exit *to each* of your managed node (to cache their public keys).
5. Add `ssh-add ~/.ssh/PRIVATE-KEY-FOR-REMOTE-SERVER > /dev/null 2>&1` to the end of the `~/.bashrc` *for each* private key for remote server.
6. Relogin.
7. Clone this repo to `~/nxt-kit` via `git clone https://github.com/nxt-ext/nxt-kit.git ~/nxt-kit`.
8. Put a valid zipped `nxt_db` folder as `~/nxt-kit/distrib/chain-original-conf.zip` (_optional_). The archive from [Jelurida](https://www.jelurida.com/) is OK.
9. If you **was** paranoid on managed nodes installation
  * Remove [dependency install block](https://github.com/nxt-ext/nxt-kit/blob/c3d96ef4f56ca15b38b324f1eefe0d5dd03acd84/playbooks/deploy.yml#L2-L44) from `~/nxt-kit/playbooks/deploy.yml`.
 
## Contacts
* There is a [thread](https://nxtforum.org/public-nodes-vpss/%28nxt-kit%29-vps-management-software-by-emoneyru/) on NXT Forum for this tool. Feel free to discuss it there.
* Also you can PM me (EmoneyRu) on [BCT](https://bitcointalk.org/index.php?action=profile;u=125071;sa=summary) or [NXT Forum](https://nxtforum.org/index.php?action=profile;u=300).

## Donations
* [NXT-VPP6-RFBG-WMAH-54SDX](https://www.mynxt.info/account/4516831954849355428)

