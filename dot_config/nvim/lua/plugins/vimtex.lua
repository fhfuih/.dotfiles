return {
  {
    "lervag/vimtex",
    ft = { "tex", "bib" },
    init = function()
      local g = vim.g

      -- Auto view after compile: use VimTeX, not LSP
      -- -- It is related to what I use for auto compile
      -- -- Also, VimTeX can configure whether or not to give up window focus to PDF previewer
      if vim.fn.has "mac" then
        g.vimtex_view_method = "skim"
        g.vimtex_view_skim_sync = 1
        g.vimtex_view_skim_activate = 0
        g.vimtex_view_skim_reading_bar = 1
      end

      -- Syntax Highlight: use VimTeX, not TS.
      -- -- See *vimtex-faq-treesitter*
      -- -- Plus, current latex TS seems to not support expl3

      -- Syntax textobjects: use VimTeX, not TS.
      -- Because TS unifies the names across all languages (classes, methods...),
      -- and they contradict Tex terms (C for commands=functions, not classes)

      -- Completion: use LSP, not VimTeX
      -- -- (because of cmp-omni bug, cannot connect omni suggestions from VimTeX to cmp)
      g.vimtex_complete_enabled = 1

      -- Diagnostic: use LSP, not VimTeX
      -- -- I can use unified diagnostic view to see compilation errors and other lsp's outputs
      -- -- And also I hate it when a quickfix window popup when I am continuously building and writing
      g.vimtex_quickfix_enabled = 0

      -- Fold: use VimTeX, not TS
      g.vimtex_fold_enabled = 1

      -- Conceal: use VimTeX, not TS
      g.vimtex_syntax_conceal = {
        ligatures = 0,
        spacing = 0,
        sections = 1,
      }
      g.vimtex_syntax_conceal_cites = {
        ["type"] = "icon",
      }

      -- Auto compile: use VimTeX, not LSP
      -- -- because my texlab sometimes detects wrong root file.
      -- -- And it will generate aux files for subfiles upon build.
      -- -- And there is subsequent undefined control sequences everywhere
      -- -- until I delete the wrong aux files
      -- -- This seems to be a recent problem though. Dunno why.
      -- -- I have also tried texlab.rootDirectory="." according to an issue. But no luck.
      vim.api.nvim_create_augroup("vimtex_config", {})
      vim.api.nvim_create_autocmd("User", {
        group = "vimtex_config",
        pattern = "VimtexEventInitPost",
        callback = function()
          local vimtex = vim.api.nvim_buf_get_var(0, "vimtex")
          if vimtex.compiler.status and vimtex.compiler.status < 1 then vim.cmd "VimtexCompile" end
        end,
      })
      -- math mode imaps
      g.vimtex_imaps_leader = "@"
    end,
  },
}
