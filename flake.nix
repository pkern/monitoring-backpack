{
  description = "Basic monitoring rules.";

  outputs = { self, nixpkgs }: {

    packages.x86_64-linux.monitoring-backpack = let pkgs = import nixpkgs { system = "x86_64-linux"; }; in pkgs.stdenv.mkDerivation rec {
      name = "monitoring-backpack";
      src = pkgs.fetchFromGitHub {
        owner = "pkern";
        repo = "monitoring-backpack";
        rev = "9cafab6b76924d3e6a394a7f80763361e033bf1b";
        sha256 = "sha256-AerYqtCXqFNhD42BSi4FjVotfoKmUMKKIwy9TMX66cQ=";
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
