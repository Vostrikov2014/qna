class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def destroy
    @attachment = ActiveStorage::Attachment.find(params[:id])
    @attachment.purge
  end
end
