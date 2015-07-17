#!/bin/bash

function info  {
    echo
    echo "    $@"
}

function error  {
    echo
    echo "    $(tput setaf 1)$@$(tput sgr0)"
}

function success {
    echo
    echo "    $(tput setaf 2)$@$(tput sgr0)"
}

function warn {
    echo
    echo "    $(tput setaf 3)$@$(tput sgr0)"
}

