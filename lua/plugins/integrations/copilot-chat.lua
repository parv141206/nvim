return {
  "CopilotC-Nvim/CopilotChat.nvim",
  branch = "main",
  dependencies = {
    { "github/copilot.vim" },
    { "nvim-lua/plenary.nvim" },
  },
  opts = {
    debug = false,
    show_help = true,
  },
  config = function(_, opts)
    require("CopilotChat").setup(opts)

    vim.keymap.set("n", "<leader>cch", ":CopilotChatOpen<CR>", { desc = "Open Copilot Chat" })
    vim.keymap.set("n", "<leader>cce", ":CopilotChatExplain<CR>", { desc = "Copilot explain code" })
    vim.keymap.set("n", "<leader>ccr", ":CopilotChatReview<CR>", { desc = "Copilot review code" })
    vim.keymap.set("n", "<leader>ccf", ":CopilotChatFix<CR>", { desc = "Copilot fix code" })

    vim.keymap.set("v", "<leader>cch", ":CopilotChatOpen<CR>", { desc = "Open Copilot Chat" })
    vim.keymap.set("v", "<leader>cce", ":CopilotChatExplain<CR>", { desc = "Copilot explain code" })
    vim.keymap.set("v", "<leader>ccr", ":CopilotChatReview<CR>", { desc = "Copilot review code" })
    vim.keymap.set("v", "<leader>ccf", ":CopilotChatFix<CR>", { desc = "Copilot fix code" })
  end,
}
