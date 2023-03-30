defmodule Exsaml do
  @moduledoc """
  `exsaml` is a Service Provider SAML implementation.

  It supports standalone IdP metadata & aggregated metadata (for federations).

  IdP metadata are cached on ETS. Therefore, you must execute `Examl.start`
  at the start of your main application. Since exsaml isn't an application
  but only a library, `Exsaml.start` only role is to prepare ETS.
  """

  @doc """
  You must execute this function before using Exsaml.

  Start an ETS used for caching IdP metadata.
  """
  def start do
    _table = Exsaml.Cache.start()

    :ok
  end
end
