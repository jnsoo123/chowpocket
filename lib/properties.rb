module OrderStatuses
  PENDING   = 'pending'
  DELIVERED = 'delivered'
  CONFIRMED = 'confirmed'
  WAITING   = 'waiting for confirmation'
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
