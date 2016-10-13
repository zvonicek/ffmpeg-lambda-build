#!/bin/bash

set -e

sudo yum groupinstall -y 'development tools'
sudo yum install -y mercurial gperf libxml2-devel libxslt-devel docbook2X
sudo pip install lxml

BUILD=~/build
PREFIX=$BUILD/prefix

export PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig
export MAKEFLAGS='-j4'

rm -rf $BUILD
mkdir -p $BUILD
cd $BUILD
PATH=$BUILD/prefix/bin:$PATH

git clone --depth=1 git://cmake.org/cmake.git
cd cmake
./configure --prefix=$PREFIX
make
make install
cd -

git clone --depth=1 git://github.com/yasm/yasm.git
cd yasm
./autogen.sh --prefix=$PREFIX
make
make install
cd -

git clone --depth=1 git://github.com/madler/zlib
cd zlib
./configure --prefix=$PREFIX
make
make install
cd -

curl http://www.bzip.org/1.0.6/bzip2-1.0.6.tar.gz | tar xz
cd bzip2-*
sed -i'' "s|PREFIX=.*|PREFIX=$PREFIX|" Makefile
make -f Makefile-libbz2_so
make install
cp libbz2.so.* $PREFIX/lib
cd -

git clone --depth=1 git://git.videolan.org/x264.git
cd x264
./configure --prefix=$PREFIX --enable-shared
make
make install
cd -

git clone --depth=1 https://chromium.googlesource.com/webm/libvpx
cd libvpx
./configure --prefix=$PREFIX --enable-shared
make
make install
cd -

svn checkout http://svn.xvid.org/trunk/xvidcore --username anonymous --password '' --non-interactive
cd xvidcore/build/generic
./bootstrap.sh
./configure --prefix=$PREFIX
make
make install
cd -

hg clone https://bitbucket.org/multicoreware/x265
cd x265/build
cmake -DCMAKE_INSTALL_PREFIX:PATH=$PREFIX ../source
make
make install
cd -

git clone --depth=1 git://git.sv.nongnu.org/freetype/freetype2.git
cd freetype2
./autogen.sh
LDFLAGS="-L$PREFIX/lib" CPPFLAGS="-I$PREFIX/include" ./configure --prefix=$PREFIX
make
make install
cd -

git clone --depth=1 git://anongit.freedesktop.org/fribidi/fribidi
cd fribidi
sed -i'' 's|SUBDIRS = .*|SUBDIRS = gen.tab charset lib bin test|' Makefile.am
./bootstrap
./configure --prefix=$PREFIX
MAKEFLAGS='' make
make install
cd -

git clone git://git.code.sf.net/p/expat/code_git expat
cd expat/expat
ln -s `which db2x_docbook2man` $PREFIX/bin/docbook2x-man
./buildconf.sh
./configure --prefix=$PREFIX
make
make install
rm $PREFIX/bin/docbook2x-man
cd -

git clone --depth=1 git://anongit.freedesktop.org/fontconfig
cd fontconfig
./autogen.sh --prefix=$PREFIX
make
make install
cd -

git clone --depth=1 git://github.com/libass/libass
cd libass
./autogen.sh
./configure --prefix=$PREFIX
make
make install
cd -

git clone --depth=1 git://github.com/cacalabs/libcaca
cd libcaca
./bootstrap
./configure --prefix=$PREFIX
make
make install
cd -

git clone https://git.xiph.org/ogg.git
cd ogg
./autogen.sh
./configure --prefix=$PREFIX --exec-prefix=$PREFIX
make
make install
cd -

git clone git://git.code.sf.net/p/soxr/code soxr
mkdir -p soxr/build
cd soxr/build
cmake -DCMAKE_INSTALL_PREFIX:PATH=$PREFIX ..
make
make install
cd -

git clone --depth=1 git://github.com/georgmartius/vid.stab
mkdir -p vid.stab/build
cd vid.stab/build
cmake -DCMAKE_INSTALL_PREFIX:PATH=$PREFIX ..
make
make install
cd -

cvs -d:pserver:cvsanon:@cvs.maptools.org:/cvs/maptools/cvsroot login
cvs -z3 -d:pserver:cvsanon:@cvs.maptools.org:/cvs/maptools/cvsroot co -P libtiff
cd libtiff
./configure --prefix=$PREFIX
make
make install
cd -

git clone --depth=1 git://git.code.sf.net/p/libpng/code libpng
cd libpng
./autogen.sh
CPPFLAGS="-I$PREFIX/include" LDFLAGS="-L$PREFIX/lib" ./configure --prefix=$PREFIX
make
make install
cd -

git clone --depth=1 -b openjpeg-1.5 git://github.com/uclouvain/openjpeg
mkdir -p openjpeg/build
cd openjpeg/build
cmake -DCMAKE_INSTALL_PREFIX:PATH=$PREFIX ..
make
make install
cd -

git clone --depth=1 https://chromium.googlesource.com/webm/libwebp
cd libwebp
./autogen.sh
./configure --prefix=$PREFIX
make
make install
cd -

git clone --depth=1 -b OpenSSL_1_0_2-stable git://github.com/openssl/openssl
cd openssl
./config  --prefix=$PREFIX --openssldir=$PREFIX shared zlib-dynamic
CPPFLAGS="-I$PREFIX/include" make
make install
cd -

git clone git://git.ffmpeg.org/rtmpdump
cd rtmpdump
sed -i'' "s|prefix=.*|prefix=$PREFIX|" Makefile
sed -i'' "s|prefix=.*|prefix=$PREFIX|" librtmp/Makefile
CPPFLAGS="-I$PREFIX/include" XLDFLAGS="-L$PREFIX/lib" make
make install
cd -

git clone --depth=1 git://github.com/sekrit-twc/zimg
cd zimg
./autogen.sh
./configure --prefix=$PREFIX
make
make install
cd -

cvs -d:pserver:anonymous:@lame.cvs.sourceforge.net:/cvsroot/lame login
cvs -z3 -d:pserver:anonymous:@lame.cvs.sourceforge.net:/cvsroot/lame co -P lame
cd lame
./configure --prefix=$PREFIX
make
make install
cd -

git clone --depth=1 git://github.com/jiixyj/libebur128
mkdir -p libebur128/build
cd libebur128/build
cmake -DCMAKE_INSTALL_PREFIX:PATH=$PREFIX ..
make
make install
cd -

git clone --depth=1 git://git.code.sf.net/p/opencore-amr/vo-amrwbenc
cd vo-amrwbenc
libtoolize --force
aclocal
automake --force-missing --add-missing
autoconf
./configure --prefix=$PREFIX
make
make install
cd -

git clone --depth=1 git://git.code.sf.net/p/opencore-amr/code opencore-amr
cd opencore-amr
libtoolize --force
aclocal
automake --force-missing --add-missing
autoconf
./configure --prefix=$PREFIX
make
make install
cd -

git clone --depth=1 git://github.com/dyne/frei0r
cd frei0r
./autogen.sh
./configure --prefix=$PREFIX
make
make install
cd -

git clone https://git.xiph.org/vorbis.git
cd vorbis
./autogen.sh
./configure --prefix=$PREFIX
make
make install
cd -

git clone https://git.xiph.org/theora.git
cd theora
./autogen.sh
LDFLAGS="-L$PREFIX/lib" CPPFLAGS="-I$PREFIX/include" ./configure --prefix=$PREFIX
make
make install
cd -

git clone https://git.xiph.org/speex.git
cd speex
./autogen.sh
./configure --prefix=$PREFIX
make
make install
cd -

git clone https://git.xiph.org/opus.git
cd opus
./autogen.sh
./configure --prefix=$PREFIX
make
make install
cd -

git clone --depth=1 git://git.videolan.org/git/ffmpeg.git
cd ffmpeg
./configure \
	--prefix=$PREFIX --enable-gpl --enable-version3 --enable-nonfree \
	--enable-shared --extra-cflags="-I$PREFIX/include" \
	--extra-ldflags="-L$PREFIX/lib -L$PREFIX/lib64" \
	--enable-libebur128 --enable-libmp3lame --enable-frei0r \
	--enable-libopencore-amrwb --enable-libopencore-amrnb \
	--enable-libsoxr --enable-libvpx --enable-libwebp \
	--enable-libx264 --enable-libx265 --enable-libzimg \
	--enable-libxvid --enable-openssl  --enable-librtmp \
	--enable-libvorbis --enable-libopus --enable-libtheora \
	--enable-libspeex --enable-libvidstab --enable-libvo-amrwbenc \
    --enable-libopenjpeg --enable-libfribidi --enable-libfreetype \
    --enable-libfontconfig --enable-libass --enable-libcaca
make
make install
cd -

svn checkout svn://svn.mplayerhq.hu/mplayer/trunk mplayer
cd mplayer
cp -r $PREFIX/include/libavutil/ .
LD_LIBRARY_PATH=$PREFIX/lib ./configure --prefix=$PREFIX --disable-ffmpeg_a --extra-cflags="-I$PREFIX/include" --extra-ldflags="-L$PREFIX/lib"
LD_LIBRARY_PATH=$PREFIX/lib make
make install
cd -

git clone --depth=1 git://github.com/NixOS/patchelf
cd patchelf
./bootstrap.sh
./configure --prefix=$PREFIX
make
make install
cd -