#!/bin/bash
cd ~/nxt-kit/nxt
pkill java
nohup java -jar start.jar &
