{ stdenv, fetchurl, guileSupport ? false, pkg-config ? null , guile ? null }:

assert guileSupport -> ( pkg-config != null && guile != null );

let
  version = "4.3";
in
stdenv.mkDerivation {
  pname = "gnumake";
  inherit version;

  src = fetchurl {
    url = "mirror://gnu/make/make-${version}.tar.gz";
    sha256 = "06cfqzpqsvdnsxbysl5p2fgdgxgl9y4p7scpnrfa8z2zgkjdspz0";
  };

  patches = [
    # Purity: don't look for library dependencies (of the form `-lfoo') in /lib
    # and /usr/lib. It's a stupid feature anyway. Likewise, when searching for
    # included Makefiles, don't look in /usr/include and friends.
    ./impure-dirs.patch
  ];

  nativeBuildInputs = stdenv.lib.optionals guileSupport [ pkg-config ];
  buildInputs = stdenv.lib.optionals guileSupport [ guile ];

  configureFlags = stdenv.lib.optional guileSupport "--with-guile"

    # Make uses this test to decide whether it should keep track of
    # subseconds. Apple made this possible with APFS and macOS 10.13.
    # However, we still support macOS 10.11 and 10.12. Binaries built
    # in Nixpkgs will be unable to use futimens to set mtime less than
    # a second. So, tell Make to ignore nanoseconds in mtime here by
    # overriding the autoconf test for the struct.
    # See https://github.com/NixOS/nixpkgs/issues/51221 for discussion.
    ++ stdenv.lib.optional stdenv.isDarwin "ac_cv_struct_st_mtim_nsec=no";

  outputs = [ "out" "man" "info" ];

  meta = with stdenv.lib; {
    homepage = "https://www.gnu.org/software/make/";
    description = "A tool to control the generation of non-source files from sources";
    license = licenses.gpl3Plus;

    longDescription = ''
      Make is a tool which controls the generation of executables and
      other non-source files of a program from the program's source files.

      Make gets its knowledge of how to build your program from a file
      called the makefile, which lists each of the non-source files and
      how to compute it from other files. When you write a program, you
      should write a makefile for it, so that it is possible to use Make
      to build and install the program.
    '';

    platforms = platforms.all;
    maintainers = [ maintainers.vrthra ];
  };
}
