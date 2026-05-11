{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) optionals mkIf;
in
{
  extraPlugins = [ ];

  plugins = {
    copilot-lua = {
      enable = true;

      lazyLoad.settings = {
        event = [ "InsertEnter" ];
      };

      settings = {
        suggestion.enabled = false;
        panel.enabled = false;
        nes = mkIf (!config.plugins.sidekick.enable) {
          enabled = true;
          keymap = {
            accept_and_goto = "<TAB>";
            accept = false;
            dismiss = "<Esc>";
          };
        };

        filetypes = {
          yaml = false;
          markdown = false;
          json = false;
          help = false;
          gitcommit = false;
          gitrebase = false;
        };
      };
    };
  };

  autoCmd = mkIf (config.plugins.copilot-lua.enable && config.plugins.blink-cmp.enable) [
    {
      event = "User";
      pattern = "BlinkCmpMenuOpen";
      callback.__raw = ''
        function()
          vim.b.copilot_suggestion_hidden = true
        end
      '';
    }
    {
      event = "User";
      pattern = "BlinkCmpMenuClose";
      callback.__raw = ''
        function()
          vim.b.copilot_suggestion_hidden = false
        end
      '';
    }
  ];
}
