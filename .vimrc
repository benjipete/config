call plug#begin('~/.vim/plugged')
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'ibhagwan/fzf-lua', {'branch': 'main'}
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'neovim/nvim-lspconfig'
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-dispatch'
    Plug 'tpope/vim-obsession'
    Plug 'lakshayg/vim-bazel'
    Plug 'sakhnik/nvim-gdb', { 'do': ':!./install.sh' }
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-cmdline'
    Plug 'hrsh7th/nvim-cmp'
    Plug 'stevearc/qf_helper.nvim'
    Plug 'nvim-lualine/lualine.nvim'
    Plug 'moll/vim-bbye'
    Plug 'm-pilia/vim-ccls'
    Plug 'altercation/vim-colors-solarized'
    Plug 'rhysd/vim-clang-format'
call plug#end()

set shell=/usr/bin/bash
set rtp+=~/.fzf

set visualbell
set tabstop=4
set softtabstop=4
set shiftwidth=4
set laststatus=2
set expandtab
set autoindent
set number
set smarttab
set so=12
set backspace=indent,eol,start
set switchbuf+=uselast
set mps+=<:>

au FileType json setlocal tabstop=2 softtabstop=2 shiftwidth=2
au FileType gitcommit setlocal tw=72
au FileType gitcommit setlocal colorcolumn=72
autocmd bufreadpre *.txt setlocal textwidth=144
au FileType qf wincmd J

set splitbelow
set splitright

let g:dispatch_no_tmux_make = 1
let g:dispatch_no_tmux_dispatch = 1
let g:bazel_make_command = "Make"
let g:nvimgdb_use_find_executables = 0

let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25
" Add Directory browwser initially
" augroup ProjectDrawer
"   autocmd!
"   autocmd VimEnter * :Vexplore
" augroup END
function! NetrwOpenMultiTab(current_line,...) range
   " Get the number of lines.
   let n_lines =  a:lastline - a:firstline + 1

   " This is the command to be built up.
   let command = "normal "

   " Iterator.
   let i = 1

   " Virtually iterate over each line and build the command.
   while i < n_lines
      let command .= "tgT:" . ( a:firstline + i ) . "\<CR>:+tabmove\<CR>"
      let i += 1
   endwhile
   let command .= "tgT"

   " Restore the Explore tab position.
   if i != 1
      let command .= ":tabmove -" . ( n_lines - 1 ) . "\<CR>"
   endif

   " Restore the previous cursor line.
   let command .= ":" . a:current_line  . "\<CR>"

   " Check function arguments
   if a:0 > 0
      if a:1 > 0 && a:1 <= n_lines
         " The current tab is for the nth file.
         let command .= ( tabpagenr() + a:1 ) . "gt"
      else
         " The current tab is for the last selected file.
         let command .= (tabpagenr() + n_lines) . "gt"
      endif
   endif
   " The current tab is for the Explore tab by default.

   " Execute the custom command.
   execute command
endfunction

" Define mappings.
augroup NetrwOpenMultiTabGroup
   autocmd!
   autocmd Filetype netrw vnoremap <buffer> <silent> <expr> t ":call NetrwOpenMultiTab(" . line(".") . "," . "v:count)\<CR>"
   autocmd Filetype netrw vnoremap <buffer> <silent> <expr> T ":call NetrwOpenMultiTab(" . line(".") . "," . (( v:count == 0) ? '' : v:count) . ")\<CR>"
augroup END


syntax enable
set background=dark
colorscheme solarized

lua << EOF
local cmp = require'cmp'

cmp.setup({
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources{
      { name = 'nvim_lsp' },
      { name = 'buffer' },
    }
})

cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' },
    { name = 'cmdline' }
  })
})

require'lspconfig'.clangd.setup{ 
    cmd = {
        "/opt/imc/llvm-17/bin/clangd", 
        "--background-index",
        "--background-index-priority=normal",
        "--function-arg-placeholders",
        "--all-scopes-completion",
        "--compile-commands-dir=".. vim.fn.getcwd(),
    }
}

require'lspconfig'.pyright.setup{}


require'qf_helper'.setup()

require'nvim-treesitter.configs'.setup {
  ensure_installed = { "cpp", "java", "python", "bash", "fish", "json" },
  sync_install = false,
  ignore_install = { },
  highlight = {
    enable = true,
    disable = { "c" },
    additional_vim_regex_highlighting = false,
  },
}

require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = 'auto',
    component_separators = { left = '|', right = '|'},
    section_separators = { left = '|', right = '|'},
    disabled_filetypes = {},
    always_divide_middle = true,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {{'filename', path = 1}},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {{'filename', path = 1}},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {
  },
  extensions = {}
}

require('fzf-lua').setup{
    height = 0.6,
    width = 0.8,
    row = 0.6,
    previewers = {
        builtin = {
            limit_b = 100 * 1024 * 1024;
        }
    }
}

require('fzf-lua').register_ui_select()

function bazel_config(query)
    query = query or ""
    require'fzf-lua'.fzf_exec("grep 'common:' .bazelrc | cut -f2 -d':' | cut -f1 -d' '", {
      silent_fail = false,
      actions = {
        ['default'] = function(selected, opts)
            vim.api.nvim_command('Bazel build //buildtimeconstants:cc-lib --config='..selected[1])
        end
      }
    })
end

function bazel_build(query)
    query = query or "//..."
    require'fzf-lua'.fzf_exec("bazel query "..query, {
      silent_fail = false,
      actions = {
        ['default'] = function(selected, opts)
            vim.fn.feedkeys(':Bazel build '..selected[1])
        end
      }
    })
end

function bazel_test(query)
    query = query or "//..."
    require'fzf-lua'.fzf_exec("bazel query 'tests("..query..")'", {
      silent_fail = false,
      actions = {
        ['default'] = function(selected, opts)
            vim.fn.feedkeys(':Bazel test --config=ClangDebug '..selected[1])
        end
      }
    })
end

function bazel_debug(query)
    query = query or "//..."
    require'fzf-lua'.fzf_exec(
        "bazel cquery --config=ClangDebug -k --allow_analysis_failures=true --experimental_repository_disable_download=true "..
        "--output=starlark --starlark:expr=target.files_to_run.executable.path "..query.." || true", {
      silent_fail = false,
      actions = {
        ['default'] = function(selected, opts)
            vim.fn.feedkeys(':GdbStart /opt/imc/gdb/bin/gdb '..selected[1])
        end
      }
    })
end

EOF

if executable('svls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'svls',
        \ 'cmd': {server_info->['svls']},
        \ 'whitelist': ['systemverilog'],
        \ })
endif

inoremap <expr><CR>  pumvisible() ? "\<ESC>" : "\<CR>"
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
imap <C-c> <Esc>

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

map <space>j :resize +10<CR>
map <space>k :resize -10<CR>
map <space>l :vertical resize +10<CR>
map <space>h :vertical resize -10<CR>

map \f :lua require('fzf-lua').files()<CR>
map \e :lua require('fzf-lua').files({cwd='bazel-bin'})<CR>
map \h :lua require('fzf-lua').command_history()<CR>
map \o :lua require('fzf-lua').buffers()<CR>
map \l :lua require('fzf-lua').lines()<CR>
map \F :lua require('fzf-lua').live_grep_native()<CR>
map \q :lua require('fzf-lua').lsp_document_symbols()<CR>
map \D :lua require('fzf-lua').lsp_document_diagnostics()<CR>
map \a :lua require('fzf-lua').lsp_code_actions()<CR>
map \S :lua require('fzf-lua').lsp_live_workspace_symbols()<CR>
map \i :lua require('fzf-lua').lsp_implementations()<CR>
map \R :lua require('fzf-lua').lsp_references()<CR>
map \m :lua require('fzf-lua').commands()<CR>
map \M :lua require('fzf-lua').keymaps()<CR>
map \G :lua require('fzf-lua').grep_cword()<CR>
map \A :lua require('fzf-lua').builtin()<CR>
map \z :lua vim.lsp.buf.hover()<CR>
map \r :lua vim.lsp.buf.definition()<CR>
map \c :lua vim.lsp.buf.formatting()<CR>
map \C :lua vim.lsp.buf.range_formatting()<CR>
map <C-n> :lua vim.diagnostic.goto_next()<CR>
map <C-p> :lua vim.diagnostic.goto_prev()<CR>
map \b :lua bazel_build()<CR>
map \B :lua bazel_config()<CR>
map \t :lua bazel_test()<CR>
map \d :lua bazel_debug()<CR>
map \s :split<CR>
map \v :vsplit<CR>
map \V :lefta vsplit<CR>
map \g :ClangdSwitchSourceHeader<CR>
map \w :Bdelete<CR>
map \W :Bdelete!<CR>
nmap <silent> <M-1> :QFToggle!<CR>
nmap <silent> <M-2> :LLToggle!<CR>
map \N :cn<CR>
map \P :cp<CR>
map <C-a> :Git blame<CR>
map <C-g> :Git log %<CR>
