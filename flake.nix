{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    ruby-nix = {
      url = "github:inscapist/ruby-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      ruby-nix,
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ ruby-nix.overlays.ruby ];
      };
      mkRubyEnv = ruby-nix.lib pkgs;
    in
    /*
      rubyEnv = mkRubyEnv {
        name = "chatwoot";
        gemset = ./gemset.nix;
      };
    */
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          ruby
          bundix
          postgresql
          openssl
          solargraph
        ];
      };
    };
}
