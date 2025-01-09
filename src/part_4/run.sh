#!/bin/bash

gcc -o miniserver miniserver.c -lfcgi
spawn-fcgi -p 8080 ./miniserver
service nginx start
/bin/bash
