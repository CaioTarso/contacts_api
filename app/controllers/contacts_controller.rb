class ContactsController < ApplicationController
  before_action :authorize!

  def index
    render json: current_user.contacts
  end

  def create
    contact = current_user.contacts.create(contact_params)
    render json: contact
  end

  def update
    contact = current_user.contacts.find(params[:id])
    contact.update(contact_params)

    render json: contact
  end

  def destroy
    contact = current_user.contacts.find(params[:id])
    contact.destroy

    render json: { message: "Deleted" }
  end

  private

  def contact_params
    params.permit(:name, :phone)
  end
end
