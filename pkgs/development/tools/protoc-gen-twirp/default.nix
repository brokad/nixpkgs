{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "protoc-gen-twirp";
  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "twitchtv";
    repo = "twirp";
    rev = "v${version}";
    sha256 = "sha256-lwozRwH96nh4Zlf6ggOF+FuUEfxkN38wxygg5HXw/M0=";
  };

  goPackagePath = "github.com/twitchtv/twirp";

  subPackages = [
    "protoc-gen-twirp"
    "protoc-gen-twirp_python"
  ];

  doCheck = true;

  meta = with lib; {
    description = "A simple RPC framework with protobuf service definitions";
    homepage = "https://github.com/twitchtv/twirp";
    license = licenses.asl20;
    maintainers = with maintainers; [ jojosch ];
  };
}
