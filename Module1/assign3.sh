#!/bin/bash
mkdir -p dir1/dir2
cd dir1/dir2 
touch file_new.txt
ln -s dir2/file_new.txt dir1/file_path.txt