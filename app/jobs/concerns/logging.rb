module Logging
  extend ActiveSupport::Concern

  def time_usage(from, to = Time.now)
    parts = ActiveSupport::Duration.build(to - Time.at(from)).parts
    %i[hours minutes seconds].map { |unit|
      next unless parts[unit]  # 0 の単位はスキップ
      "#{parts[unit].round(2)}#{unit.to_s.first}"
    }.compact.join(' ')
  end

  def memory_usage
    "%.1fMB" % [`ps -o rss= -p #{$$}`.to_f / 1024]
  end
end
