#!/bin/bash

# The directory of your sample app
APP_DIR="./SampleApps/MyNTORewards"

# Parse command line arguments
for arg in "$@"
do
    case $arg in
        --app-version)
        cd $APP_DIR
        echo "Current App Version:"
        xcrun agvtool what-marketing-version -terse1
        cd - > /dev/null
        ;;
        --build-version)
        cd $APP_DIR
        echo "Current Build Version:"
        CURRENT_BUILD_VERSION=$(xcrun agvtool what-version -terse)
        echo $CURRENT_BUILD_VERSION
        cd - > /dev/null
        ;;
        --update-app-version=*)
        NEW_APP_VERSION="${arg#*=}"
        # Check that NEW_APP_VERSION is a valid semantic version number (e.g. 1.0.1)
        if ! [[ $NEW_APP_VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]
        then
            echo "ERROR: Invalid app version: $NEW_APP_VERSION. Must follow MAJOR.MINOR.PATCH format (e.g. 1.0.1)."
            exit 1
        fi
        echo "Updating App Version to $NEW_APP_VERSION"
        cd $APP_DIR
        xcrun agvtool new-marketing-version $NEW_APP_VERSION
        cd - > /dev/null
        ;;
        --update-build-version)
        echo "Incrementing Build Version"
        cd $APP_DIR
        xcrun agvtool next-version -all
        cd - > /dev/null
        ;;
        --set-build-version=*)
        NEW_BUILD_VERSION="${arg#*=}"
        # Check that NEW_BUILD_VERSION is a valid integer
        if ! [[ $NEW_BUILD_VERSION =~ ^[0-9]+$ ]]
        then
            echo "ERROR: Invalid build version: $NEW_BUILD_VERSION. Must be an integer."
            exit 1
        fi
        cd $APP_DIR
        CURRENT_BUILD_VERSION=$(xcrun agvtool what-version -terse)
        cd - > /dev/null
        if [ $NEW_BUILD_VERSION -ge $CURRENT_BUILD_VERSION ]
        then
            echo "Setting Build Version to $NEW_BUILD_VERSION"
            cd $APP_DIR
            xcrun agvtool new-version -all $NEW_BUILD_VERSION
            cd - > /dev/null
        else
            echo "ERROR: Cannot set build version to a number less than the current build version ($CURRENT_BUILD_VERSION)"
        fi
        ;;
        --help)
        echo "app_version.sh usage:"
        echo "  --app-version: print the current app version"
        echo "  --build-version: print the current build version"
        echo "  --update-app-version=<version>: set the app version to <version>"
        echo "  --update-build-version: increment the build version"
        echo "  --set-build-version=<build>: set the build version to <build>, if it's greater than or equal to the current build number"
        echo "  --help: display this help message"
        exit 0
        ;;
        *)
        echo "ERROR: Invalid command: $arg"
        echo "app_version.sh usage:"
        echo "  --app-version: print the current app version"
        echo "  --build-version: print the current build version"
        echo "  --update-app-version=<version>: set the app version to <version>"
        echo "  --update-build-version: increment the build version"
        echo "  --set-build-version=<build>: set the build version to <build>, if it's greater than or equal to the current build number"
        echo "  --help: display this help message"
        exit 1
        ;;
    esac
done
