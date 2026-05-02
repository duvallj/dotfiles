#!/bin/zsh

if [[ -z $2 ]]; then
    2=5
fi

if [[ $(light) -ge 0.7 ]] || [ "$1" = "-A" ]; then
    local human
    local machine
    human=$(echo "(100*l($(light)))/l(100)" | bc -l)
    echo "human=$human"
    if [ "$1" = "-A" ]; then
        human=$(($human+$2))
    fi
    if [ "$1" = "-S" ]; then
        human=$(($human-$2))
    fi
    echo "new=$human"
    machine=$(echo "e(($human*l(100))/100)" | bc -l)
    echo "machine=$machine"
    light -S $machine; 
fi
