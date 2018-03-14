#!/usr/bin/env sh

########################################################################
#
# pgAdmin 4 - PostgreSQL Tools
#
# Copyright (C) 2013 - 2018, The pgAdmin Development Team
# This software is released under the PostgreSQL Licence
#
#########################################################################
set -e

export PGADMIN_SETUP_EMAIL=${PGADMIN_DEFAULT_EMAIL}
export PGADMIN_SETUP_PASSWORD=${PGADMIN_DEFAULT_PASSWORD}

$@