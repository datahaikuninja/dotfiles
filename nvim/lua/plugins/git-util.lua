return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "+" },
      },
      numhl = true, -- Toggle with `:Gitsigns toggle_numhl`

      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Actions
        map("n", "<leader>hp", gs.preview_hunk)
        map("n", "<leader>hn", gs.next_hunk)
        map("n", "<leader>hs", gs.stage_hunk)
        map("n", "<leader>hr", gs.reset_hunk)
        map("n", "<leader>hS", gs.stage_buffer)
        map("n", "<leader>hR", gs.reset_buffer)
        map("n", "<leader>hb", gs.toggle_current_line_blame)
        map("n", "<leader>hq", gs.setqflist)
      end,
    },
  },
  {
    "sindrets/diffview.nvim",
    opts = {},
  },
  {
    "pwntester/octo.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      -- Octo dose not support all commands for snacks.picker
      -- https://github.com/pwntester/octo.nvim/issues/1027
      --"folke/snacks.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    cmd = "Octo",
    config = function()
      require("octo").setup({
        enable_builtin = true,
      })
      vim.cmd([[hi OctoEditable guibg=none]])
      vim.keymap.set("n", "<leader>o", "<cmd>Octo<CR>", { noremap = true })
    end,
  },
}
