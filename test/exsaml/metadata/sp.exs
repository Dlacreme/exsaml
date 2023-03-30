defmodule Exsaml.Metadata.SPTest do
  use ExUnit.Case

  alias Exsaml.Metadata.SP, as: MetadataSP

  describe "build metadata" do
    test "it add entity_id" do
      assert %{entity_id: "myentityid"} = MetadataSP.entity_id(%{}, "myentityid")
    end

    test "it add consume_url" do
      assert %{consume_url: "http://consume.url"} =
               MetadataSP.consume_url(%{}, "http://consume.url")
    end

    test "it add logout_url" do
      assert %{logout_url: "http://logout.url"} = MetadataSP.logout_url(%{}, "http://logout.url")
    end

    test "it add nameid_format" do
      assert %{nameid_format: "nameidformat"} = MetadataSP.nameid_format(%{}, "nameidformat")
    end

    test "it add sign_requests" do
      assert %{sign_requests: "signrequests"} = MetadataSP.sign_requests(%{}, "signrequests")
    end

    test "it add sign_assertions" do
      assert %{sign_assertions: "signassertions"} =
               MetadataSP.sign_assertions(%{}, "signassertions")
    end

    test "it add organization" do
      assert %{
               organization: %{
                 name: "org name",
                 display_name: "org display name",
                 url: "http://org.url"
               }
             } = MetadataSP.organization(%{}, "org name", "org display name", "http://org.url")
    end

    test "it add contact" do
      assert %{
               contacts: [{:technical, %{name: "technical name", email: "technical@email.com"}}]
             } =
               MetadataSP.contact(%{}, :technical,
                 name: "technical name",
                 email: "technical@email.com"
               )
    end

    test "it add certificate" do
      assert %{certificates: ["certificate"]} = MetadataSP.certificate(%{}, "certificate")
    end
  end

  describe "build complex metadata" do
    test "it build multiple contacts" do
      metadata =
        %{}
        |> MetadataSP.contact(:support, name: "support name", email: "support@email.com")
        |> MetadataSP.contact(:technical, company: "technical company", phone_number: "00000000")

      assert metadata == %{
               contacts: [
                 technical: %{company: "technical company", phone_number: "00000000"},
                 support: %{name: "support name", email: "support@email.com"}
               ]
             }
    end

    test "it build multiple certificates" do
      metadata =
        %{}
        |> MetadataSP.certificate("coolcertificate")
        |> MetadataSP.certificate({:signing, "signing certificate"})
        |> MetadataSP.certificate({:encryption, "encryption certificate"})

      assert metadata == %{
               certificates: [
                 {:encryption, "encryption certificate"},
                 {:signing, "signing certificate"},
                 "coolcertificate"
               ]
             }
    end
  end

  describe "it validates metadata" do
    test "it says 'ok' with valid metadata" do
      metadata =
        %{}
        |> MetadataSP.entity_id("my.entityid.com")
        |> MetadataSP.consume_url("http://consume.url")
        |> MetadataSP.logout_url("http://logout.url")
        |> MetadataSP.nameid_format(~s(urn:oasis:names:tc:SAML:2.0:nameid-format:transient))
        |> MetadataSP.certificate("cool cert")
        |> MetadataSP.certificate({:signing, "signing cert"})
        |> MetadataSP.certificate({:encryption, "encryption cert"})
        |> MetadataSP.sign_requests(true)
        |> MetadataSP.sign_assertions(true)
        |> MetadataSP.organization(
          "your org name",
          "your org display name",
          "yourorg.url"
        )
        |> MetadataSP.contact(:technical, name: "name", email: "your@email.com")

      assert MetadataSP.validate(metadata) ==
               %{
                 certificates: [
                   {:encryption, "encryption cert"},
                   {:signing, "signing cert"},
                   "cool cert"
                 ],
                 consume_url: "http://consume.url",
                 contacts: [
                   technical: %{name: "name", email: "your@email.com"}
                 ],
                 entity_id: "my.entityid.com",
                 logout_url: "http://logout.url",
                 nameid_format: "urn:oasis:names:tc:SAML:2.0:nameid-format:transient",
                 organization: %{
                   name: "your org name",
                   display_name: "your org display name",
                   url: "yourorg.url"
                 },
                 sign_assertions: true,
                 sign_requests: true
               }
    end

    test "returns a RuntimeError when a required key is missing" do
      assert {:error, %RuntimeError{message: "missing keys: entity_id, consume_url"}} ==
               MetadataSP.validate(%{})

      assert {:error, %RuntimeError{message: "missing keys: consume_url"}} ==
               MetadataSP.validate(%{entity_id: "entityid"})

      assert {:error, %RuntimeError{message: "missing keys: entity_id"}} ==
               MetadataSP.validate(%{consume_url: "consumr.url"})
    end
  end
end
