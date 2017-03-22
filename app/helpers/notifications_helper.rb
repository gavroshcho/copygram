module NotificationsHelper
  def create_notification_link(notification)
    if notification.notice_type == "comment"
     link_to "#{notification.notified_by.user_name} has #{notification.notice_type}ed on your post", link_through_path(notification)
    else
     link_to "#{notification.notified_by.user_name} has #{notification.notice_type}d on your post", link_through_path(notification)
    end
  end
end
