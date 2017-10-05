class NotificationsController < ApplicationController
  before_action :set_notification, only: :destroy

  def index
    @notifications = current_user.notifications.order(created_at: :desc)
    set_read_notifications
  end

  def destroy
    @notification.destroy
    redirect_to notifications_path, notice: 'Notification Deleted'
  end

  def destroy_all
    @notifications = current_user.notifications
    @notifications.destroy_all
    redirect_to notifications_path, notice: 'Notifications Cleared'
  end

  private
  def set_notification
    @notification = current_user.notifications.find(params[:id])
  end

  def set_read_notifications
    @notifications.update_all(status: NotificationStatuses::READ)
  end
end
