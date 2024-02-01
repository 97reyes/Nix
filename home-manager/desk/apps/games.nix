{pkgs, ...}: {
  home.packages = with pkgs; [
    (wine.override {wineBuild = "wine64";})
    pkgs.bottles-unwrapped
    winetricks
    # lutris
    appimage-run
    # yuzu-early-access
    # rpcs3
    protontricks
    # heroic
    # (
    # let base = pkgs.appimageTools.defaultFhsEnvArgs;
    # in pkgs.buildFHSUserEnv (base
    #  {
    #    name = "fhs";
    #    targetPkgs = pkgs: (base.targetPkgs pkgs) ++ [ pkgs.pkg-config ];
    #    profile = "export FHS=1";
    #    runScript = "bash";
    #    extraOutputsToInstall = [ "dev" ];
    #  })
    # )
  ];

  # programs.steam.enable = true;
}
