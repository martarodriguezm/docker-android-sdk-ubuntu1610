FROM ubuntu:16.04

ENV ANDROID_HOME /opt/tools


# ------------------------------------------------------
# --- Install required tools

RUN apt-get update -qq

# Base (non android specific) tools
# -> should be added to bitriseio/docker-bitrise-base

# Dependencies to execute Android builds
#RUN dpkg --add-architecture i386
#RUN apt-get update -qq
#RUN DEBIAN_FRONTEND=noninteractive apt-get install -y openjdk-8-jdk libc6:i386 libstdc++6:i386 libgcc1:i386 libncurses5:i386 libz1:i386
RUN apt-get install -y openjdk-8-jdk wget expect
RUN apt-get install -y curl
RUN apt-get install -y unzip

# ------------------------------------------------------
# --- Download Android SDK tools into $ANDROID_HOME

RUN cd /opt && wget -q https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip -O android-sdk.zip
RUN cd /opt && unzip android-sdk.zip
RUN cd /opt && rm -f android-sdk.zip

ENV PATH ${PATH}:${ANDROID_HOME}


# ------------------------------------------------------
# --- Install Android SDKs and other build packages

# Other tools and resources of Android SDK
#  you should only install the packages you need!
# To get a full list of available options you can use:
#  android list sdk --no-ui --all --extended
# (!!!) Only install one package at a time, as "echo y" will only work for one license!
#       If you don't do it this way you might get "Unknown response" in the logs,
#         but the android SDK tool **won't** fail, it'll just **NOT** install the package.
RUN echo y | touch /root/.android/repositories.cfg
RUN echo y | android update sdk --no-ui --all --filter platform-tools | grep 'package installed'
#RUN echo y | android update sdk --no-ui --all --filter extra-android-support | grep 'package installed'

# SDKs
# Please keep these in descending order!
RUN echo y | android update sdk --no-ui --all --filter android-27 | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter android-26 | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter android-25 | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter android-17 | grep 'package installed'

# build tools
# Please keep these in descending order!
RUN echo y | android update sdk --no-ui --all --filter build-tools-26.0.2 | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter build-tools-26.0.1 | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter build-tools-25.0.3 | grep 'package installed'

# Extras
RUN echo y | android update sdk --no-ui --all --filter extra-android-m2repository | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter extra-google-m2repository | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter extra-google-google_play_services | grep 'package installed'

# Copy install tools
COPY tools /opt/tools

#Copy accepted android licenses
COPY licenses ${ANDROID_HOME}/licenses

ENV PATH ${PATH}:/opt/tools
# Update SDK
RUN /opt/tools/android-accept-licenses.sh android update sdk --no-ui --obsolete --force

RUN apt-get clean

RUN chown -R 1000:1000 $ANDROID_HOME
VOLUME ["/opt/android-sdk-linux"]
