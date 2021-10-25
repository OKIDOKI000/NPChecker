require 'clockwork'

require File.expand_path('../boot', __FILE__)
require File.expand_path('../environment', __FILE__)

module Clockwork
  handler do |job|
    # 新商品の情報をECサイトでチェックしDB登録
    Product.np_check
    # DBから新商品情報を取得
    nps = Product.where("entry_time like ?", "#{Time.zone.now.strftime('%Y-%m-%d')}%")
    # 新商品が有ればメール送信
    if nps.present?
      users = User.all
      users.each do |user|
        Users::Mailer.notice_np(user, nps).deliver
      end
    end
  end

  # 毎日、指定時間（24時間表記）が来たときにのみ実行。
  every(1.day, 'midnight.job', :at => '13:19')
end

#every(10.seconds, 'frequent.job')
#every(3.minutes, 'less.frequent.job')
#every(1.hour, 'hourly.job')
#every(1.day, 'midnight.job', :at => '00:00')