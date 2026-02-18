-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'mason-org/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
  },
  keys = {
    -- Basic debugging keymaps, feel free to change to your liking!
    {
      '<F5>',
      function() require('dap').continue() end,
      desc = 'Debug: Start/Continue',
    },
    {
      '<F1>',
      function() require('dap').step_into() end,
      desc = 'Debug: Step Into',
    },
    {
      '<F2>',
      function() require('dap').step_over() end,
      desc = 'Debug: Step Over',
    },
    {
      '<F3>',
      function() require('dap').step_out() end,
      desc = 'Debug: Step Out',
    },
    {
      '<leader>b',
      function() require('dap').toggle_breakpoint() end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      '<leader>B',
      function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end,
      desc = 'Debug: Set Breakpoint',
    },
    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    {
      '<F7>',
      function() require('dapui').toggle() end,
      desc = 'Debug: See last session result.',
    },
    -- Additional DAP commands
    {
      '<leader>dt',
      function()
        require('dap').terminate()
      end,
      desc = 'Debug: Terminate',
    },
    {
      '<leader>dr',
      function()
        require('dap').restart()
      end,
      desc = 'Debug: Restart',
    },
    {
      '<leader>dp',
      function()
        require('dap').pause()
      end,
      desc = 'Debug: Pause',
    },
    {
      '<leader>dR',
      function()
        require('dap').run_last()
      end,
      desc = 'Debug: Run Last',
    },
    {
      '<leader>dl',
      function()
        require('dap').run_to_cursor()
      end,
      desc = 'Debug: Run to Cursor',
    },
    {
      '<leader>dC',
      function()
        require('dap').set_breakpoint(nil, nil, vim.fn.input('Log message: '))
      end,
      desc = 'Debug: Set Log Point',
    },
    {
      '<leader>de',
      function()
        require('dap').set_exception_breakpoints()
      end,
      desc = 'Debug: Set Exception Breakpoints',
    },
    {
      '<leader>du',
      function()
        require('dapui').open { reset = true }
      end,
      desc = 'Debug: Open UI',
    },
    {
      '<leader>dU',
      function()
        require('dapui').close()
      end,
      desc = 'Debug: Close UI',
    },
    {
      '<leader>dw',
      function()
        require('dap.ui.widgets').hover()
      end,
      desc = 'Debug: Widget Hover',
    },
    {
      '<leader>dW',
      function()
        local widget = require 'dap.ui.widgets'
        widget.centered_float(widget.scopes)
      end,
      desc = 'Debug: Widget Scopes',
    },
    -- DAP REPL
    {
      '<leader>dE',
      function()
        require('dap').repl.open()
      end,
      desc = 'Debug: Open REPL',
    },
  },
  config = function()
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
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Change breakpoint icons
    -- vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
    -- vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
    -- local breakpoint_icons = vim.g.have_nerd_font
    --     and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
    --   or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
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
  end,
}
