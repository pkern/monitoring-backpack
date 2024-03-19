{
  description = "Basic monitoring rules.";

  outputs = { self, nixpkgs }: {

    packages.x86_64-linux.monitoring-backpack = let pkgs = import nixpkgs { system = "x86_64-linux"; }; in pkgs.stdenv.mkDerivation rec {
      name = "monitoring-backpack";
      src = pkgs.fetchFromGitHub {
        owner = "pkern";
        repo = "monitoring-backpack";
        rev = "539e1a92737274513f6ee7bb5648ba6d85f9220e";
        sha256 = "1vs50r1gcif9x9nmn31qdqzz2z9d7psvrfsh4lqzxnqxnf5f4bwq";
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
