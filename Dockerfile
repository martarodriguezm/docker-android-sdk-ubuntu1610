FROM ubuntu:16.04

ENV ANDROID_HOME /opt/android-sdk-linux


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

# Install Android SDK installer
ARG ANDROID_SDK_BUILD=3859397
ARG ANDROID_SDK_SHA256=444e22ce8ca0f67353bda4b85175ed3731cae3ffa695ca18119cbacef1c1bea0
RUN curl -o android-sdk.zip "https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_BUILD}.zip" \
  && echo "${ANDROID_SDK_SHA256} android-sdk.zip" | sha256sum -c \
  && unzip -C android-sdk.zip -d "${ANDROID_HOME}" \
  && rm *.zip

COPY tools /opt/sdk-tools

ENV PATH ${PATH}:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:/opt/sdk-tools

# RUN mkdir $ANDROID_HOME/licenses
# RUN echo 8933bad161af4178b1185d1a37fbf41ea5269c55 > $ANDROID_HOME/licenses/android-sdk-license
# RUN echo d56f5187479451eabf01fb78af6dfcb131a6481e >> $ANDROID_HOME/licenses/android-sdk-license
# RUN echo 84831b9409646a918e30573bab4c9c91346d8abd > $ANDROID_HOME/licenses/android-sdk-preview-license

RUN sdkmanager --list \
  && /opt/sdk-tools/android-accept-licenses.sh "sdkmanager --update" \
  && /opt/sdk-tools/android-accept-licenses.sh "sdkmanager build-tools;23.0.3" \
  && /opt/sdk-tools/android-accept-licenses.sh "sdkmanager build-tools;24.0.3" \
  && /opt/sdk-tools/android-accept-licenses.sh "sdkmanager build-tools;25.0.3" \
  && /opt/sdk-tools/android-accept-licenses.sh "sdkmanager build-tools;26.0.2" \
  && /opt/sdk-tools/android-accept-licenses.sh "sdkmanager build-tools;27.0.3" \
  && /opt/sdk-tools/android-accept-licenses.sh "sdkmanager build-tools;28.0.3" \
  && /opt/sdk-tools/android-accept-licenses.sh "sdkmanager sources;android-17" \
  && /opt/sdk-tools/android-accept-licenses.sh "sdkmanager sources;android-23" \
  && /opt/sdk-tools/android-accept-licenses.sh "sdkmanager sources;android-24" \
  && /opt/sdk-tools/android-accept-licenses.sh "sdkmanager sources;android-25" \
  && /opt/sdk-tools/android-accept-licenses.sh "sdkmanager sources;android-26" \
  && /opt/sdk-tools/android-accept-licenses.sh "sdkmanager sources;android-27" \
  && /opt/sdk-tools/android-accept-licenses.sh "sdkmanager sources;android-28" \
  && sdkmanager --list