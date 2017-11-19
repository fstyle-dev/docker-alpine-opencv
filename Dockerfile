FROM alpine

ENV CC /usr/bin/clang
ENV CXX /usr/bin/clang++
ENV OPENCV_VERSION=3.3.1

RUN echo -e '@edgunity http://nl.alpinelinux.org/alpine/edge/community\n\
@edge http://nl.alpinelinux.org/alpine/edge/main\n\
@testing http://nl.alpinelinux.org/alpine/edge/testing\n\
@community http://dl-cdn.alpinelinux.org/alpine/edge/community'\
  >> /etc/apk/repositories

RUN apk add --update --no-cache \
      build-base \
      openblas-dev \
      unzip \
      wget \
      cmake \
      #Intel® TBB, a widely used C++ template library for task parallelism'
      libtbb@testing  \
      libtbb-dev@testing   \
      # Wrapper for libjpeg-turbo
      libjpeg  \
      # accelerated baseline JPEG compression and decompression library
      libjpeg-turbo-dev \
      # Portable Network Graphics library
      libpng-dev \
      # A software-based implementation of the codec specified in the emerging JPEG-2000 Part-1 standard (development files)
    #   jasper-dev \
      # Provides support for the Tag Image File Format or TIFF (development files)
      tiff-dev \
      # Libraries for working with WebP images (development files)
    #   libwebp-dev \
      # A C language family front-end for LLVM (development files)
      clang-dev \
      linux-headers && \ 

    mkdir -p /opt && \
    cd /opt && \
    wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip && \
    unzip ${OPENCV_VERSION}.zip && \
    rm -rf ${OPENCV_VERSION}.zip && \

    mkdir -p /opt/opencv-${OPENCV_VERSION}/build && \
    cd /opt/opencv-${OPENCV_VERSION}/build && \
    cmake \
      -D CMAKE_BUILD_TYPE=RELEASE \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D BUILD_SHARED_LIBS=OFF \
      -D WITH_FFMPEG=OFF \
      -D WITH_1394=OFF \
      -D WITH_IPP=OFF \
      -D WITH_OPENEXR=OFF \
      -D WITH_TBB=YES \
      -D WITH_WEBP=OFF \
      -D WITH_JASPER=OFF \
      -D BUILD_TBB=ON \
      -D BUILD_FAT_JAVA_LIB=OFF \
      -D BUILD_TESTS=OFF \
      -D BUILD_PERF_TESTS=OFF \
      -D BUILD_EXAMPLES=OFF \
      -D BUILD_ANDROID_EXAMPLES=OFF \
      -D INSTALL_PYTHON_EXAMPLES=OFF \
      -D BUILD_DOCS=OFF \
      -D BUILD_opencv_python2=OFF \
      -D BUILD_opencv_python3=OFF \
      -D BUILD_opencv_apps=OFF \
      -D BUILD_opencv_dnn=ON \
      .. && \
      make -j"$(getconf _NPROCESSORS_ONLN)" && \
      make install && \
      rm -rf /opt/opencv-${OPENCV_VERSION}
