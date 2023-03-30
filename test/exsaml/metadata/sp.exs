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
      assert %{organization: [name: "org name"]} = MetadataSP.organization(%{}, name: "org name")
    end

    test "it add contact" do
      assert %{contacts: [{:technical, [name: "technical name"]}]} =
               MetadataSP.contact(%{}, :technical, name: "technical name")
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
        |> MetadataSP.contact(:technical, name: "technical name", email: "technical@email.com")

      assert metadata == %{
               contacts: [
                 technical: [name: "technical name", email: "technical@email.com"],
                 support: [name: "support name", email: "support@email.com"]
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
end
