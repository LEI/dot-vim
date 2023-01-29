-- bash-language-server

-- BASH_IDE_LOG_LEVEL

return {
  settings = {
    -- Maximum number of files to analyze in the background. Set to 0 to disable background analysis.
    -- backgroundAnalysisMaxFiles = 500,

    -- Glob pattern for finding and parsing shell script files in the workspace.
    -- Used by the background analysis features across files.
    -- globPattern = '**/*@(.sh|.inc|.bash|.command)',

    -- https://github.com/idank/explainshell
    -- https://github.com/bash-lsp/bash-language-server/issues/180
    -- Configure explainshell server endpoint in order to get hover documentation on flags and options.
    -- And empty string will disable the feature.
    -- explainshellEndpoint = 'localhost:5001',

    -- Controls how symbols (e.g. variables and functions) are included and used for completion and documentation.
    -- If false, then we only include symbols from sourced files
    -- (i.e. using non dynamic statements like 'source file.sh' or '. file.sh').
    -- If true, then all symbols from the workspace are included.
    -- includeAllWorkspaceSymbols = false,

    -- Additional ShellCheck arguments.
    -- Note that we already add the following arguments: --shell, --format, --external-sources."
    -- shellcheckArguments = {},

    -- Controls the executable used for ShellCheck linting information.
    -- An empty string will disable linting.
    -- shellcheckPath = 'shellcheck',

    -- Note: formatting is not supported yet
    -- https://github.com/bash-lsp/bash-language-server/issues/320
  },
}
