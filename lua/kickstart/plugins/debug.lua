-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

vim.pack.add {
  'https://github.com/mfussenegger/nvim-dap',
  'https://github.com/rcarriga/nvim-dap-ui',
  'https://github.com/nvim-neotest/nvim-nio',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/jay-babu/mason-nvim-dap.nvim',
  'https://github.com/leoluz/nvim-dap-go',
}

-- Basic debugging keymaps, feel free to change to your liking!
vim.keymap.set('n', '<F5>', function() require('dap').continue() end, { desc = 'Debug: Start/Continue' })
vim.keymap.set('n', '<F1>', function() require('dap').step_into() end, { desc = 'Debug: Step Into' })
vim.keymap.set('n', '<F2>', function() require('dap').step_over() end, { desc = 'Debug: Step Over' })
vim.keymap.set('n', '<F3>', function() require('dap').step_out() end, { desc = 'Debug: Step Out' })
vim.keymap.set('n', '<leader>b', function() require('dap').toggle_breakpoint() end, { desc = 'Debug: Toggle Breakpoint' })
vim.keymap.set('n', '<leader>B', function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end, { desc = 'Debug: Set Breakpoint' })
-- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
vim.keymap.set('n', '<F7>', function() require('dapui').toggle() end, { desc = 'Debug: See last session result.' })

-- Additional DAP commands
vim.keymap.set('n', '<leader>dt', function() require('dap').terminate() end, { desc = 'Debug: Terminate' })
vim.keymap.set('n', '<leader>dr', function() require('dap').restart() end, { desc = 'Debug: Restart' })
vim.keymap.set('n', '<leader>dp', function() require('dap').pause() end, { desc = 'Debug: Pause' })
vim.keymap.set('n', '<leader>dR', function() require('dap').run_last() end, { desc = 'Debug: Run Last' })
vim.keymap.set('n', '<leader>dl', function() require('dap').run_to_cursor() end, { desc = 'Debug: Run to Cursor' })
vim.keymap.set('n', '<leader>dC', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log message: ')) end, { desc = 'Debug: Set Log Point' })
vim.keymap.set('n', '<leader>de', function() require('dap').set_exception_breakpoints() end, { desc = 'Debug: Set Exception Breakpoints' })
vim.keymap.set('n', '<leader>du', function() require('dapui').open { reset = true } end, { desc = 'Debug: Open UI' })
vim.keymap.set('n', '<leader>dU', function() require('dapui').close() end, { desc = 'Debug: Close UI' })
vim.keymap.set('n', '<leader>dw', function() require('dap.ui.widgets').hover() end, { desc = 'Debug: Widget Hover' })
vim.keymap.set('n', '<leader>dW', function()
  local widget = require 'dap.ui.widgets'
  widget.centered_float(widget.scopes)
end, { desc = 'Debug: Widget Scopes' })
vim.keymap.set('n', '<leader>dE', function() require('dap').repl.open() end, { desc = 'Debug: Open REPL' })

local dap = require 'dap'
local dapui = require 'dapui'

require('mason-nvim-dap').setup {
  -- Makes a best effort to setup the various debuggers with
  -- reasonable debug configurations
  automatic_installation = true,

  -- You can provide additional configuration to the handlers,
  -- see mason-nvim-dap README for more information
  handlers = {},

  -- You'll need to check that you have the required things installed
  -- online, please don't ask me how to install them :)
  ensure_installed = {
    -- Update this to ensure that you have the debuggers for the langs you want
    'delve',
    'php-debug-adapter',
    'js-debug-adapter',
  },
}

-- Dap UI setup
-- For more information, see |:help nvim-dap-ui|
---@diagnostic disable-next-line: missing-fields
dapui.setup {
  -- Set icons to characters that are more likely to work in every terminal.
  --    Feel free to remove or use ones that you like more! :)
  --    Don't feel like these are good choices.
  icons = { expanded = 'Γû╛', collapsed = 'Γû╕', current_frame = '*' },
  ---@diagnostic disable-next-line: missing-fields
  controls = {
    icons = {
      pause = 'ΓÅ╕',
      play = 'Γû╢',
      step_into = 'ΓÅÄ',
      step_over = 'ΓÅ¡',
      step_out = 'ΓÅ«',
      step_back = 'b',
      run_last = 'Γû╢Γû╢',
      terminate = 'ΓÅ╣',
      disconnect = 'ΓÅÅ',
    },
  },
}

-- Change breakpoint icons
-- vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
-- vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
-- local breakpoint_icons = vim.g.have_nerd_font
--     and { Breakpoint = 'ε⌐▒', BreakpointCondition = 'ε¬º', BreakpointRejected = 'ε«î', LogPoint = 'ε¬½', Stopped = 'ε«ï' }
--   or { Breakpoint = 'ΓùÅ', BreakpointCondition = 'Γè£', BreakpointRejected = 'Γèÿ', LogPoint = 'Γùå', Stopped = 'Γ¡ö' }
-- for type, icon in pairs(breakpoint_icons) do
--   local tp = 'Dap' .. type
--   local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
--   vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
-- end

dap.listeners.after.event_initialized['dapui_config'] = dapui.open
dap.listeners.before.event_terminated['dapui_config'] = dapui.close
dap.listeners.before.event_exited['dapui_config'] = dapui.close

-- Install golang specific config
require('dap-go').setup {
  delve = {
    -- On Windows delve must be run attached or it crashes.
    -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
    detached = vim.fn.has 'win32' == 0,
  },
}

-- PHP Debug Configuration for Docker
dap.adapters.php = {
  type = 'executable',
  command = 'node',
  args = { vim.fn.stdpath 'data' .. '/mason/bin/php-debug-adapter' },
}

-- Helper function to find PHP container
local function find_php_container()
  local handle = io.popen 'docker ps --format "table {{.Names}}" | grep php'
  local result = handle:read '*a'
  handle:close()

  for container in result:gmatch '[%w%-%_]+' do
    if container:match 'php' then
      return container
    end
  end
  return nil
end

dap.configurations.php = {
  {
    type = 'php',
    request = 'launch',
    name = 'Debug PHP in Docker',
    pathMappings = {
      ['/var/www/html'] = '${workspaceFolder}',
    },
    port = 9003,
    host = 'localhost',
    xdebugSettings = {
      max_children = 128,
      max_data = 1024,
      max_depth = 3,
    },
    docker = {
      container = function()
        return find_php_container()
      end,
    },
  },
  {
    type = 'php',
    request = 'launch',
    name = 'Listen for Xdebug (Docker)',
    pathMappings = {
      ['/var/www/html'] = '${workspaceFolder}',
      ['/app'] = '${workspaceFolder}',
      ['/var/www/app'] = '${workspaceFolder}',
    },
    port = 9003,
    host = 'localhost',
    xdebugSettings = {
      max_children = 128,
      max_data = 1024,
      max_depth = 3,
    },
  },
}

-- Node.js/JavaScript Debug Configuration
dap.adapters['pwa-node'] = {
  type = 'server',
  host = 'localhost',
  port = '${port}',
  executable = {
    command = 'node',
    args = { vim.fn.stdpath 'data' .. '/mason/bin/js-debug-adapter', '${port}' },
  },
}

dap.configurations.javascript = {
  {
    type = 'pwa-node',
    request = 'launch',
    name = 'Launch Node.js Program',
    program = '${file}',
    cwd = '${workspaceFolder}',
    sourceMaps = true,
    protocol = 'inspector',
    console = 'integratedTerminal',
  },
  {
    type = 'pwa-node',
    request = 'launch',
    name = 'Launch Node.js Process (npm start)',
    runtimeExecutable = 'npm',
    runtimeArgs = { 'start' },
    cwd = '${workspaceFolder}',
    sourceMaps = true,
    protocol = 'inspector',
    console = 'integratedTerminal',
  },
  {
    type = 'pwa-node',
    request = 'attach',
    name = 'Attach to Node.js Process',
    processId = function()
      local handle = io.popen 'ps aux | grep node | grep -v grep'
      local result = handle:read '*a'
      handle:close()

      for line in result:gmatch '[^\r\n]+' do
        local pid = line:match '^%s*(%d+)'
        if pid then
          return tonumber(pid)
        end
      end
      return nil
    end,
    cwd = '${workspaceFolder}',
    sourceMaps = true,
    protocol = 'inspector',
  },
}

-- React Native Debug Configuration
dap.configurations.javascriptreact = dap.configurations.javascript
dap.configurations.typescript = dap.configurations.javascript
dap.configurations.typescriptreact = dap.configurations.javascript
