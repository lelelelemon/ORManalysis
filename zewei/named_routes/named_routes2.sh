#!/bin/bash
bundle exec rake routes > routes.txt
./process_routes.py routes.txt > named_routes.txt
