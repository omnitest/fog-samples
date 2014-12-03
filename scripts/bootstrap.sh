#!/usr/bin/env bash

set -o pipefail
set -o errexit
# set -o xtrace

SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASE_DIR="$(dirname "$SCRIPTS_DIR")"
FIXTURE_DIR="$BASE_DIR/fixtures"

# Create a file larger than 5GB for large file upload test
# mkfile -n 6g $FIXTURE_DIR/large_file.bin

# Grab a sample website for the directory upload tests
git clone https://github.com/thoughtworks/p2 $FIXTURE_DIR/sample_site/p2
