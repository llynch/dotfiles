local telescope = require('telescope')
local CD_HISTORY_DIR = vim.fn.getenv "CD_HISTORY_DIR"

local cdh = {}
if (CD_HISTORY_DIR ~= nil) then
-- probably best if we update LUA_PATH from bashrc
    package.path = package.path .. ';' .. vim.fs.joinpath(CD_HISTORY_DIR, '?.lua')
    -- vim.api.nvim_out_write(vim.inspect(package.path) .. '\n')
    cdh = require('nvim-cd-history')
end

local function prompt_strip_spaces(prompt)
    -- allow support for spaces because 
    local new_prompt = {}
    vim.api.nvim_out_write(prompt .. '\n')
    new_prompt.prompt = prompt:gsub(" ", "")
    return new_prompt
end

telescope.setup({
    defaults = {
        -- Default configuration for telescope goes here:
        -- config_key = value,
        mappings = {
            i = {
                -- map actions.which_key to <C-h> (default: <C-/>)
                -- actions.which_key shows the mappings for your picker,
                -- e.g. git_{create, delete, ...}_branch for the git_branches picker
                ["<C-h>"] = "which_key"
            }
        }
    },
    pickers = {
        find_files = { on_input_filter_cb = prompt_strip_spaces },
        oldfiles = { on_input_filter_cb = prompt_strip_spaces },
        buffers = { on_input_filter_cb = prompt_strip_spaces },
        lsp_references = { on_input_filter_cb = prompt_strip_spaces }
    },
    extensions = {

    }
})

local function option_cwd(wrapped_telescope_picker)
    function call_picker(...)
        local options = {}
        local bufnr = vim.api.nvim_get_current_buf()
        local filename = vim.api.nvim_buf_get_name(bufnr)
        local directory = vim.fs.dirname(filename)
        -- todo check if its a git repo, telescope error is not pretty.
        options.cwd = directory
        wrapped_telescope_picker(options)
    end
    return call_picker
end

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set( "n", "<leader>fd", "<cmd>Telescope diagnostics bufnr=0 theme=dropdown prompt_title=diagnostics previewer=false <CR>")
vim.keymap.set('n', '<leader>l', builtin.buffers, {})
vim.keymap.set('n', '<leader>fi', builtin.builtin, {})
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', option_cwd(builtin.git_files), {})
vim.keymap.set('n', '<leader>flf', option_cwd(builtin.find_files), {})
vim.keymap.set('n', '<leader>flw', option_cwd(builtin.live_grep), {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fo', builtin.oldfiles, {})
vim.keymap.set('n', '<leader>fr', builtin.lsp_references, {})
vim.keymap.set('n', '<leader><leader>f', builtin.resume, {})
vim.keymap.set('n', '<leader>fs', builtin.treesitter, {})
vim.keymap.set('n', '<leader>ft', builtin.tags, {})
vim.keymap.set('n', '<leader>fw', builtin.live_grep, {})
local function cdh_c()
    cdh.c({
        on_input_filter_cb = prompt_strip_spaces
    })
end
vim.keymap.set('n', '<leader>c', cdh_c, {})
vim.keymap.set('n', '<leader>fc', cdh_c, {})

local colors = require("catppuccin.palettes").get_palette()
local TelescopeColor = {
	TelescopeMatching = { fg = colors.flamingo },
	TelescopeSelection = { fg = colors.text, bg = colors.surface0, bold = true },

	TelescopePromptPrefix = { bg = colors.surface0 },
	TelescopePromptNormal = { bg = colors.surface0 },
	TelescopeResultsNormal = { bg = colors.mantle },
	TelescopePreviewNormal = { bg = colors.mantle },
	TelescopePromptBorder = { bg = colors.surface0, fg = colors.surface0 },
	TelescopeResultsBorder = { bg = colors.mantle, fg = colors.mantle },
	TelescopePreviewBorder = { bg = colors.mantle, fg = colors.mantle },
	TelescopePromptTitle = { bg = colors.pink, fg = colors.mantle },
	TelescopeResultsTitle = { fg = colors.mantle },
	TelescopePreviewTitle = { bg = colors.green, fg = colors.mantle },
}

for hl, col in pairs(TelescopeColor) do
	vim.api.nvim_set_hl(0, hl, col)
end

