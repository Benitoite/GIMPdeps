#!/bin/sh

# macbuildGIMP.sh
# Builds RawTherapee on macOS 10.15.4 / Xcode 11.4.1
# Depends on libraries built by https://github.com/Benitoite/RTdeps/blob/master/macbuildRT.sh
#
# Created by Richard Barber on 05/09/20.
#
# GIT DEPENDENCIES

cd ~
git clone https://gitlab.gnome.org/GNOME/gimp.git
git clone https://github.com/LuaDist/libmng.git
git clone https://gitlab.freedesktop.org/xorg/lib/libxpm.git
git clone https://github.com/caolanm/libwmf.git
git clone git://git.webkit.org/WebKit.git
git clone https://gitlab.gnome.org/GNOME/babl.git
git clone https://gitlab.gnome.org/GNOME/gegl.git
git clone https://gitlab.gnome.org/GNOME/gtk.git gtk2
git clone https://gitlab.gnome.org/GNOME/glibmm.git gtkmm2
git clone https://gitlab.gnome.org/GNOME/json-glib.git
git clone https://gitlab.gnome.org/World/intltool.git
git clone https://gitlab.gnome.org/GNOME/glib-networking.git
git clone https://gitlab.com/gnutls/gnutls.git
git clone https://git.savannah.gnu.org/git/autogen.git
git clone https://github.com/ivmai/bdwgc.git

curl http://ftp.gnu.org/gnu/autogen/rel5.18.16/autogen-5.18.16.tar.xz -o autogen.xz && tar xf autogen.xz && rm autogen.xz && mv autogen-5* autogen
curl https://gmplib.org/download/gmp/gmp-6.2.0.tar.xz -o gmp.xz && tar xf gmp.xz && rm gmp.xz && mv gmp-6* gmp
curl https://ftp.gnu.org/gnu/libunistring/libunistring-0.9.10.tar.xz -o libunistring.xz && tar xf libunistring.xz && rm libunistring.xz && mv libunistring-0* libunistring

# Prepare dependencies

sudo install_name_tool -change libfreetype.6.dylib /opt/local/lib/libfreetype.6.dylib  /opt/local/bin/rsvg-convert

# Build tools and libraries

cd ~/gtk2 && make clean && make distclean && git checkout gtk-2-24 && git pull --rebase && curl https://bug757187.bugzilla-attachments.gnome.org/attachment.cgi\?id=331173 | git apply && curl https://raw.githubusercontent.com/macports/macports-ports/master/gnome/gtk2/files/patch-gtk-builder-convert.diff | git apply && cd gtk && curl https://raw.githubusercontent.com/macports/macports-ports/master/gnome/gtk2/files/patch-aliases.diff | git apply && cd ../gdk && curl https://raw.githubusercontent.com/macports/macports-ports/master/gnome/gtk2/files/patch-aliases.diff | git apply && autoconf && CC=clang CXX=clang++ CXXFLAGS=" -DX_LOCALE" CFLAGS=" -fstrict-aliasing" sh autogen.sh --prefix=/opt/local && autoreconf -i && automake -a && CC=clang CXX=clang++ CFLAGS="-mtune=generic -v -fstrict-aliasing -arch x86_64 -I/opt/local/include -O3 -mmacosx-version-min=10.9 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.9.sdk" CXXFLAGS=" -mtune=generic -v -fstrict-aliasing -arch x86_64 -I/opt/local/include -O3 -mmacosx-version-min=10.9 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.9.sdk -DX_LOCALE" LDFLAGS="/opt/local/lib/libintl.8.dylib /opt/local/lib/libgettextlib-0.20.1.dylib /opt/local/lib/libiconv.2.dylib -bind_at_load -mtune=generic -v -L/opt/local/lib -fstrict-aliasing -arch x86_64 -O3 -mmacosx-version-min=10.9 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.9.sdk" ./configure --enable-introspection=no --enable-quartz-relocation --disable-visibility --with-gdktarget=quartz --enable-xkb=no --without-x --prefix=/opt/local --with-sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.9.sdk --enable-man=no   || BASE_DEPENDENCIES_CFLAGS=-I/opt/local/include  CC=clang CXX=clang++ CFLAGS="-mtune=generic -v -fstrict-aliasing -arch x86_64 -I/opt/local/include -O3 -mmacosx-version-min=10.9 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.9.sdk" CXXFLAGS=" -mtune=generic -v -fstrict-aliasing -arch x86_64 -I/opt/local/include -O3 -mmacosx-version-min=10.9 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.9.sdk -DX_LOCALE" LDFLAGS=" -Wl,-rpath /opt/local/lib /opt/local/lib/libexpat.1.dylib /opt/local/lib/libintl.8.dylib /opt/local/lib/libgettextlib-0.20.1.dylib /opt/local/lib/libiconv.2.dylib -bind_at_load -mtune=generic -v -L/opt/local/lib -fstrict-aliasing -arch x86_64 -O3 -mmacosx-version-min=10.9 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.9.sdk" ./configure --disable-dependency-tracking --disable-silent-rules --disable-glibtest --enable-quartz-relocation --disable-visibility --with-gdktarget=quartz --enable-xkb=no --without-x --prefix=/opt/local --with-sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.9.sdk --enable-man=no --enable-introspection=no  && CC=clang CXX=clang++ CFLAGS=" -std=c11 -mtune=generic -v -fstrict-aliasing -arch x86_64 -I/opt/local/include -O3 -mmacosx-version-min=10.9 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.9.sdk" CXXFLAGS=" -mtune=generic -v -fstrict-aliasing -arch x86_64 -I/opt/local/include -O3 -mmacosx-version-min=10.9 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.9.sdk -DX_LOCALE" LDFLAGS="/opt/local/lib/libintl.8.dylib /opt/local/lib/libgettextlib-0.20.1.dylib /opt/local/lib/libiconv.2.dylib -bind_at_load -mtune=generic -v  -Wl,-rpath /opt/local/lib -L/opt/local/lib -fstrict-aliasing -arch x86_64 -O3 -mmacosx-version-min=10.9 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.9.sdk" make -j8 && install_name_tool -change libfreetype.6.dylib /opt/local/lib/libfreetype.6.dylib gtk/.libs/gtk-query-immodules-2.0 && install_name_tool -change libfreetype.6.dylib /opt/local/lib/libfreetype.6.dylib gdk/.libs/libgdk-quartz-2.0.0.dylib && for inputmodules in modules/input/.libs/*.so; do install_name_tool  -change libfreetype.6.dylib /opt/local/lib/libfreetype.6.dylib "${inputmodules}"; install_name_tool -add_rpath /opt/local/lib "${inputmodules}"; done && sudo make install

cd ~/gtk-mac-integration2 && make clean && make distclean && git checkout gtk-mac-integration-2.1.3 ||  autoconf && sh autogen.sh --prefix=/opt/local --with-sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.9.sdk --libdir=/opt/local/lib --disable-glibtest --enable-introspection=no --enable-python=no --with-gtk3 --with-gtk2 --with-libiconv-prefix=/opt/local/lib --with-libintl-prefix=/opt/local/lib && autoreconf -i && automake -a && CFLAGS="-arch x86_64 -mmacosx-version-min=10.9 -I/opt/local/include" LDFLAGS="-arch x86_64 -mmacosx-version-min=10.9 -L/opt/local/lib -Wl,-rpath -Wl,/opt/local/lib" PKG_CONFIG_PATH=/opt/local/lib/pkgconfig CPPFLAGS="-arch x86_64 -mmacosx-version-min=10.9 -I/opt/local/include" PYTHON=python3 CC=clang CXX=clang++ LT_SYS_LIBRARY_PATH=/opt/local/lib ./configure --prefix=/opt/local --with-sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.9.sdk --libdir=/opt/local/lib --disable-glibtest --enable-introspection=no --enable-python=no --with-gtk3 --with-gtk2 --with-libiconv-prefix=/opt/local/lib --with-libintl-prefix=/opt/local/lib && sed -i -e 's/GETTEXT_MACRO_VERSION\ =\ 0.19/GETTEXT_MACRO_VERSION\ =\ 0.20/g' po/Makefile.in.in && CC=clang CXX=clang++ CFLAGS="-arch x86_64 -mmacosx-version-min=10.9 -I/opt/local/include" LDFLAGS="-arch x86_64 -mmacosx-version-min=10.9 -L/opt/local/lib -Wl,-rpath -Wl,/opt/local/lib" CPPFLAGS="-arch x86_64 -mmacosx-version-min=10.9 -I/opt/local/include" PYTHON=python3 PKG_CONFIG_PATH=/opt/local/lib/pkgconfig LT_SYS_LIBRARY_PATH=/opt/local/lib make -j8 && sudo make install

cd ~/gegl && curl https://raw.githubusercontent.com/OpenCL/GEGL-OpenCL/master/opencl/colors.cl.h -o opencl/colors.cl.h && curl https://raw.githubusercontent.com/OpenCL/GEGL-OpenCL/master/opencl/colors-8bit-lut.cl.h -o opencl/colors-8bit-lut.cl.h && curl https://raw.githubusercontent.com/OpenCL/GEGL-OpenCL/master/opencl/random.cl.h -o opencl/random.cl.h && curl https://raw.githubusercontent.com/Benitoite/GIMPdeps/master/gegl.patch | git apply && LD=ld CC=/usr/bin/clang CXX=/usr/bin/clang++ LIBRARY_PATH=/opt/local/lib meson setup  --cross-file=~/maccross  --prefix=/opt/local --buildtype=release  -Dintrospection=false --layout=mirror --default-library=both  _build .  && touch subprojects/poly2tri-c/what.c && LD=ld CC=/usr/bin/clang CXX=/usr/bin/clang++  ninja -j1 -v -C _build && sudo ninja -C _build -v install

cd ~/intltool && CC=clang CXX=clang++ CFLAGS="-arch x86_64 -mmacosx-version-min=10.9 -I/opt/local/include" LDFLAGS="-arch x86_64 -mmacosx-version-min=10.9 -L/opt/local/lib -Wl,-rpath -Wl,/opt/local/lib" CPPFLAGS="-arch x86_64 -mmacosx-version-min=10.9 -I/opt/local/include" PYTHON=python3 PKG_CONFIG_PATH=/opt/local/lib/pkgconfig sh autogen.sh --prefix=/opt/local --with-sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.9.sdk  --with-libintl-prefix=/opt/local/lib &&  autoreconf -vfi && CC=clang CXX=clang++ CFLAGS="-arch x86_64 -mmacosx-version-min=10.9 -I/opt/local/include" LDFLAGS="-arch x86_64 -mmacosx-version-min=10.9 -L/opt/local/lib -Wl,-rpath -Wl,/opt/local/lib" CPPFLAGS="-arch x86_64 -mmacosx-version-min=10.9 -I/opt/local/include" PYTHON=python3 PKG_CONFIG_PATH=/opt/local/lib/pkgconfig ./configure  --prefix=/opt/local --with-sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.9.sdk  --with-libintl-prefix=/opt/local/lib &&  CC=clang CXX=clang++ CFLAGS="-arch x86_64 -mmacosx-version-min=10.9 -I/opt/local/include" LDFLAGS="-arch x86_64 -mmacosx-version-min=10.9 -L/opt/local/lib -Wl,-rpath -Wl,/opt/local/lib" CPPFLAGS="-arch x86_64 -mmacosx-version-min=10.9 -I/opt/local/include" PYTHON=python3 PKG_CONFIG_PATH=/opt/local/lib/pkgconfig make -j8 && sudo make install

cd ~/gmp && autoreconf -vfi && CC=clang CXX=clang++ CFLAGS="-arch x86_64 -mmacosx-version-min=10.9 -I/opt/local/include" LDFLAGS="-arch x86_64 -mmacosx-version-min=10.9 -L/opt/local/lib -Wl,-rpath -Wl,/opt/local/lib" CPPFLAGS="-arch x86_64 -mmacosx-version-min=10.9 -I/opt/local/include" PYTHON=python3 PKG_CONFIG_PATH=/opt/local/lib/pkgconfig ./configure  --prefix=/opt/local --with-sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.9.sdk  --with-libintl-prefix=/opt/local/lib && make -j8 && sudo make install

cd ~/libunistring && autoreconf -vfi && CC=clang CXX=clang++ CFLAGS="-arch x86_64 -mmacosx-version-min=10.9 -I/opt/local/include" LDFLAGS="-arch x86_64 -mmacosx-version-min=10.9 -L/opt/local/lib -Wl,-rpath -Wl,/opt/local/lib" CPPFLAGS="-arch x86_64 -mmacosx-version-min=10.9 -I/opt/local/include" PYTHON=python3 PKG_CONFIG_PATH=/opt/local/lib/pkgconfig ./configure  --prefix=/opt/local --with-sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.9.sdk  --with-libintl-prefix=/opt/local/lib && make -j8 && sudo make install

cd ~/bdwgc && autoreconf -vfi && CC=clang CXX=clang++ CFLAGS="-arch x86_64 -mmacosx-version-min=10.9 -I/opt/local/include" LDFLAGS="-arch x86_64 -mmacosx-version-min=10.9 -L/opt/local/lib -Wl,-rpath -Wl,/opt/local/lib" CPPFLAGS="-arch x86_64 -mmacosx-version-min=10.9 -I/opt/local/include" PYTHON=python3 PKG_CONFIG_PATH=/opt/local/lib/pkgconfig ./configure  --prefix=/opt/local --with-sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.9.sdk  --with-libintl-prefix=/opt/local/lib && make -j8 && sudo make install

cd ~/guile && autoreconf -vfi && CC=clang CXX=clang++ CFLAGS="-arch x86_64 -mmacosx-version-min=10.9 -I/opt/local/include" LDFLAGS="-arch x86_64 -mmacosx-version-min=10.9 -L/opt/local/lib -Wl,-rpath -Wl,/opt/local/lib" CPPFLAGS="-arch x86_64 -mmacosx-version-min=10.9 -I/opt/local/include" PYTHON=python3 PKG_CONFIG_PATH=/opt/local/lib/pkgconfig ./configure  --prefix=/opt/local --with-sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.9.sdk  --with-libintl-prefix=/opt/local/lib && make -j8 && sudo make install
#### NOTE: guile takes an hour to generate.


 1237  ls
 1238  rm autogen.xz
 1239  cd autogen-5*
 1240  ls
 1241  autoconf
 1242  autoreconf -vfi
 1243  ./configure 


cd ~/gnutls && 

cd ~/glib-networking && 


# GIMP

 CC=clang CXX=clang++ CFLAGS="-arch x86_64 -mmacosx-version-min=10.9 -I/opt/local/include" LDFLAGS="-arch x86_64 -mmacosx-version-min=10.9 -L/opt/local/lib -Wl,-rpath -Wl,/opt/local/lib" CPPFLAGS="-arch x86_64 -mmacosx-version-min=10.9 -I/opt/local/include" PYTHON=python3 PKG_CONFIG_PATH=/opt/local/lib/pkgconfig sh autogen.sh --prefix=/opt/local --with-sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.9.sdk  --with-libintl-prefix=/opt/local/lib && autoreconf -vfi && CC=clang CXX=clang++ CFLAGS="-arch x86_64 -mmacosx-version-min=10.9 -I/opt/local/include" LDFLAGS="-arch x86_64 -mmacosx-version-min=10.9 -L/opt/local/lib -Wl,-rpath -Wl,/opt/local/lib" CPPFLAGS="-arch x86_64 -mmacosx-version-min=10.9 -I/opt/local/include" PYTHON=python3 PKG_CONFIG_PATH=/opt/local/lib/pkgconfig ./configure  --prefix=/opt/local --with-sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.9.sdk  --with-libintl-prefix=/opt/local/lib && 

# END OF SCRIPT
