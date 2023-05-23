#!/bin/bash

# Path to your AppVersion.xcconfig file
CONFIG_FILE_PATH="./SampleApps/MyNTORewards/MyNTORewards/AppVersion.xcconfig"

print_versions () {
    echo "Current App and Build Version:"
    grep -E 'MARKETING_VERSION|CURRENT_PROJECT_VERSION' $CONFIG_FILE_PATH
}

# Parse command line arguments
if [ $# -eq 0 ]
then
    print_versions
    exit 0
fi

for arg in "$@"
do
    case $arg in
        --app-version=*)
        NEW_APP_VERSION="${arg#*=}"
        # Check that NEW_APP_VERSION is a valid semantic version number (e.g. 1.0.1)
        if ! [[ $NEW_APP_VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]
        then
            echo "ERROR: Invalid app version: $NEW_APP_VERSION. Must follow MAJOR.MINOR.PATCH format (e.g. 1.0.1)."
            exit 1
        fi
        echo "Updating App Version to $NEW_APP_VERSION and resetting Build Version to 1 in $CONFIG_FILE_PATH"
        sed -i '' "s/^MARKETING_VERSION = .*/MARKETING_VERSION = $NEW_APP_VERSION/" $CONFIG_FILE_PATH
        sed -i '' "s/^CURRENT_PROJECT_VERSION = .*/CURRENT_PROJECT_VERSION = 1/" $CONFIG_FILE_PATH
        print_versions
        ;;
        --build-version=*)
        NEW_BUILD_VERSION="${arg#*=}"
        # Check that NEW_BUILD_VERSION is a valid integer
        if ! [[ $NEW_BUILD_VERSION =~ ^[0-9]+$ ]]
        then
            echo "ERROR: Invalid build version: $NEW_BUILD_VERSION. Must be an integer."
            exit 1
        fi
        echo "Updating Build Version to $NEW_BUILD_VERSION in $CONFIG_FILE_PATH"
        sed -i '' "s/^CURRENT_PROJECT_VERSION = .*/CURRENT_PROJECT_VERSION = $NEW_BUILD_VERSION/" $CONFIG_FILE_PATH
        print_versions
        ;;
        --increment-build-version)
        echo "Incrementing Build Version in $CONFIG_FILE_PATH"
        CURRENT_BUILD_VERSION=$(grep -E 'CURRENT_PROJECT_VERSION' $CONFIG_FILE_PATH | cut -d'=' -f2 | tr -d ' ')
        NEW_BUILD_VERSION=$(($CURRENT_BUILD_VERSION + 1))
        sed -i '' "s/^CURRENT_PROJECT_VERSION = .*/CURRENT_PROJECT_VERSION = $NEW_BUILD_VERSION/" $CONFIG_FILE_PATH
        print_versions
        ;;
        --help)
        echo "app_version.sh usage:"
        echo "  No arguments: print current app and build version"
        echo "  --app-version=<version>: set the app version to <version> and reset build version to 1"
        echo "  --build-version=<build>: set the build version to <build>"
        echo "  --increment-build-version: increment the build version"
        echo "  --help: display this help message"
        exit 0
        ;;
        *)
        echo "ERROR: Invalid command: $arg"
        echo "app_version.sh usage:"
        echo "  No arguments: print current app and build version"
        echo "  --app-version=<version>: set the app version to <version> and reset build version to 1"
        echo "  --build-version=<build>: set the build version to <build>"
        echo "  --increment-build-version: increment the build version"
        echo "  --help: display this help message"
        exit 1
        ;;
    esac
done
