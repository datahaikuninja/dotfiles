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
}
