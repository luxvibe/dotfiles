return {
  {
    "folke/sidekick.nvim",
    opts = {
      cli = {
        default = "antigravity",
        mux = {
          backend = "tmux",
          enabled = true,
        },
        tools = {
          antigravity = {
            cmd = { "agy" },
            env = { TERM_PROGRAM = "" },
          },
        },
      },
    },
    keys = {
      -- AI CLI 面板开关
      {
        "<leader>aa",
        function() require("sidekick.cli").toggle() end,
        desc = "Sidekick Toggle CLI",
      },
      -- 选择 AI 工具（claude / codex / gemini ...）
      {
        "<leader>as",
        function() require("sidekick.cli").select() end,
        desc = "Sidekick Select Tool",
      },
      -- 发送当前文件
      {
        "<leader>af",
        function() require("sidekick.cli").send({ msg = "{file}" }) end,
        desc = "Sidekick Send File",
      },
      -- 发送光标处代码（普通模式）或选中内容（可视模式）
      {
        "<leader>at",
        function() require("sidekick.cli").send({ msg = "{this}" }) end,
        mode = { "n", "x" },
        desc = "Sidekick Send This",
      },
      -- 发送可视选区
      {
        "<leader>av",
        function() require("sidekick.cli").send({ msg = "{selection}" }) end,
        mode = { "x" },
        desc = "Sidekick Send Selection",
      },
      -- 选择预置 prompt
      {
        "<leader>ap",
        function() require("sidekick.cli").prompt() end,
        mode = { "n", "x" },
        desc = "Sidekick Prompt Library",
      },
      -- 快速聚焦 CLI 面板
      {
        "<c-.>",
        function() require("sidekick.cli").focus() end,
        mode = { "n", "t", "i", "x" },
        desc = "Sidekick Focus",
      },
    },
  },
}
