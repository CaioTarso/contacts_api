class Contact < ApplicationRecord
  belongs_to :user
  has_one_attached :profile_picture

  def profile_picture_url
    return Rails.application.routes.url_helpers.rails_blob_path(profile_picture, only_path: true) if profile_picture.attached?

    self[:profile_picture_url]
  end
end
