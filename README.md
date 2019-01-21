# Docker Container for Android
[![](https://images.microbadger.com/badges/image/martarodriguez/docker-android-sdk.svg)](https://microbadger.com/images/martarodriguez/docker-android-sdk "Get your own image badge on microbadger.com")

## Supported Android API versions

Android API 28\
Android API 27\
Android API 26\
Android API 25\
Android API 23\
Android API 24\
Android API 17\

## Supported Build Tools versions

28.0.3\
27.0.3\
26.0.2\
25.0.3\
24.0.3\
23.0.3\

## Usage with Bitbucket Pipelines

With this yml file for Bitbucket pipelines you can compile your Android project and get your apk file in the Downloads section of your repo.

```
image: martarodriguez/docker-android-sdk-ubuntu1610:latest

pipelines:
  branches:
    master:
      - step:
          script:
            - ./build.sh
            - curl -X POST --user "${BB_AUTH_STRING}" "https://api.bitbucket.org/2.0/repositories/${BITBUCKET_REPO_OWNER}/${BITBUCKET_REPO_SLUG}/downloads" --form files=@".../.../androidapp.apk"
```

How to declare BB_AUTH_STRING environment variable in Bitbucket: [Bitbucket Docs](https://confluence.atlassian.com/bitbucket/deploy-build-artifacts-to-bitbucket-downloads-872124574.html)

This is the build.sh file I use to compile my projects:

```bash
#!/bin/sh

cd AndroidProjectFolder/
./gradlew :app:assembleRelease
```


License
-------

    Copyright 2019 Marta Rodriguez Martin

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.