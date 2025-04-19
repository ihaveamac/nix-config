{
  config,
  lib,
  pkgs,
  ...
}:

{
  # this is probably not necessary since programs.steam already does this
  # but i just got this from nixos.wiki, it's probably a good idea just to be certain...
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  boot.kernelParams = [
    # https://www.reddit.com/r/linux_gaming/comments/1d0mqmz/nvidia_555_beta_gsp_firmware/
    # > The issue is that you can only disable it if you don't use the open source kernel driver. But since they said that the open source kernel driver will be the default in 560, I expect them to fix the issue soon.
    # i heard this fixes issues with kde? maybe? but i think this also needs the proprietary driver
    #"NVreg_EnableGpuFirmware=0" "nvidia.NVreg_EnableGpuFirmware=0"
  ];

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # open driver is preferred starting with 560
    open = true;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    # needs vulkan headers as of 560
    nvidiaSettings = false;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "575.51.02";
      sha256_64bit = "sha256-XZ0N8ISmoAC8p28DrGHk/YN1rJsInJ2dZNL8O+Tuaa0=";
      openSha256 = "sha256-NQg+QDm9Gt+5bapbUO96UFsPnz1hG1dtEwT/g/vKHkw=";
      settingsSha256 = lib.fakeHash;
      persistencedSha256 = lib.fakeHash;
    };
  };
}
