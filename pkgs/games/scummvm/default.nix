{ lib, stdenv, fetchurl, nasm
, alsaLib, curl, flac, fluidsynth, freetype, libjpeg, libmad, libmpeg2, libogg, libvorbis, libGLU, libGL, SDL2, zlib
, Cocoa, AudioToolbox, Carbon, CoreMIDI, AudioUnit, cctools
}:

stdenv.mkDerivation rec {
  pname = "scummvm";
  version = "2.2.0";

  src = fetchurl {
    url = "http://scummvm.org/frs/scummvm/${version}/${pname}-${version}.tar.xz";
    sha256 = "FGllflk72Ky8+sC4ObCG9kDr8SBjPpPxFsq2UrWyc4c=";
  };

  nativeBuildInputs = [ nasm ];

  buildInputs = lib.optionals stdenv.isLinux [
    alsaLib
  ] ++ lib.optionals stdenv.isDarwin [
    Cocoa AudioToolbox Carbon CoreMIDI AudioUnit
  ] ++ [
    curl freetype flac fluidsynth libjpeg libmad libmpeg2 libogg libvorbis libGLU libGL SDL2 zlib
  ];

  dontDisableStatic = true;

  enableParallelBuilding = true;

  configurePlatforms = [ "host" ];
  configureFlags = [
    "--enable-c++11"
    "--enable-release"
  ];

  # They use 'install -s', that calls the native strip instead of the cross
  postConfigure = ''
    sed -i "s/-c -s/-c -s --strip-program=''${STRIP@Q}/" ports.mk
  '' + lib.optionalString stdenv.isDarwin ''
    substituteInPlace config.mk --replace x86_64-apple-darwin-ranlib ${cctools}/bin/ranlib
  '';

  meta = with lib; {
    description = "Program to run certain classic graphical point-and-click adventure games (such as Monkey Island)";
    homepage = "https://www.scummvm.org/";
    license = licenses.gpl2;
    maintainers = [ maintainers.peterhoeg ];
    platforms = platforms.unix;
  };
}
