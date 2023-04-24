defmodule Exsaml.Metadata.SP do
  @moduledoc """
  Build SP metadata and generate as XML.

  Metadata should be built incrementally before being
  validated and generated as XML.

  ```
  alias Exsaml.Metadata.SP as MetadataSP

  %{}
  |> MetadataSP.entity_id("my.entityid.com") # required
  |> MetadataSP.consume_url("https://xxx/consume") # required
  |> MetadataSP.logout_url("https://xxx/logout') # optional
  |> MetadataSP.nameid_format("urn:oasis:names:tc:SAML:2.0:nameid-format:transient") # optional
  # You can add multiplicate certificates. By default they are used for both signature & encryption
  |> MetadataSP.certificate(cert)
  # You can add a certificate with a specific usage
  |> MetadataSP.certificate({:signing, cert})
  |> MetadataSP.certificate({:encryption, cert})
  |> MetadataSP.sign_requests(true) # optional - false by default
  |> MetadataSP.sign_assertions(true) # optional - false by default
  |> MetadataSP.organization("your org name", "your org display name", "yourorg.url") # optional
  |> MetadataSP.contact(:technical, [name: "name", email: "your@email.com"]) # optional
  |> MetadataSP.contact(:support, [name: "name", email: "your@email.com"]) # optional
  # You can validate the format of your metadata ; optional
  |> MetadataSP.validate()
  # Finally, you can build as XML
  |> MetadataSP.to_xml()
  ```
  """
  alias Xmerl.XmlElement

  @required_keys [:entity_id, :consume_url]

  @spec entity_id(Map.t(), binary()) :: Map.t()
  def entity_id(metadata, entity_id) do
    Map.put(metadata, :entity_id, entity_id)
  end

  @spec consume_url(Map.t(), binary()) :: Map.t()
  def consume_url(metadata, consume_url) do
    Map.put(metadata, :consume_url, consume_url)
  end

  @spec logout_url(Map.t(), binary()) :: Map.t()
  def logout_url(metadata, logout_url) do
    Map.put(metadata, :logout_url, logout_url)
  end

  @spec nameid_format(Map.t(), binary()) :: Map.t()
  def nameid_format(metadata, nameid_format) do
    Map.put(metadata, :nameid_format, nameid_format)
  end

  @spec sign_requests(Map.t(), binary()) :: Map.t()
  def sign_requests(metadata, sign_requests) do
    Map.put(metadata, :sign_requests, sign_requests)
  end

  @spec sign_assertions(Map.t(), binary()) :: Map.t()
  def sign_assertions(metadata, sign_assertions) do
    Map.put(metadata, :sign_assertions, sign_assertions)
  end

  @spec organization(Map.t(), binary(), binary(), binary()) :: Map.t()
  def organization(metadata, name, display_name, url)
      when is_binary(name) and is_binary(display_name) and is_binary(url) do
    Map.put(metadata, :organization, %{name: name, display_name: display_name, url: url})
  end

  @doc """
  Add a new contact to metadata. You can add multiple contacts

  $contact values:
  - name: Optional string element that specifies the name of the contact person.
  - email: Zero or more elements containing mailto: URIs representing e-mail addresses belonging to contact person.
  - phone_number: Zero or more string elements specifying a telephone number of the contact person.
  - company: Optional string that specifies the company of the contact person.
  """
  @spec contact(Map.t(), atom(), Keyword.t()) :: Map.t()
  def contact(metadata, type, contact)
      when type in [:technical, :support, :administrative, :billing, :other] do
    contacts = [{type, build_contact(contact)} | Map.get(metadata, :contacts, [])]
    Map.put(metadata, :contacts, contacts)
  end

  @spec certificate(Map.t(), binary()) :: Map.t()
  def certificate(metadata, certificate) do
    certs = [certificate | Map.get(metadata, :certificates, [])]
    Map.put(metadata, :certificates, certs)
  end

  @spec validate(Map.t()) :: Map.t() | {:error, RuntimeError.t()}
  def validate(metadata) do
    with :ok <- has_required_keys(metadata) do
      metadata
    else
      {:error, "missing keys" <> _rest = missing_key_error} ->
        {:error, %RuntimeError{message: missing_key_error}}
    end
  end

  @spec to_xml(Map.t()) :: binary() | {:error, RuntimeError.t()}
  def to_xml(metadata) do
    metadata = {Xmerl.XmlElement, "hello"}

    :xmerl.export([metadata], :xmerl_xml, prolog: '<?xml version=\'1.0\' encoding=\'UTF-8\'?>\n')

    ""
  end

  defp build_contact(contact) do
    Enum.reduce(
      contact,
      %{},
      fn {key, value}, acc ->
        if key in [:name, :email, :phone_number, :company] do
          Map.put(acc, key, value)
        else
          acc
        end
      end
    )
  end

  defp has_required_keys(metadata) do
    case Enum.filter(@required_keys, fn k -> Map.has_key?(metadata, k) == false end) do
      [] ->
        :ok

      missing_keys ->
        {:error, "missing keys: " <> Enum.join(missing_keys, ", ")}
    end
  end
end
