require "test_helper"
require "tempfile"

class ContactsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @contact = contacts(:one)
    @headers = { "Authorization" => "Bearer #{JsonWebToken.encode(user_id: @user.id)}" }
  end

  test "creates contact with uploaded profile picture" do
    assert_difference("Contact.count", 1) do
      post contacts_url,
        params: {
          name: "Maria",
          phone: "85999990000",
          profile_picture: uploaded_profile_picture
        },
        headers: @headers
    end

    assert_response :success

    contact = Contact.order(:id).last
    body = JSON.parse(response.body)
    assert contact.profile_picture.attached?
    assert_match %r{\A/rails/active_storage/blobs/}, body["profile_picture_url"]
  end

  test "updates contact profile picture url" do
    patch contact_url(@contact),
      params: {
        profile_picture: uploaded_profile_picture("new-photo.jpg")
      },
      headers: @headers

    assert_response :success
    assert @contact.reload.profile_picture.attached?
    assert_match %r{\A/rails/active_storage/blobs/}, JSON.parse(response.body)["profile_picture_url"]
  end

  private

  def uploaded_profile_picture(filename = "avatar.png")
    file = Tempfile.new([File.basename(filename, ".*"), File.extname(filename)])
    file.binmode
    file.write("fake image content")
    file.rewind

    Rack::Test::UploadedFile.new(file.path, "image/png", original_filename: filename)
  end
end
