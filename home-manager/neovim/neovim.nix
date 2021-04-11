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
        plugin = denite;
        config = ''
          autocmd FileType denite call s:denite_my_settings()
          function! s:denite_my_settings() abort
            nnoremap <silent><buffer><expr> <CR>
            \ denite#do_map('do_action')
            nnoremap <silent><buffer><expr> d
            \ denite#do_map('do_action', 'delete')
            nnoremap <silent><buffer><expr> p
            \ denite#do_map('do_action', 'preview')
            nnoremap <silent><buffer><expr> q
            \ denite#do_map('quit')
            nnoremap <silent><buffer><expr> i
            \ denite#do_map('open_filter_buffer')
            nnoremap <silent><buffer><expr> J
            \ denite#do_map('toggle_select').'j'
            nnoremap <silent><buffer><expr> K
            \ denite#do_map('toggle_select').'k'
          endfunction


          autocmd FileType denite-filter call s:denite_filter_my_settings()
          function! s:denite_filter_my_settings() abort
            imap <silent><buffer> <C-o> <Plug>(denite_filter_quit)
          endfunction

          nnoremap <leader>* :Denite grep:::\\b<c-r><c-w>\\b<cr>
          nnoremap <leader>fr :Denite file/rec<cr>
          nnoremap <leader>bb :Denite buffer<cr>
          nnoremap <leader>gg :Denite grep<cr>

          call denite#custom#var('file/rec', 'command',
            \ ['rg', '--files', '--glob', '!.git', '--color', 'never'])
          call denite#custom#var('grep', {
            \ 'command': ['rg'],
            \ 'default_opts': ['-i', '--vimgrep', '--no-heading'],
            \ 'recursive_opts': [],
            \ 'pattern_opt': ['--regexp'],
            \ 'separator': ['--'],
            \ 'final_opts': [],
            \ })
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
      {
        plugin = pkgs.vimUtils.buildVimPluginFrom2Nix {
          pname = "srcery-vim";
          version = "2020-07-03";
          src = pkgs.fetchFromGitHub {
            owner = "srcery-colors";
            repo = "srcery-vim";
            rev = "a6ee51328ca26b792d974bcfab07812cce04b9f8";
            sha256 = "0q4x656djd4qj34jrl3df3r10g3gdkrf5pyg0v8ma9knx2j3nxk6";
          };
        };
        config = "colorscheme srcery";
      }
      {
        plugin = pkgs.vimUtils.buildVimPluginFrom2Nix {
          pname = "nvim-colorizer";
          version = "2020-09-07";
          src = pkgs.fetchFromGitHub {
            owner = "norcalli";
            repo = "nvim-colorizer.lua";
            rev = "36c610a9717cc9ec426a07c8e6bf3b3abcb139d6";
            sha256 = "0gvqdfkqf6k9q46r0vcc3nqa6w45gsvp8j4kya1bvi24vhifg2p9";
          };
        };
        config = "autocmd SourcePost colorizer.vim lua require'colorizer'.setup()";
      }
    ];
  };
}
