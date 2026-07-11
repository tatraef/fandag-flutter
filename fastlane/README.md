fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

### firebase_flutter

```sh
[bundle exec] fastlane firebase_flutter
```

Submit a new Builds (iOS and Android) to Firebase

Parameters:

:firebase_id_ios - Firebase iOS App ID

:firebase_id_android - Firebase Android App ID

:force_build_android - Build android - even if :firebase_id_android is empty

:firebase_deploy_web - should build web and deploy to Firebase

:firebase_deploy_web_target - only the hosting target will be deployed.

:test_groups - test groups in Fabric to test build for

:dart_defines - Flutter build args, format: key1=value1;key2=value2

:debug - bool parameter, for checking the assembly without uploading it to Firebase and chat. Use: 'debug:true'

:flavor - android flavor parameter

:scheme - ios scheme parameter

:publish_artifacts - for gitlab artifact links

:android_is_apk - aab or apk

:bundle_sksl_path - path to sksl bundle

### upload_flutter_stores

```sh
[bundle exec] fastlane upload_flutter_stores
```

Submit a upload to Apple Store and Google Play Beta

### resolve_fvm

```sh
[bundle exec] fastlane resolve_fvm
```

Downloading and return the flutter version from the pubspec.lock file.

Used to execute commands of the desired flutter version.

### flutter_analyze_errors

```sh
[bundle exec] fastlane flutter_analyze_errors
```

Analyze errors in flutter project

### flutter_analyze_warnings

```sh
[bundle exec] fastlane flutter_analyze_warnings
```

Analyze lint warnings in flutter project

### flutter_test

```sh
[bundle exec] fastlane flutter_test
```

Run flutter test

### flutter_check_format

```sh
[bundle exec] fastlane flutter_check_format
```

Check formatting for flutter

### flutter_check_format_with_packages

```sh
[bundle exec] fastlane flutter_check_format_with_packages
```

Check formatting for flutter with additional packages

### flutter_format

```sh
[bundle exec] fastlane flutter_format
```

Format for flutter

### flutter_format_with_packages

```sh
[bundle exec] fastlane flutter_format_with_packages
```

Format for flutter with additional packages

### flutter_format_and_push

```sh
[bundle exec] fastlane flutter_format_and_push
```

autoformat for flutter and push

### pub_get_all

```sh
[bundle exec] fastlane pub_get_all
```

Pub get all packages indicated in $flutter_folders variable

### pub_upgrade_major_all

```sh
[bundle exec] fastlane pub_upgrade_major_all
```

pub upgrade --major-versions in packages indicated in $flutter_folders_maj or $flutter_folders variable

### flutter_build

```sh
[bundle exec] fastlane flutter_build
```

Run flutter build

Parameters:

:build_ios

:build_android

:android_is_apk

:build_web - should build web and deploy to Firebase

:test_groups - test groups in Fabric to test build for

:dart_defines - Flutter build args, format: key1=value1;key2=value2

:dart_define_from_file -link to file

:debug - bool parameter, for checking the assembly without uploading it to Firebase and chat. Use: 'debug:true'

:flavor - android flavor parameter

:scheme - ios scheme parameter

### add_youtrack_comment

```sh
[bundle exec] fastlane add_youtrack_comment
```



### form_tag_name

```sh
[bundle exec] fastlane form_tag_name
```

Form tag name for git

### get_current_branch_name_safe

```sh
[bundle exec] fastlane get_current_branch_name_safe
```

Get current git branch name 

### validate_conventional_commits

```sh
[bundle exec] fastlane validate_conventional_commits
```

Validate conventional commits

### lint

```sh
[bundle exec] fastlane lint
```



### fix_issues

```sh
[bundle exec] fastlane fix_issues
```



### fix_issues_and_push

```sh
[bundle exec] fastlane fix_issues_and_push
```



### upload_firebase_dev

```sh
[bundle exec] fastlane upload_firebase_dev
```



### upload_firebase_prod

```sh
[bundle exec] fastlane upload_firebase_prod
```



### upload_firebase_prod_with_inspector

```sh
[bundle exec] fastlane upload_firebase_prod_with_inspector
```



### auto_format

```sh
[bundle exec] fastlane auto_format
```



----


## iOS

### ios tf

```sh
[bundle exec] fastlane ios tf
```

Submit a new Build to TestFlight (ready for AppStore)

This will also make sure the profile is up to date

Parameters:

:scheme - schema(s) to build. May be String or Array with multiple schemas(e.g. 'Store,Shop,AnotherScheme')

:configuration - configuration to build (Debug, Release, etc). default: Release

:export_method - ad-hoc, app-store, enterprise. default: app-store

:export_options - additional options for build_ios_app (gym lane)

flutter: is it flutter build

:dart_defines - Flutter build args, format: key1=value1;key2=value2

:new_version - set new version manually without auto bump

:force_full_cert_sync - force-load every provisioning profile and certificate bound to current project

:skip_cocoapods - skip pod install stage

### ios firebase

```sh
[bundle exec] fastlane ios firebase
```

Submit a new Build to Firebase

This will also make sure the profile is up to date

Parameters:

:scheme - schema(s) to build. May be String or Array with multiple schemas

:firebase_app_id - Firebase App ID

:configuration - configuration to build (Debug, Release, etc)

:export_method - ad-hoc, app-store, enterprise

flutter: is it flutter build

:dart_defines - Flutter build args, format: key1=value1;key2=value2

:test_groups - test groups in Firebase to test build for

:export_options - additional options for build_ios_app (gym lane)

:new_version - set new version manually without auto bump

:force_full_cert_sync - force-load every provisioning profile and certificate bound to current project

### ios sync_certs_for_scheme

```sh
[bundle exec] fastlane ios sync_certs_for_scheme
```

Get certificates and provisionings for selected scheme and configuration

:scheme - scheme to sync certs for

:configuration - configuration to sync for (Debug, Release, etc).

:export_method - ad-hoc, app-store, enterprise. default: ad-hoc

### ios sync_certs

```sh
[bundle exec] fastlane ios sync_certs
```

Get all certificates and provisionings

Can be called as not readonly: 'fastlane ios sync_certs update:true'

### ios add_device_to_scheme

```sh
[bundle exec] fastlane ios add_device_to_scheme
```

Add device(s) to the team related to scheme using api key

:scheme - scheme to search for api key

:configuration - configuration to search for api key (Debug, Release, etc)

### ios upload_flutter_tf

```sh
[bundle exec] fastlane ios upload_flutter_tf
```

Upload flutter to tf

### ios flutter_build_ios

```sh
[bundle exec] fastlane ios flutter_build_ios
```

Build flutter ios

### ios upload_tf

```sh
[bundle exec] fastlane ios upload_tf
```



----


## Android

### android firebase

```sh
[bundle exec] fastlane android firebase
```

Submit a new Build to Firebase

Parameters:

:firebase_app_id - Firebase App ID

:flavor - for example, a (demo) product flavor can specify different features and device requirements

:build_type - The assembly type is used to set the assembly settings (Debug, Release)

:test_groups - test groups in Fabric to test build for

:gradle_path - path where gradle is located

:is_apk - assemble APK, if not - AAB

### android googleplay

```sh
[bundle exec] fastlane android googleplay
```

Submit a upload to Google Play Beta

Parameters:

:flavor - for example, a (demo) product flavor can specify different features and device requirements

:gradle_path - path where gradle is located

:key_path - path where google play json key

:package_name - the package name of the application to use

:dart_defines - Flutter build args, format: key1=value1;key2=value2

:track_name - track_name

:build_type - build_type

### android upload_flutter_gp

```sh
[bundle exec] fastlane android upload_flutter_gp
```

Upload flutter android to Google Play

### android flutter_build_android

```sh
[bundle exec] fastlane android flutter_build_android
```

Build flutter android

### android flutter_release_to_chat

```sh
[bundle exec] fastlane android flutter_release_to_chat
```

Build flutter apk to current mm chat

### android flutter_appgallery

```sh
[bundle exec] fastlane android flutter_appgallery
```

Upload flutter android to Appgallery

### android upload_gp

```sh
[bundle exec] fastlane android upload_gp
```



----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
