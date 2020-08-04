#!/bin/bash

tkn pr logs -f -a $(tkn pr ls | awk 'NR==2{print $1}')