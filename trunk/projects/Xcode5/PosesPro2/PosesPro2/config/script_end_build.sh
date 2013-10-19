#!/bin/sh

# Crashlytics magic 

./Crashlytics.framework/run 186ef2a41f30e2ce39a21f35b61600d3ae927290

# reveal the binary in the Finder if you like

echo Built at ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}
#/usr/bin/open --reveal "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"

# finished

return 0
