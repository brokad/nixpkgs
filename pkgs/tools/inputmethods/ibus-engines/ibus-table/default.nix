{ lib, stdenv, fetchFromGitHub
, autoreconfHook, docbook2x, pkg-config
, gtk3, dconf, gobject-introspection
, ibus, python3, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "ibus-table";
  version = "1.9.25";

  src = fetchFromGitHub {
    owner  = "kaio";
    repo   = "ibus-table";
    rev    = version;
    sha256 = "0v570qpnb2q79aqr9f0xnska34y7hw34ibiwsf7ybcw69fhi1zkg";
  };

  postPatch = ''
    # Data paths will be set at run-time.
    sed -e "/export IBUS_TABLE_LIB_LOCATION=/ s/^.*$//" \
        -e "/export IBUS_TABLE_LOCATION=/ s/^.*$//" \
        -i "engine/ibus-engine-table.in"
    sed -e "/export IBUS_TABLE_BIN_PATH=/ s/^.*$//" \
        -e "/export IBUS_TABLE_DATA_DIR=/ s/^.*$//" \
        -i "engine/ibus-table-createdb.in"
    sed -e "/export IBUS_PREFIX=/ s/^.*$//" \
        -e "/export IBUS_DATAROOTDIR=/ s/^.$//" \
        -e "/export IBUS_LOCALEDIR=/ s/^.$//" \
        -i "setup/ibus-setup-table.in"
    substituteInPlace engine/tabcreatedb.py --replace '/usr/share/ibus-table' $out/share/ibus-table
  '';

  buildInputs = [
    dconf
    gtk3
    ibus
    (python3.withPackages (pypkgs: with pypkgs; [
      pygobject3
      (toPythonModule ibus)
    ]))
  ];

  nativeBuildInputs = [
    autoreconfHook
    docbook2x
    pkg-config
    gobject-introspection
    wrapGAppsHook
  ];

  postUnpack = ''
    substituteInPlace $sourceRoot/engine/Makefile.am \
      --replace "docbook2man" "docbook2man --sgml"
  '';

  meta = with lib; {
    isIbusEngine = true;
    description  = "An IBus framework for table-based input methods";
    homepage     = "https://github.com/kaio/ibus-table/wiki";
    license      = licenses.lgpl21;
    platforms    = platforms.linux;
    maintainers  = with maintainers; [ mudri ];
  };
}
