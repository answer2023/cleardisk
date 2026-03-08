#!/bin/bash
# Fix SPM lowercase lproj directories
BUNDLE_PATH="$1"
if [ -d "$BUNDLE_PATH/zh-hans.lproj" ] && [ ! -d "$BUNDLE_PATH/zh-Hans.lproj" ]; then
    mv "$BUNDLE_PATH/zh-hans.lproj" "$BUNDLE_PATH/zh-Hans.lproj"
    echo "Fixed: zh-hans.lproj -> zh-Hans.lproj"
fi
