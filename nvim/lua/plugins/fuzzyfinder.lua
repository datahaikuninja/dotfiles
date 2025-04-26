return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.4",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("telescope").setup({
        defaults = {
          layout_strategy = "vertical",
          layout_config = {
            horizontal = { preview_cutoff = 0 },
            vertical = {
              height = function(_, _, max_lines)
                return max_lines
              end,
              preview_cutoff = 0,
              preview_height = 20,
            },
          },
          preview = {
            ls_short = true,
          },
        },
      })
      local builtin = require("telescope.builtin")
      -- keymaps for telescope
      vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
      vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
      vim.keymap.set("n", "<leader>fq", builtin.quickfix, {})
      vim.keymap.set("n", "<leader>fs", builtin.grep_string, {})
    end,
  },
}
