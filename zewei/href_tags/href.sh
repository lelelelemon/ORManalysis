#!/bin/bash

ruby href_selector.rb $1 $2
ruby href_mapping.rb $2 $3
ruby parse_href_output.rb $3 $4
