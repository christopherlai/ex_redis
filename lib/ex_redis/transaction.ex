defmodule ExRedis.Transaction do
  def run(pool, fun_name, operations, opts) do
    :poolboy.transaction(pool, fn pid ->
      apply(Redix, fun_name, [pid, operations, opts])
    end)
  end
end
