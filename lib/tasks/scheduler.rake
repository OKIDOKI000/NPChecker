desc "This task is called by the Heroku scheduler add-on"
task :test_scheduler => :environment do
  puts "scheduler test"
  puts "it works."
end

task :daily_check => :environment do
  # 検証用に手動で一部レコードを削除するコマンド　Product.where(id: 151..1000).destroy_all
  # entry_timeに入れる現在日時を取得し、文字列に変換。なぜかTime.currentでは正しい日時を取得できなかった。
  # 加工前の現在時刻を取得
  et_origin = Time.zone.now
  # entry_timeとして入力するために文字列に加工
  et = et_origin.strftime('%Y-%m-%d %H:%M:%S')
  # etがDBに入るとUTC時刻に自動変換されるため、疑似的にUTC時刻に加工。
  # 32400（秒）=60（1分は60秒）*60（1時間は60分）*9（JMT-UTC）
  # なお、Time.parse(et).in_time_zone('UTC')　などは想定どおりには機能しなかった。
  et_utc = (et_origin - 32400).strftime('%Y-%m-%d %H:%M:%S')
  # 新商品の情報をECサイトでチェックしDB登録
  Product.np_check(et)
  # DBから新商品情報を取得
  nps = Product.where(entry_time: et_utc)
  # 新商品が有ればメール送信
  if nps.present?
    users = User.all
    users.each do |user|
      Users::Mailer.notice_np(user, nps).deliver
    end
  end
end
