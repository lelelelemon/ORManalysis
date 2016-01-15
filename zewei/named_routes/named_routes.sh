#!/bin/bash
rails runner list_named_routes.rb > named_routes.txt
ruby list_url_helpers.rb named_routes.txt $1 $2

