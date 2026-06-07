-- Serendipity 配色 + 跟随系统明暗(终端驱动,零轮询)
--
-- 机制:Neovim 0.11+ 启用 DEC private mode 2031,ghostty 在 macOS 外观切换时
-- 主动通知 nvim(CSI ? 997 n),nvim 自行重查终端背景色并更新 `vim.o.background`
-- —— 无需任何 OSC 查询代码。我们只在 background 变化时切到对应 Serendipity 变体。
--
-- ⚠️ 关键约束:绝不显式设置 `vim.o.background`,否则 nvim 原生自动检测会自我注销。
-- 为此 colors/serendipity-*.lua 已删去各自的 `vim.o.background` 行,由 nvim 统一
-- 掌管 background,配色文件只定义高亮。
--
-- 深色 = serendipity-sunset、浅色 = serendipity-morning(与 ghostty/bat 一致)。
-- 前提:nvim 与 ghostty 之间无 tmux(2031 需链路每一层都支持)。

local function scheme_for(bg)
  return bg == "light" and "serendipity-morning" or "serendipity-sunset"
end

return {
  -- 不再需要轮询插件:nvim 原生 2031 已覆盖。
  { "f-person/auto-dark-mode.nvim", enabled = false },

  -- 阻止 LazyVim 设默认 colorscheme(它会干扰检测),改由 init 依检测到的
  -- background 选初始配色,并在运行时切换变体。
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = function() end },
    init = function()
      vim.api.nvim_create_autocmd("OptionSet", {
        pattern = "background",
        callback = function()
          vim.cmd.colorscheme(scheme_for(vim.o.background))
        end,
      })
      -- 首帧:按启动时检测到的 background 选配色。
      vim.cmd.colorscheme(scheme_for(vim.o.background))
    end,
  },
}
