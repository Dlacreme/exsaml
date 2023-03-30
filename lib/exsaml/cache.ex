defmodule Exsaml.Cache do
  @moduledoc """
  Use ETS to build a cache.
  """

  @idp_metadata_key :exsaml_idp_metadata

  @doc """
  Start a new ETS table used to cache IdP metadata.
  """
  def start() do
    :ets.new(@idp_metadata_key, [:set, :protected])
  end
end
