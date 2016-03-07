module Admin::Views::Users
  class List
    include Admin::View


    def good_date(date_time)
      week_day = { 1 => 'Monday', 2 => 'Tuesday', 3 => 'Wednesday', 4 => 'Thursday', 5 => 'Friday', 6 => 'Saturday', 7 => 'Sunday' }
      if date_time
        hour = date_time.hour
        wday = date_time.wday
        if hour < 5
          wday = wday - 1
          if wday < 1
            wday = 7
          end
        end
        hour = hour - 5
        hour = hour + 24 if hour < 0
        "#{week_day[wday]} #{hour}:#{date_time.minute}"
      else '-'
      end
    end

  end
end
