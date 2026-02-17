return {
  {
    "mfussenegger/nvim-dap",
    keys = { "<leader>db", "<leader>dc" },
    config = function()
      local dap = require("dap")

      ---------------------------------------------------
      -- Key Mappings
      ---------------------------------------------------
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { noremap = true })
      vim.keymap.set("n", "<leader>dc", dap.continue, { noremap = true })
      vim.keymap.set("n", "<leader>di", dap.step_into, { noremap = true })
      vim.keymap.set("n", "<leader>do", dap.step_over, { noremap = true })
      vim.keymap.set("n", "<leader>dout", dap.step_out, { noremap = true })
      vim.keymap.set("n", "<leader>dr", dap.repl.open, { noremap = true })

      ---------------------------------------------------
      -- Python Debugging (requires debugpy)
      ---------------------------------------------------
      if vim.fn.executable("python3") == 1 then
        dap.adapters.python = {
          type = "executable",
          command = "python3",
          args = { "-m", "debugpy.adapter" },
        }

        dap.configurations.python = {
          {
            type = "python",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            pythonPath = function()
              -- Use python3 from PATH
              return "/usr/bin/python3"
            end,
          },
          {
            type = "python",
            request = "launch",
            name = "Launch with arguments",
            program = "${file}",
            args = function()
              local args_str = vim.fn.input("Arguments: ")
              return vim.split(args_str, " ")
            end,
            pythonPath = function()
              return "/usr/bin/python3"
            end,
          },
        }
      end

      ---------------------------------------------------
      -- Bash/Shell Debugging (optional, requires bash-debug-adapter)
      ---------------------------------------------------
      -- Note: bash-debug-adapter is not auto-installed
      -- Install manually if needed: npm install -g bash-debug-adapter
      dap.adapters.bash = {
        type = "executable",
        command = "bash-debug-adapter",
      }

      dap.configurations.bash = {
        {
          type = "bash",
          request = "launch",
          name = "Launch Bash script",
          program = "${file}",
          cwd = "${workspaceFolder}",
        },
      }
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()

      dap.listeners.after.event_initialized["dapui"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui"] = function()
        dapui.close()
      end
    end,
  },
}
