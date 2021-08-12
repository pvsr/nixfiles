{ config, pkgs, lib, ... }:

{
  imports = [
  ];

  home.packages = with pkgs; [
  ];

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;
    vimAlias = true;
    vimdiffAlias = true;

    withPython3 = true;

    extraConfig = lib.concatStringsSep "\n" [
      "set shell=${pkgs.fish}/bin/fish"
      (builtins.readFile ./init.vim)
    ];
    plugins = with pkgs.vimPlugins; [
      {
        plugin = neomake;
        config = ''
          let g:neomake_python_enabled_makers = ['python', 'pylint', 'mypy']

          let g:neomake_cabal_args = ['new-build']
          autocmd SourcePost neomake.vim call neomake#configure#automake('rw', 400)
        '';
      }
      {
        plugin = deoplete-nvim;
        config = ''
          "call deoplete#custom#option('auto_complete_delay', 300)
          "let g:deoplete#enable_at_startup = 1
          "let g:deoplete#max_menu_width = 60
          "inoremap <expr><C-h>
          "\ deoplete#smart_close_popup()."\<C-h>"
          "inoremap <expr><BS>
          "\ deoplete#smart_close_popup()."\<C-h>"
        '';
      }
      deoplete-fish
      deoplete-jedi
      {
        plugin = echodoc;
        config = ''
          let g:echodoc#enable_at_startup = 1
          set completeopt-=preview
        '';
      }
      argtextobj-vim
      vim-sneak
      vim-sleuth
      vim-abolish
      vim-exchange
      vim-commentary
      vim-surround
      vim-unimpaired
      vim-fugitive
      vim-eunuch
      vim-dirvish
      {
        plugin = airline;
        config = "set noshowmode";
      }
      vim-toml
      haskell-vim
      vim-fish
      vim-nix
      semshi
      gitgutter
      vim-rooter
      {
        plugin = srcery-vim;
        config = "colorscheme srcery";
      }
      {
        plugin = nvim-colorizer;
        config = "autocmd SourcePost colorizer.vim lua require'colorizer'.setup()";
      }
      popup-nvim
      plenary-nvim
      {
        plugin = telescope-nvim;
        config = ''
          lua << EOF
            require("telescope").setup {
              defaults = {
                layout_strategy = "vertical",
                layout_config = {
                  vertical = {
                    mirror = true,
                  },
                },
              },
            }
          EOF
        '';
      }
      {
        plugin = which-key-nvim;
        config = ''
          lua << EOF
            local wk = require("which-key")
            wk.setup {}
            wk.register({
              f = {
                name = "file",
                f = { "<cmd>Telescope find_files<cr>", "All files" },
                r = { "<cmd>Telescope oldfiles<cr>", "Recent files" },
              },
              b = {
                b = { "<cmd>Telescope buffers<cr>", "Buffers" },
              },
              g = {
                name = "grep",
                g = { "<cmd>Telescope live_grep<cr>", "Search" },
                o = { "<cmd>Telescope live_grep grep_open_files=true<cr>", "Search open files" },
                i = { "<cmd>Telescope grep_string<cr>", "Search under cursor" },
              },
            }, { prefix = "<leader>" })
          EOF
        '';
      }
    ];
  };
}
