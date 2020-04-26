defmodule ExRedis.Supervisor do
  def start_link(module) do
    :poolboy.start_link([name: {:local, module}, worker_module: Redix], [])
  end

  def child_spec(args) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [name: {:local, __MODULE__}], [], args},
      restart: :permanent,
      type: :supervisor
    }
  end

  def compile_time_config(opts) do
    otp_app = opts[:otp_app]

    unless otp_app do
      raise ArgumentError, "missing :otp_app option on use ExRedis"
    end

    {otp_app}
  end
end
