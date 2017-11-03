FROM dev-env-16.04:latest
USER root
WORKDIR /
RUN apt-get update && apt-get -y install \
libpthread-stubs0-dev \
llvm \
python2.7 \
autoconf \
bison \
cmake \
curl \
flex \
g++ \
pkg-config \
python2.7-dev \
python-mako \
&& echo "Fetch and build mesa 17" \
&& curl -L ftp://ftp.freedesktop.org/pub/mesa/17.0.0/mesa-17.0.0.tar.gz | tar xz \
&& cd mesa-17.0.0 \
&& ./configure \
--disable-dri \
--disable-egl \
--disable-gbm \
--disable-glx \
--disable-omx \
--disable-texture-float \
--disable-xvmc \
--disable-va \
--disable-vdpau \
--enable-gallium-osmesa \
--with-dri-drivers= \
--with-egl-platforms= \
--with-gallium-drivers=swrast \
&& make -j8 \
&& make install \
&& ldconfig \
&& cd / \
&& echo "Fetch and build paraview" \
&& curl -L "https://www.paraview.org/paraview-downloads/download.php?submit=Download&version=v5.4&type=binary&os=Sources&downloadFile=ParaView-v5.4.1.tar.gz" | tar xz \
&& cd ParaView-v5.4.1 \
&& mkdir build \
&& cd build \
&& cmake \
-DCMAKE_BUILD_TYPE=Release \
-DVTK_USE_X=OFF \
-DOPENGL_INCLUDE_DIR=IGNORE \
-DOEPNGL_gl_LIBRARY=IGNORE \
-DOPENGL_xmesa_INCLUDE_DIR=IGNORE \
-DOSMESA_INCLUDE_DIR=/usr/local/include \
-DOSMESA_LIBRARY=/usr/local/lib/libOSMesa.so \
-DPARAVIEW_BUILD_QT_GUI=OFF \
-DPARAVIEW_ENABLE_PYTHON=ON \
-DPYTHON_INCLUDE_DIR=/usr/include/python2.7 \
-DPYTHON_LIBRARY=/usr/lib/x86_64-linux-gnu/libpython2.7.so \
-DVTK_OPENGL_HAS_OSMESA=ON \
-DVTK_USE_OFFSCREEN=ON \
/ParaView-v5.4.1 \
&& make -j8 \
&& make install \
&& ldconfig \
&& cd / \
&& rm -r /mesa-17.0.0 /ParaView-v5.4.1 \
&& apt-get purge -y --auto-remove --purge \
autoconf \
bison \
cmake \
curl \
flex \
g++ \
pkg-config \
python2.7-dev \
python-mako \
&& apt install -y libpython2.7 \
&& rm -rf /var/lib/apt/lists/*

USER mark
WORKDIR $HOME