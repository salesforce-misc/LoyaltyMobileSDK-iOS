#!/bin/bash

# Path to your AppVersion.xcconfig file
CONFIG_FILE_PATH="./SampleApps/MyNTORewards/MyNTORewards/AppVersion.xcconfig"

# A flag to indicate whether the --force option is used
FORCE_UPDATE=0
# Flags to indicate if --app-version or --build-version is used
APP_VERSION_UPDATE=0
BUILD_VERSION_UPDATE=0
INCREMENT_BUILD_UPDATE=0

print_versions () {
    echo "Current App and Build Version:"
    grep -E 'MARKETING_VERSION|CURRENT_PROJECT_VERSION' $CONFIG_FILE_PATH
}

# Function to compare semantic version numbers (format: X.Y.Z)
compare_versions() {
    VERSION_GREATER=$(printf '%s\n' "$2" "$1" | sort -V | head -n 1)
    if [ "$VERSION_GREATER" = "$2" ]; then
        return 0
    else
        return 1
    fi
}

# Parse command line arguments
if [ $# -eq 0 ]
then
    print_versions
    exit 0
fi

# First loop: setting flags and values
for arg in "$@"
do
    case $arg in
        --force)
        FORCE_UPDATE=1
        ;;
        --app-version=*)
        APP_VERSION_UPDATE=1
        NEW_APP_VERSION="${arg#*=}"
        ;;
        --build-version=*)
        BUILD_VERSION_UPDATE=1
        NEW_BUILD_VERSION="${arg#*=}"
        ;;
        --increment-build-version)
        INCREMENT_BUILD_UPDATE=1
        echo "Incrementing Build Version in $CONFIG_FILE_PATH"
        CURRENT_BUILD_VERSION=$(grep -E 'CURRENT_PROJECT_VERSION' $CONFIG_FILE_PATH | cut -d'=' -f2 | tr -d ' ')
        NEW_BUILD_VERSION=$(($CURRENT_BUILD_VERSION + 1))
        sed -i '' "s/^CURRENT_PROJECT_VERSION = .*/CURRENT_PROJECT_VERSION = $NEW_BUILD_VERSION/" $CONFIG_FILE_PATH
        print_versions
        ;;
        --help)
        echo "app_version.sh usage:"
        echo "  No arguments: print current app and build version"
        echo "  --app-version=<version>: set the app version to <version>"
        echo "  --build-version=<build>: set the build version to <build>"
        echo "  --increment-build-version: increment the build version"
        echo "  --force: force set the app or build version even if it's not incremented"
        echo "  --help: display this help message"
        exit 0
        ;;
        *)
        echo "ERROR: Invalid command: $arg"
        echo "app_version.sh usage:"
        echo "  No arguments: print current app and build version"
        echo "  --app-version=<version>: set the app version to <version>"
        echo "  --build-version=<build>: set the build version to <build>"
        echo "  --increment-build-version: increment the build version"
        echo "  --force: force set the app or build version even if it's not incremented"
        echo "  --help: display this help message"
        exit 1
        ;;
    esac
done

# Check if --force is used but --app-version and --build-version were not provided
if [ $FORCE_UPDATE -eq 1 ] && [ $APP_VERSION_UPDATE -eq 0 ] && [ $BUILD_VERSION_UPDATE -eq 0 ] && [ $INCREMENT_BUILD_UPDATE -eq 0 ]
then
    echo "ERROR: The --force flag must be used with one of --app-version, --build-version or --increment-build-version."
    exit 1
fi

# Second loop: processing the flags and values
if [ $APP_VERSION_UPDATE -eq 1 ]
then
    # Check that NEW_APP_VERSION is a valid semantic version number (e.g. 1.0.1)
    if ! [[ $NEW_APP_VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]
    then
        echo "ERROR: Invalid app version: $NEW_APP_VERSION. Must follow MAJOR.MINOR.PATCH format (e.g. 1.0.1)."
        exit 1
    fi
    # Check if new app version is not less than current app version, unless --force is used
    if [ $FORCE_UPDATE -eq 0 ]
    then
        CURRENT_APP_VERSION=$(grep 'MARKETING_VERSION' $CONFIG_FILE_PATH | cut -d'=' -f2 | tr -d ' ')
        if compare_versions $CURRENT_APP_VERSION $NEW_APP_VERSION
        then
            echo "ERROR: New app version: $NEW_APP_VERSION is less than or equal to current app version: $CURRENT_APP_VERSION. App version must be incremented."
            exit 1
        fi
    fi
    echo "Updating App Version to $NEW_APP_VERSION in $CONFIG_FILE_PATH"
    sed -i '' "s/^MARKETING_VERSION = .*/MARKETING_VERSION = $NEW_APP_VERSION/" $CONFIG_FILE_PATH
    print_versions
fi

if [ $BUILD_VERSION_UPDATE -eq 1 ]
then
    # Check that NEW_BUILD_VERSION is a valid integer
    if ! [[ $NEW_BUILD_VERSION =~ ^[0-9]+$ ]]
    then
        echo "ERROR: Invalid build version: $NEW_BUILD_VERSION. Must be an integer."
        exit 1
    fi
    # Check if new build version is not less than current build version, unless --force is used
    if [ $FORCE_UPDATE -eq 0 ]
    then
        CURRENT_BUILD_VERSION=$(grep 'CURRENT_PROJECT_VERSION' $CONFIG_FILE_PATH | cut -d'=' -f2 | tr -d ' ')
        if [ $NEW_BUILD_VERSION -le $CURRENT_BUILD_VERSION ]
        then
            echo "ERROR: New build version: $NEW_BUILD_VERSION is less than or equal to current build version: $CURRENT_BUILD_VERSION. Build version must be incremented."
            exit 1
        fi
    fi
    echo "Updating Build Version to $NEW_BUILD_VERSION in $CONFIG_FILE_PATH"
    sed -i '' "s/^CURRENT_PROJECT_VERSION = .*/CURRENT_PROJECT_VERSION = $NEW_BUILD_VERSION/" $CONFIG_FILE_PATH
    print_versions
fi
