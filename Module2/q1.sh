#!/bin/bash
find . -maxdepth 1 -type f -size +1M > large_files.txt
