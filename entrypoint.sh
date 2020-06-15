#!/bin/bash
set -e

if [ -z "$CHART_FOLDER" ]; then
  echo "CHART_FOLDER is not set. Quitting."
  exit 1
fi

if [ -z "$CHARTMUSEUM_URL" ]; then
  echo "CHARTMUSEUM_URL is not set. Quitting."
  exit 1
fi

if [ -z "$CHARTMUSEUM_USER" ]; then
  echo "CHARTMUSEUM_USER is not set. Quitting."
  exit 1
fi

if [ -z "$CHARTMUSEUM_PASSWORD" ]; then
  echo "CHARTMUSEUM_PASSWORD is not set. Quitting."
  exit 1
fi

if [ -z "$SOURCE_DIR" ]; then
  SOURCE_DIR="."
fi

if [ -z "$FORCE" ]; then
  FORCE=""
elif [ "$FORCE" == "1" ] || [ "$FORCE" == "True" ] || [ "$FORCE" == "TRUE" ]; then
  FORCE="-f"
fi

echo "Updating dependency"
cd /github/workspace/${SOURCE_DIR}/${CHART_FOLDER}
helm dependency update

echo "Moving into ${SOURCE_DIR}"
cd /github/workspace/${SOURCE_DIR}

echo "Helm is packaging ${CHART_FOLDER}"
helm package ${CHART_FOLDER}

echo "  * Packaging finished"
ls
echo ""
echo "Helm is pushing to chartmuseum"
helm push ${CHART_FOLDER}-* ${CHARTMUSEUM_URL} -u ${CHARTMUSEUM_USER} -p ${CHARTMUSEUM_PASSWORD} ${FORCE}
