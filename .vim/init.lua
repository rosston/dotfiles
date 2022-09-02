--[[

Table of contents:
1. early_setup
2. setup_plugins
3. editing_behavior
4. editor_layout
5. vim_behavior
6. shortcut_mappings
7. filetype_settings
8. strip_trailing_whitespace
9. plugin_settings
10. custom_commands

--]]

-- early_setup {{{

local HOME = os.getenv("HOME")

-- Set up an augroup for everything in here to use
local vimrc_augroup = vim.api.nvim_create_augroup("vimrc", { clear = true })

-- }}}

-- setup_plugins {{{

-- TODO: add plugin manager and load plugins

-- }}}

-- editing_behavior {{{

local tabsize = 2 -- a tab is 2 spaces

vim.opt.showmode = true -- always show what mode we're currently editing in
vim.opt.tabstop = tabsize -- set tab size
vim.opt.softtabstop = tabsize -- when hitting <BS>, pretend like a tab is removed, even if spaces
vim.opt.shiftwidth = tabsize -- number of spaces to use for autoindenting
vim.opt.expandtab = true -- expand tabs by default (overloadable per file type later)
vim.opt.shiftround = true -- use multiple of shiftwidth when indenting with '<' and '>'
vim.opt.backspace = "indent,eol,start" -- allow backspacing over everything in insert mode
vim.opt.autoindent = true -- always set autoindenting on
vim.opt.copyindent = true -- copy the previous indentation on autoindenting
vim.opt.number = true -- always show line numbers
vim.opt.showmatch = true -- set show matching parenthesis
vim.cmd("runtime macros/matchit.vim") -- make % match opening/closing HTML tags
vim.opt.ignorecase = true -- ignore case when searching
vim.opt.smartcase = true -- ignore case if search pattern is all lowercase, case-sensitive otherwise
vim.opt.smarttab = true -- insert tabs on the start of a line according to shiftwidth, not tabstop
vim.opt.scrolloff = 20 -- keep 4 lines off the edges of the screen when scrolling
vim.opt.hlsearch = true -- highlight search terms
vim.opt.incsearch = true -- show search matches as you type
vim.opt.gdefault = true -- search/replace "globally" (on a line) by default

-- set invisible characters
vim.opt.listchars = "tab:▸ ,trail:·,extends:#,nbsp:·"

vim.opt.list = false -- don't show invisible characters by default, but it is enabled for some file types (see later)
vim.opt.mouse = "a" -- enable using the mouse if terminal emulator supports it (xterm does)

vim.opt.fileformats = "unix,dos,mac"
vim.opt.wrap = true
vim.opt.textwidth = 79

vim.opt.formatoptions = "qrn1j"

vim.opt.colorcolumn = "+1"

vim.opt.nrformats = "" -- make <C-a> and <C-x> play well with zero-padded numbers (i.e. don't consider them octal or hex)

vim.opt.shortmess:append("I") -- hide the launch screen
vim.opt.clipboard = "unnamedplus" -- normal OS clipboard interaction
vim.opt.autoread = true -- automatically reload files changed outside of Vim
vim.opt.ttimeoutlen = 50

-- }}}

-- editor_layout {{{

vim.opt.lazyredraw = true -- don't update the display while executing macros
vim.opt.laststatus = 2 -- tell VIM to always put a status line in, even if there is only one window
vim.opt.cmdheight = 2 -- use a status bar that is 2 rows high

vim.opt.ruler = true -- enable line/col numbers in status bar

-- }}}

-- vim_behavior {{{

-- Turn on omni completion
vim.opt.omnifunc = "syntaxcomplete#Complete"

vim.opt.hidden = true -- hide buffers instead of closing them this means that the current buffer can be put to background without being written; and that marks and undo history are preserved
vim.opt.switchbuf = "useopen" -- reveal already opened files from the quickfix window instead of opening new buffers
vim.opt.history = 1000 -- remember more commands and search history
vim.opt.undolevels = 1000 -- use many muchos levels of undo
vim.opt.undofile = true -- keep a persistent backup file
vim.opt.undodir = string.format("%s/.vim/tmp/.undo,%s/tmp,/tmp", HOME, HOME) -- store undo files in one of these directories
vim.opt.backupcopy = "yes"
vim.opt.backupdir = string.format("%s/.vim/tmp/backup/,%s/tmp,/tmp", HOME, HOME) -- store backup files in one of these directories
vim.opt.directory = string.format("%s/.vim/tmp/swap/,%s/tmp,/tmp", HOME, HOME) -- store swap files in one of these directories
vim.opt.wildmenu = true -- make tab completion for files/buffers act like bash
vim.opt.wildmode = "list:full" -- show a list when pressing tab and complete first full match
vim.opt.wildignore = "*.swp,*.bak,*.pyc,*.class"
vim.opt.title = true -- change the terminal's title
vim.opt.visualbell = true -- don't beep
vim.opt.errorbells = false -- don't beep
vim.opt.showcmd = true -- show (partial) command in the last line of the screen this also shows visual selection info
vim.opt.modeline = false -- disable mode lines (security measure)
vim.opt.cursorline = true -- underline the current line, for quick orientation

-- save and restore cursor position when switching buffers
local function save_view()
	vim.b.winview = vim.fn.winsaveview()
end
vim.api.nvim_create_autocmd("BufLeave", {
	callback = save_view,
	group = vimrc_augroup,
	pattern = { "*" },
})

local function restore_view()
	if vim.b.winview then
		vim.fn.winrestview(vim.b.winview)
	end
end
vim.api.nvim_create_autocmd("BufEnter", {
	callback = restore_view,
	group = vimrc_augroup,
	pattern = { "*" },
})

vim.opt.inccommand = "split"

-- }}}

-- shortcut_mappings {{{

-- Set space as mapleader
vim.g.mapleader = " "

vim.cmd("source ~/.vim/visual-at.vim")

-- Fix Vim’s horribly broken default regex “handling” by automatically
-- inserting a \v before any string you search for.
vim.keymap.set({ "n", "v" }, "/", "/\\v")

-- Don't require the Shift key to form chords to enter ex mode.
vim.keymap.set("n", ";", ":")
-- Remap old behavior of ; (repeat last f, F, t, or T command) to <leader>;
-- TODO: map <leader>; <Plug>Sneak_;

-- Remap j and k to act as expected when used on long, wrapped, lines
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")

-- -- Remap Y to act like C and D
vim.keymap.set("n", "Y", "y$")

-- Allow repeated indent shifts
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Allow quickly searching for the visually selected text
vim.keymap.set("v", "//", 'y/<C-R>"<CR>')

-- Use leader for window movement
vim.keymap.set("n", "<Leader>w", "<C-w>")

-- Clears the search register
vim.keymap.set("n", "<Leader>sc", ":nohlsearch<CR>", { silent = true })

-- Toggle relative line numbers, makes it easier to use motion commands
vim.keymap.set("n", "<Leader>rel", ":set relativenumber!<CR>", { silent = true })

-- Launch Ack
vim.keymap.set("n", "<Leader>sap", ':ProjectRootExe Ack! ""<left>')

-- Copy path to current file
vim.keymap.set("n", "<Leader>yp", ":CopyPath<CR>")

-- git shortcuts
vim.keymap.set("n", "<Leader>gs", ":Gstatus<CR>")
vim.keymap.set("n", "<Leader>gb", ":Git blame<CR>")

-- jump to buffer by number
vim.keymap.set("n", "<Leader>bn", ':exe "buf" nr2char(getchar())<cr>', { silent = true })

-- Set a nicer escape sequence for terminal mode
vim.keymap.set("t", "<leader><Esc>", "<C-\\><C-n>")

-- }}}

-- filetype_settings {{{

-- Don't treat '-' as a word break character in the CSS language family
local function add_dash_keyword()
	vim.opt_local.iskeyword:append("-")
end
vim.api.nvim_create_autocmd("FileType", {
	callback = add_dash_keyword,
	group = vimrc_augroup,
	pattern = { "css", "less", "sass", "scss" },
})

-- Force .lfe files to be treated as lisp
local function ft_lisp()
	vim.opt.ft = "lisp"
end
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	callback = ft_lisp,
	group = vimrc_augroup,
	pattern = { "*.lfe" },
})

-- }}}

-- strip_trailing_whitespace {{{

if not vim.g.rosston_strip_trailing_whitespace then
	vim.g.rosston_strip_trailing_whitespace = 1
end

local function strip_trailing_whitespace()
	if vim.g.rosston_strip_trailing_whitespace == 1 and vim.o.filetype ~= "markdown" then
		local l = vim.fn.line(".")
		local c = vim.fn.col(".")

		vim.cmd("%s/\\s\\+$//e")

		vim.fn.cursor(l, c)
	end
end

vim.api.nvim_create_autocmd("BufWritePre", {
	callback = strip_trailing_whitespace,
	group = vimrc_augroup,
	pattern = { "*" },
})

-- }}}

-- plugin_settings {{{

-- }}}

-- custom_commands {{{

vim.api.nvim_create_user_command("CopyPath", 'let @* = expand("%:p") | echo expand("%:p")', {})
vim.api.nvim_create_user_command("PrettyJSON", "%!python -m json.tool", {})
vim.api.nvim_create_user_command("Session", ":exe 'Obsession' projectroot#guess()", {})

local function run_project_command(opts)
	vim.fn["projectroot#exe"]({ "exe", '":!' .. opts.args .. '"' })
end
vim.api.nvim_create_user_command("Psh", run_project_command, { nargs = "*" })

-- }}}
