module OrdersHelper
  def get_date_cycle_for_scopes
    date = DateTime.now < DateTime.now.change({hour: 19}) ? Date.today : Date.today + 1
    date = date.to_datetime
    option = case
             when date.friday?
               {created_at_gteq_datetime: (date-1.day).change({hour: 19}), created_at_lteq_datetime: (date+2.days).change({hour: 19})}
             when date.saturday?
               {created_at_gteq_datetime: (date-2.days).change({hour: 19}), created_at_lteq_datetime: (date+1.days).change({hour: 19})}
             when date.sunday?
               {created_at_gteq_datetime: (date-3.days).change({hour: 19}), created_at_lteq_datetime: (date).change({hour: 19})}
             else
               {created_at_gteq_datetime: (date-1.day).change({hour: 19}), created_at_lteq_datetime: (date).change({hour: 19})}
             end
    option
  end

  def get_date_cycle
    date = DateTime.now < DateTime.now.change({hour: 19}) ? Date.today : Date.today + 1
    date = date - 1.day if date.saturday?
    date = date - 2.day if date.sunday?
    date
  end

  def get_datetime_cycle
    date = DateTime.now < DateTime.now.change({hour: 19}) ? Date.today - 1 : Date.today
    date = date - 1.day if date.saturday?
    date.to_datetime.in_time_zone.change({hour: 19})
  end

  def get_datetime_cycle_next_day
    date = DateTime.now < DateTime.now.change({hour: 19}) ? Date.today - 1 : Date.today
    date = date + 1.day
    date = if date.saturday?
             date + 1.day
           else 
             date
           end
    date.to_datetime.in_time_zone.change({hour: 19})
  end

  def get_delivery_day
    date = get_datetime_cycle_next_day + 1.day
    date = case 
           when date.saturday?
             date + 2.days
           when date.sunday?
             date + 1.day
           else
             date
           end
    date.strftime('%A')
  end
end
