{
  description = "Basic monitoring rules.";

  outputs = { self, nixpkgs }: {

    packages.x86_64-linux.monitoring-backpack = let pkgs = import nixpkgs { system = "x86_64-linux"; }; in pkgs.stdenv.mkDerivation rec {
      name = "monitoring-backpack";
      src = pkgs.fetchFromGitHub {
        owner = "pkern";
        repo = "monitoring-backpack";
        rev = "bd5ccbafb6126c2540d9e66380b4b95d1a9df3ef";
        sha256 = "sha256-/sS3ynQI1vc1xV1//rDR7s+3O0NRcIpyFhTbVjJqRiA=";
      };
      buildInputs = [ pkgs.prometheus ];
      doCheck = true;
      checkPhase = ''
        ${pkgs.prometheus.cli}/bin/promtool check rules rules.d/*.yml
        ${pkgs.prometheus.cli}/bin/promtool test rules tests/*.yml
      '';
      installPhase = ''
        mkdir -p $out/rules.d/
        cp rules.d/* $out/rules.d/
      '';
    };

    defaultPackage.x86_64-linux = self.packages.x86_64-linux.monitoring-backpack;

  };
}
