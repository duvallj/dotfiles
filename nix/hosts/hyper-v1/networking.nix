# All network configuration stuff for this specific install
{ ... }:
{
  systemd.network.enable = true;
  systemd.network.networks."20-wired" = {
    matchConfig.Name = "eth0";
    networkConfig.Address = "10.0.213.3/24";
    networkConfig.Gateway = "10.0.213.1";
  };
  services.resolved.enable = true;
  networking.nameservers = [
    "8.8.8.8#dns.google"
    "8.8.4.4#dns.google"
  ];
  networking = {
    useDHCP = false;
    useNetworkd = true;
  };
}
