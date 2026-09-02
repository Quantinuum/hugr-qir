{ pkgs, lib, config, inputs, ... }: let
  cfg = config.hugr-qir;
  llvmMajorVersion = lib.versions.major cfg.llvmVersion;
  llvmVersionNoDot = builtins.replaceStrings [ "." ] [ "" ] cfg.llvmVersion;
  libllvm = pkgs."llvmPackages_${llvmMajorVersion}".libllvm;
in {
  # set these options in devenv.local.nix
  options.hugr-qir = {
    llvmVersion = lib.mkOption {
      type = lib.types.str;
      default = "21.1";
    };
    patch-ruff = lib.mkEnableOption "patch-ruff";
  };
  config = lib.mkMerge [{
    packages = [
      pkgs.pre-commit
      # These are required for hugr-llvm to be able to link to llvm.
      pkgs.libcxx
      pkgs.libffi
      pkgs.libxml2
      pkgs.zlib
      pkgs.ncurses
    ];

    enterShell = ''
      export LD_LIBRARY_PATH="${lib.makeLibraryPath [ pkgs.zlib ]}''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
    '';

    # https://devenv.sh/tasks/
    env = {
      "LLVM_SYS_${llvmVersionNoDot}_PREFIX" = "${libllvm.dev}";
      # `uv run ...` builds the mixed Python/Rust package in an isolated
      # environment via maturin. On macOS, wheel repair needs explicit fallback
      # dylib search paths to locate Nix-provided runtime libraries such as zlib.
      DYLD_FALLBACK_LIBRARY_PATH = "${lib.makeLibraryPath [
        pkgs.libcxx
        pkgs.libffi
        pkgs.libxml2
        pkgs.zlib
        pkgs.ncurses
      ]}:/usr/lib";
    };

    languages = {
      rust = {
        enable = true;
        channel = "stable";
        components = [
            "rustc"
            "cargo"
            "clippy"
            "rustfmt"
            "rust-analyzer"
            "rust-src"
          ];
      };

      python = {
        enable = true;
        venv.enable = true;
        uv = {
          enable = true;
          # sync.enable = true;
        };
      };
    };
  } (lib.mkIf cfg.patch-ruff {
    tasks = {
      # Patch ruff to make it runnable
      "venv:patchelf" = {
        exec = "${lib.getExe pkgs.patchelf} --set-interpreter ${pkgs.stdenv.cc.bintools.dynamicLinker} $VIRTUAL_ENV/bin/ruff";
        after = [ "devenv:python:uv" ]; # Runs after this
        before = [ "devenv:enterShell" ]; # Runs before this
      };
    };
  })];
}
