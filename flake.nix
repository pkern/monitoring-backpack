{
  description = "Basic monitoring rules.";

  outputs = { self, nixpkgs }: {

    packages.x86_64-linux.monitoring-backpack = let pkgs = import nixpkgs { system = "x86_64-linux"; }; in pkgs.stdenv.mkDerivation rec {
      name = "monitoring-backpack";
      src = pkgs.fetchFromGitHub {
        owner = "pkern";
        repo = "monitoring-backpack";
        rev = "7699a1ca61a4756043fc8851d4487a3ec92acff7";
        sha256 = "sha256-GMw1ixosr1rRF5WzFVvNfpYr4T0gdMw0k41vBkJYgnk=";
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

    packages.x86_64-linux.default = self.packages.x86_64-linux.monitoring-backpack;

  };
}
