{
  mkDerivation,
  extra-cmake-modules, kdoctools,
  pcre, qtbase,
}:

mkDerivation {
  name = "kjs";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [ pcre qtbase ];
}
