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
    ['To be delivered on Monday', 'Friday'],
    ['To be delivered on Tuesday', 'Monday'],
    ['To be delivered on Wednesday', 'Tuesday'],
    ['To be delivered on Thursday', 'Wednesday'],
    ['To be delivered on Friday', 'Thursday']
  ]

  DISPLAY_VALUE = {
    'Monday' => 'To be delivered on Tuesday',
    'Tuesday' => 'To be delivered on Wednesday',
    'Wednesday' => 'To be delivered on Thursday',
    'Thursday' => 'To be delivered on Friday',
    'Friday' => 'To be delivered on Monday',
  }
end

module OrderSettings
  MINIMUM_ORDER = 0
end
