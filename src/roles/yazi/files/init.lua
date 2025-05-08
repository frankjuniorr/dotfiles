    -- DuckDB plugin configuration
require("duckdb"):setup({
  mode = "standard",            -- Default: "summarized" (options: "standard"/"summarized")
  cache_size = 1000,               -- Default: 500
  row_id = false,                 -- Default: false (options: true/false/"dynamic")
  minmax_column_width = 21,       -- Default: 21 (int)
  column_fit_factor = 10.0       -- Default: 10.0 (float)
})
