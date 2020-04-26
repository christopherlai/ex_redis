defmodule ExRedis do
  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      {otp_app} = ExRedis.Supervisor.compile_time_config(opts)

      @otp_app otp_app

      @base_functions [
        :command,
        :noreply_command,
        :noreply_pipeline,
        :pipeline,
        :transaction_pipeline
      ]

      def start_link do
        ExRedis.Supervisor.start_link(__MODULE__)
      end

      def child_spec(args) do
        %{
          id: __MODULE__,
          start: {__MODULE__, :start_link, args}
        }
      end

      for name <- @base_functions do
        bang = String.to_atom("#{name}!")

        def unquote(name)(operations, opts \\ []) do
          transaction(unquote(name), operations, opts)
        end

        def unquote(bang)(operations, opts \\ []) do
          transaction(unquote(name), operations, opts)
        end
      end

      defp transaction(fun_name, operations, opts) do
        ExRedis.Transaction.run(__MODULE__, fun_name, operations, opts)
      end
    end
  end
end
