return {
  -- Neovim does not currently include built-in snippets.
  -- Completions are provided only when snippet support is enabled.
  -- To enable completion, install a snippet plugin and add the following
  -- override to your language client capabilities during setup.
  completion = function()
    return {
      textDocument = {
        completion = {
          completionItem = {
            snippetSupport = true,
          },
        },
      },
    }
  end,
}
