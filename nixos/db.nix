{ config, pkgs, ... }:

{
  services.postgresql = {
      enable = true;
      package = pkgs.postgresql_11;
      enableTCPIP = true;
      authentication = pkgs.lib.mkOverride 10 ''
        local all all trust
        host all all 127.0.0.1/32 trust
        host all all ::1/128 trust
      '';
      initialScript = pkgs.writeText "backend-initScript" ''
        CREATE ROLE adam WITH LOGIN PASSWORD 'tiger' CREATEDB;
        CREATE DATABASE postgres;
        GRANT ALL PRIVILEGES ON DATABASE postgres TO adam;
      '';
    };
  }
