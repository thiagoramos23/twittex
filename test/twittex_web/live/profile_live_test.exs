defmodule TwittexWeb.ProfileLiveTest do
  use TwittexWeb.ConnCase

  import Phoenix.LiveViewTest
  import Twittex.AccountsFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_profile(_) do
    profile = profile_fixture()
    %{profile: profile}
  end

  describe "Index" do
    setup [:create_profile]

    test "lists all profiles", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/profiles")

      assert html =~ "Listing Profiles"
    end

    test "saves new profile", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/profiles")

      assert index_live |> element("a", "New Profile") |> render_click() =~
               "New Profile"

      assert_patch(index_live, ~p"/profiles/new")

      assert index_live
             |> form("#profile-form", profile: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#profile-form", profile: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/profiles")

      html = render(index_live)
      assert html =~ "Profile created successfully"
    end

    test "updates profile in listing", %{conn: conn, profile: profile} do
      {:ok, index_live, _html} = live(conn, ~p"/profiles")

      assert index_live |> element("#profiles-#{profile.id} a", "Edit") |> render_click() =~
               "Edit Profile"

      assert_patch(index_live, ~p"/profiles/#{profile}/edit")

      assert index_live
             |> form("#profile-form", profile: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#profile-form", profile: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/profiles")

      html = render(index_live)
      assert html =~ "Profile updated successfully"
    end

    test "deletes profile in listing", %{conn: conn, profile: profile} do
      {:ok, index_live, _html} = live(conn, ~p"/profiles")

      assert index_live |> element("#profiles-#{profile.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#profiles-#{profile.id}")
    end
  end

  describe "Show" do
    setup [:create_profile]

    test "displays profile", %{conn: conn, profile: profile} do
      {:ok, _show_live, html} = live(conn, ~p"/profiles/#{profile}")

      assert html =~ "Show Profile"
    end

    test "updates profile within modal", %{conn: conn, profile: profile} do
      {:ok, show_live, _html} = live(conn, ~p"/profiles/#{profile}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Profile"

      assert_patch(show_live, ~p"/profiles/#{profile}/show/edit")

      assert show_live
             |> form("#profile-form", profile: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#profile-form", profile: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/profiles/#{profile}")

      html = render(show_live)
      assert html =~ "Profile updated successfully"
    end
  end
end
