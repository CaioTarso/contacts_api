class ContactsController < ApplicationController
  before_action :authorize!

  def index
    render json: current_user.contacts.map { |contact| serialize_contact(contact) }
  end

  def create
    contact = current_user.contacts.new(contact_params)
    attach_profile_picture(contact)
    contact.save

    render json: serialize_contact(contact)
  end

  def update
    contact = current_user.contacts.find(params[:id])
    contact.update(contact_params)
    attach_profile_picture(contact)

    render json: serialize_contact(contact)
  end

  def destroy
    contact = current_user.contacts.find(params[:id])
    contact.destroy

    render json: { message: "Deleted" }
  end

  private

  def contact_params
    params.permit(:name, :phone, :profile_picture_url)
  end

  def attach_profile_picture(contact)
    return unless params[:profile_picture].present?

    contact.profile_picture.attach(params[:profile_picture])
  end

  def serialize_contact(contact)
    contact.as_json.merge("profile_picture_url" => contact.profile_picture_url)
  end
end
