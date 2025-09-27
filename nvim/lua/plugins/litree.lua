-- plugins/litee.lua
return {
  {
    "ldelossa/litee.nvim",
    config = function()
      require("litee.lib").setup()
    end
  },
  {
    "ldelossa/litee-calltree.nvim",
    config = function()
      require("litee.calltree").setup()
    end
  }
}

