FROM fedora:25

RUN dnf install gnupg wget dnf-plugins-core python -y  \
	&& rpm --import "http://keyserver.ubuntu.com/pks/lookup?op=get&search=0x3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF" \
	&& dnf config-manager --add-repo http://download.mono-project.com/repo/centos7/ \
        && dnf install libzip mono-devel nuget msbuild referenceassemblies-pcl -y \
        && dnf clean all

RUN dnf install curl unzip java-1.8.0-openjdk-headless java-1.8.0-openjdk-devel -y && \
    dnf clean all

RUN mkdir -p /android/sdk && \
    curl -k https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip -o sdk-tools-linux-3859397.zip && \
    unzip -q sdk-tools-linux-3859397.zip -d /android/sdk && \
    rm sdk-tools-linux-3859397.zip

RUN cd /android/sdk && \
    yes | ./tools/bin/sdkmanager 'build-tools;25.0.3' platform-tools 'platforms;android-25' 'ndk-bundle'

RUN curl -L https://jenkins.mono-project.com/view/Xamarin.Android/job/xamarin-android-linux/515/Azure/processDownloadRequest/xamarin-android/oss-xamarin.android_v7.4.99.139_Linux-x86_64_HEAD_1242e19.tar.bz2 \
        -o oss-xamarin.android.tar.bz2 && \
    tar xjf oss-xamarin.android.tar.bz2 && \
    mv oss-xamarin.android_v7.4.99.139_Linux-x86_64_HEAD_1242e19 /android/xamarin && \
    ln -s /android/xamarin/bin/Debug/lib/xbuild-frameworks/MonoAndroid/ /usr/lib/mono/xbuild-frameworks/MonoAndroid && \
    rm oss-xamarin.android.tar.bz2

ENV ANDROID_NDK_PATH=/android/sdk/ndk-bundle
ENV ANDROID_SDK_PATH=/android/sdk/
ENV PATH=/android/xamarin/bin/Debug/bin:$PATH
ENV JAVA_HOME=/usr/lib/jvm/java/
