return {
  "nvim-mini/mini.surround",
  opts = {
    mappings = {
      add = ";gsa",          -- New keybind to add surrounding (original: gsa)
      delete = ";gsd",       -- New keybind to delete surrounding (original: gsd)
      find = ";gsf",         -- New keybind to find surrounding (original: gsf)
      find_left = ";gsF",    -- New keybind to find left surrounding (original: gsF)
      highlight = ";gsh",    -- New keybind to highlight surrounding (original: gsh)
      replace = ";gsr",      -- New keybind to replace surrounding (original: gsr)
      update_n_lines = ";gsn", -- New keybind to update n lines (original: gsn)
    },
  },
}
