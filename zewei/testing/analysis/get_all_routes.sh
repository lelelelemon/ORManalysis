#!/bin/bash
rake color_routes | sed 's/ //g' | awk -F"|" '{print " "}'
