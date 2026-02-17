#!/bin/bash
kill -9 $(ps aux --sort=-%mem | awk 'NR==2 {print $2}')
