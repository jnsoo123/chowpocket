module OrderStatuses
  PENDING   = 'pending'
  CONFIRMED = 'confirmed'
  WAITING   = 'waiting for confirmation'
  CANCELLED = 'cancelled'

  ALL       = [PENDING, CONFIRMED, WAITING]
end

module NotificationTypes
  ORDER = 'order'
end

module NotificationStatuses
  UNREAD = 'unread'
  READ   = 'read'
end

module ScheduleDays
  ALL = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday'
  ]
end

module OrderSettings
  MINIMUM_ORDER = 0
end
