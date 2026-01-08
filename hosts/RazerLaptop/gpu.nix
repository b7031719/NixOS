# Configures the Intel and Nvidia graphics hardware
{ config, pkgs, ... }:

{

  # Passes parameters to i915 kernel module to enable the Graphics microController (GuC) and HEVC microctronoller (HuC) firmware for media tasks like video encoding/decoding
  boot.kernelParams = [ "i915.enable_guc=3" ];

  # Loads the i916 kernel module during initrd (early) for prompt loading
  boot.initrd.kernelModules = [ "i915" ];

  services.xserver.videoDrivers = [ "modesetting" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    # Add various packages for vaapi media support etc.
    extraPackages = with pkgs; [
      intel-media-driver
      vpl-gpu-rt
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };

  hardware.intel-gpu-tools.enable = true;    # Adds a security wrapper to the intel-gpu-tools package to allow tools like intel_gpu_top to be used without root privileges

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";    # Tells libva (vaapi) to use the Intel Media Driver
  };

  hardware.enableRedistributableFirmware = true;     # Required for proprietary Intel firmware
}
