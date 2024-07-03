let
  pkgs = import <nixpkgs> {
    config = {
      allowUnfree = true;
      # cudaSupport = true;  # If you need CUDA
    };
  };
in

pkgs.mkShell {
  buildInputs = [
    pkgs.python3
    pkgs.python3Packages.tensorflow
    pkgs.python311Packages.pandas
    pkgs.python311Packages.diagrams
    pkgs.python311Packages.jupyter
    pkgs.python311Packages.nbconvert
  ];

  shellHook = ''code;'';
}
