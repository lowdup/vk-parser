#!/bin/bash
parsing_dir=messages
count=1
echo "========= PARSING START ========="
for entry in "$parsing_dir"/*
do
    linkstr=""
    echo "========= ITERATION "$count" START ========="
    echo "========= SCANNING USER "$entry" ========="
    for parsing_file in "$entry"/*
    do
        echo "========= PARSING FILE: "$parsing_file" ========="
        linkstr+="$(iconv -f cp1251 "$parsing_file" | grep -A1 -F '>Фотография<' | grep https | cut -d"'" -f4)"
    done
    if [[ -n "$linkstr" ]]; then
        mkdir -p output/"$entry"
        echo "$linkstr" >> output/"$entry"/output.txt
        echo "========= PHOTOS IN USER "$entry" FIND! DOWNLOADING! ========="
        aria2c -j 32 --continue=false --input-file=output/"$entry"/output.txt --dir=output/"$entry" --console-log-level=warn
    else
        echo "========= "$entry" WITHOUT PHOTOS ========="
    fi
    let "count++"
    echo "====================================================================================================================="
done