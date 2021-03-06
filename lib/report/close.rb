# frozen_string_literal: true

# Close Show methods for Report class.
class Report
  def close
    app = Application.instance
    max = 0.0
    good = 0.0
    fail = 0.0
    fail_counter = 0
    @lines.each do |i|
      if i.class.to_s == 'Hash'
        max += i[:weight] if i[:weight].positive?
        if i[:check]
          good += i[:weight]
          @history += app.letter[:good]
        else
          fail += i[:weight]
          fail_counter += 1
          @history += app.letter[:bad]
        end
      end
    end
    @tail[:max_weight] = max
    @tail[:good_weight] = good
    @tail[:fail_weight] = fail
    @tail[:fail_counter] = fail_counter

    i = good.to_f / max.to_f
    i = 0 if i.nan?
    @tail[:grade] = (100.0 * i).round
    @tail[:grade] = 0 if @tail[:unique_fault].positive?
  end
end
