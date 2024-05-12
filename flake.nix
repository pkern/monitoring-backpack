{
  description = "Basic monitoring rules.";

  outputs = { self, nixpkgs }: {

    packages.x86_64-linux.monitoring-backpack = let pkgs = import nixpkgs { system = "x86_64-linux"; }; in pkgs.stdenv.mkDerivation rec {
      name = "monitoring-backpack";
      src = pkgs.fetchFromGitHub {
        owner = "pkern";
        repo = "monitoring-backpack";
        rev = "f4d96ce533e6b072d2cddd98313600aab4df1120";
        sha256 = "0p33685a7hv1qk868sm8ghjxgqchc6aqdx791mdasy4fh9cbjfdi";
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
