{ lib, php, pkg-config, lua51Packages, fetchFromGitHub }:

php.buildPecl rec {
  pname = "luasandbox";
  version = "4.1.2";

  src = fetchFromGitHub {
    owner = "wikimedia";
    repo = "mediawiki-php-luasandbox";
    rev = "cf0ee3905c268bb492b50fb3ea30b2fe5dd45914";
    hash = "sha256-HWObytoHBvxF9+QC62yJfi6MuHOOXFbSNkhuz5zWPCY=";
  };

  buildInputs = [ lua51Packages.lua ];
  nativeBuildInputs = [ pkg-config ];
}
