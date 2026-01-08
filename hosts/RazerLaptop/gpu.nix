# Configures the Intel and Nvidia graphics hardware
{ config, lib, pkgs, ... }:
let
  # Define parameters for disabling the Nvidia dGPU on the base configuration
  nvidiaDisableParams = [
    "nvidia.NVreg_EnableGpuFirmware=0"
    "modprobe.blacklist=nvidia,nvidia-modeset,nvidia-drm,nvidia-uvm,nouveau"
  ];
in
{
  # Passes parameters to i915 kernel module to enable the Graphics microController (GuC) and HEVC microctronoller (HuC) firmware for media tasks like video encoding/decoding
  # If not in a specialisation then add the Nvidia disabling kernel parameters
  boot.kernelParams = [
    "i915.enable_guc=3"
  ] ++ lib.optionals (config.specialisation == {}) nvidiaDisableParams;
  
  # Loads the i915 kernel module during initrd (early) for prompt loading
  boot.initrd.kernelModules = [ "i915" ];

  # Disable the Nvidia dGPU on the base configuration
  boot.blacklistedKernelModules = lib.mkIf (config.specialisation == {}) [
    "nvidia"
    "nvidia-modeset"
    "nvidia-drm"
    "nvidia-uvm"
    "nouveau"
  ];

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

  environment.sessionVariables = lib.mkOverride 1001 {
    LIBVA_DRIVER_NAME = "iHD";    # Tells libva (vaapi) to use the Intel Media Driver
  };

  hardware.enableRedistributableFirmware = true;     # Required for proprietary Intel firmware

  specialisation = {
    nvidia-offload = {
      inheritParentConfig = true;

      configuration = {
        services.xserver.videoDrivers = lib.mkForce [ "modesetting" "nvidia" ];

        boot.blacklistedKernelModules = lib.mkForce [ "nouveau" ];

        hardware.nvidia = {
          modesetting.enable = true;
          open = false;

          prime = {
            offload = {
              enable = true;
              enableOffloadCmd = true;
            };

            intelBusId = "PCI:0:2:0";
            nvidiaBusId = "PCI:89:0:0";
          };

          powerManagement = {
            enable = true;
            finegrained = true;    # Doesn't work with this GPU but set anyway
          };
        };

        hardware.graphics = {
          extraPackages = with pkgs; [
            nvidia-vaapi-driver
          ];
        };

        environment.sessionVariables = {
          LIBVA_DRIVER_NAME = "nvidia";
          GBM_BACKEND = "nvidia-drm";
          __GLX_VENDOR_LIBRARY_NAME = "nvidia";
          NVD_BACKEND = "direct";
        };
      };
    };
   };
}
