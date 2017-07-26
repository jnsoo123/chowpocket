module OrderStatuses
  PENDING   = 'pending'
  DELIVERED = 'delivered'
  CONFIRMED = 'confirmed'
end

module ScheduleDays
  RADIO_ALL = [
    ['1st Monday', '1-1'], 
    ['2nd Monday', '1-2'], 
    ['1st Tuesday', '2-1'], 
    ['2nd Tuesday', '2-2'], 
    ['1st Wednesday', '3-1'], 
    ['2nd Wednesday', '3-2'], 
    ['1st Thursday', '4-1'], 
    ['2nd Thursday', '4-2'], 
    ['1st Friday', '5-1'], 
    ['2nd Friday', '5-2']
  ]
end
