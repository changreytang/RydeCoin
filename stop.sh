#!/bin/bash

kill $(ps aux | grep '[n]aivecoin' | awk '{print $2}')

