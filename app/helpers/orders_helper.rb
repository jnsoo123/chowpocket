module OrdersHelper
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
end
