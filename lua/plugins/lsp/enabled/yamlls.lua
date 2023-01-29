return {
  settings = {
    redhat = {
      telemetry = {
        enabled = false,
      },
    },
    yaml = {
      format = {
        enable = false, -- FIXME and compare to yamlfmt
        -- singleQuote = true,
        -- bracketSpacing = true,
        -- proseWrap = '', Always, Never, Preserve
        -- printWidth = ?,
      },
      validate = true,
      hover = true,
      completion = true,
      -- schemas = {
      --   -- ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*"
      --   -- ["../path/relative/to/file.yml"] = "/.github/workflows/*"
      --   -- ["/path/from/root/of/project"] = "/.github/workflows/*"
      -- },
      schemaStore = {
        enable = true,
      },
      -- [yaml].editor.formatOnType: Enable/disable on type indent and auto formatting array
    },
  },
}
