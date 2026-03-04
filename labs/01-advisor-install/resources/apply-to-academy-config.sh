#!/bin/bash
set -ex
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

ytt -f ${SCRIPT_DIR}/workshop.yaml -f ${SCRIPT_DIR}/transform-to-academy.yml > ${SCRIPT_DIR}/../../../resources/apply/01-advisor-install.yaml