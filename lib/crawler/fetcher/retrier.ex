defmodule Crawler.Fetcher.Retrier do
  @moduledoc """
  Handles retries for failed crawls.
  """

  defmodule Spec do
    @moduledoc """
    Spec for defining a fetch retrier.
    """

    @type fetch_url :: fun
    @type opts      :: map

    @callback perform(fetch_url, opts) :: term
  end

  @behaviour __MODULE__.Spec

  use Retry

  @doc """
  More information: [https://github.com/safwank/ElixirRetry](https://github.com/safwank/ElixirRetry)
  """
  def perform(fetch_url, opts) do
    retry with: exp_backoff() |> expiry(timeout_value(opts[:timeout])) do
      fetch_url.()
    end
  end

  defp timeout_value(value) do
    case Kernel.is_integer(value) do
      true  -> value
      false -> 5_000
    end
  end
end
