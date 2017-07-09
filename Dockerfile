FROM debian

RUN apt-get update \
        && apt-get install gnupg wget git -y --no-install-recommends \
        && echo "deb http://download.mono-project.com/repo/debian wheezy main" > /etc/apt/sources.list.d/mono-xamarin.list \
        && wget -qO - http://download.mono-project.com/repo/xamarin.gpg | apt-key add - \
        && apt-get update \
        && apt-get install mono-devel nuget referenceassemblies-pcl -y --no-install-recommends \
        && apt-get purge wget -y \
        && apt-get autoremove -y \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/* /var/tmp/*

RUN apt-get update && \
    apt-get install curl unzip  openjdk-8-jdk -y --no-install-recommends && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/tmp/*
    
RUN mkdir -p /android/sdk && \
    mkdir -p /android/xamarin && \
    curl -k https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip -o sdk-tools-linux-3859397.zip && \
    unzip -q sdk-tools-linux-3859397.zip -d /android/sdk && \
    rm sdk-tools-linux-3859397.zip

RUN cd /android/sdk && \
    yes | ./tools/bin/sdkmanager 'build-tools;25.0.3' platform-tools 'platforms;android-25' 'ndk-bundle'
     
RUN curl -L https://jenkins.mono-project.com/view/Xamarin.Android/job/xamarin-android-linux/lastSuccessfulBuild/Azure/processDownloadRequest/xamarin-android/oss-xamarin.android_v7.3.99.59_Linux-x86_64_master_4799ea2.zip \
        -o oss-xamarin.android_v7.3.99.59_Linux-x86_64_master_4799ea2.zip && \
    unzip -q oss-xamarin.android_v7.3.99.59_Linux-x86_64_master_4799ea2.zip \ 
             oss-xamarin.android_v7.3.99.59_Linux-x86_64_master_4799ea2/* \
             -d /android/xamarin && \
    rm  oss-xamarin.android_v7.3.99.59_Linux-x86_64_master_4799ea2.zip 
    
ENV ANDROID_NDK_PATH=/android/sdk/ndk-bundle
ENV ANDROID_SDK_PATH=/android/sdk/
