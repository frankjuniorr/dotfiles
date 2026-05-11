-- DuckDB plugin configuration
require("duckdb"):setup({
  mode = "standard",
  cache_size = 1000,
  row_id = false,
  minmax_column_width = 21,
  column_fit_factor = 10.0
})
