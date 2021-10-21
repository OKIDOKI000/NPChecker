class Product < ApplicationRecord
  validates :name, presence: true
  validates :entry_time, presence: true

  def self.np_check
    # ログファイル名に入れる現在日時を取得し、文字列に変換。
    ds = Time.current.strftime('%Y%m%d%H%M%S')
    # entry_timeに入れる現在日時を取得し、文字列に変換。なぜかTime.currentでは正しい日時を取得できなかった。
    @et = Time.zone.now.strftime('%Y/%m/%d %H:%M:%S')
    # ランダム時間待機用の変数を定義
    random = Random.new
    # ログオブジェクトを生成。'w'は同名ファイルがあれば上書き。'a'は指定ファイルに追記。
    @il_log = Logger.new('log/' + 'item_check_' + ds + '.log')
    # スクレイピング対象URL（未加工）を指定
    raw_top_url = 'https://ranking.rakuten.co.jp/daily/565950/p='

    # Mechanizeの初期設定を実行。Mechanizeクラスのオブジェクトを作成。
    agent = Mechanize.new
    # 保持する履歴の最大数を指定。「0」だとリファラー周りで不都合があるが、大きいとメモリ容量を取るため、「2」辺りが妥当。
    agent.max_history = 2
    # HTTPリクエストのヘッダーに偽装User-Agentを設定。指定文言以外だとMechanizeの情報が送信されてしまうため注意。
    agent.user_agent_alias = 'Windows Mozilla'
    # キャッシュに存在するページへの再アクセス時に更新チェックを行うかどうかを設定。true：変更が無ければキャッシュを再利用。
    agent.conditional_requests = false

    # ページ番号ごとに処理開始
    (1..2).each do |num| # FIXME: ループ値は適宜変更
      # トップページを読み込み
      # サンプル文字列 https://ranking.rakuten.co.jp/daily/565950/p=1/
      top_url = raw_top_url + num.to_s + "/"
      # テスト用コード
      #top_url = 'https://ranking.rakuten.co.jp/daily/565950/p=1'
      #top_url = '/app/assets/test/scraping_test.html' # FIXME: テスト用コード
      #@il_log.debug "■■■top_url: #{top_url}"
      # MechanizeにてURLからHTMLを取得し、パースを阻害するJavascript関連のタグを削除。
      html = agent.get(top_url).body.gsub!(/<script.*?>/, "").gsub!(/<\/script>/, "")
      #html = URI.open(top_url).read.gsub!(/<script.*?>/, "").gsub!(/<\/script>/, "") # FIXME: テスト用コード
      #puts html
      sleep(random.rand(2.0)+10) # FIXME: ループ稼働時には有効にする
      begin
        # ページを読み込み、アイテム名を配列として取得する。
        @top_page = Nokogiri::HTML.parse(html, nil, 'utf-8')
        # 別メソッドで新商品をチェック
        #check_items
        # 商品情報を取得し、DB未登録ならば登録。
        item_list = @top_page.xpath('//div[@class="rnkRanking_itemName"]').map do |c|
          iname = c.css('a').text
          # DB登録済みの商品名ならば後続処理をスキップ
          next if Product.exists?(name: iname)
          np = Product.new
          np.name = iname
          # 4位～80位の場合、順位情報を取得。
          raw_rank = c.xpath('./../../../../../preceding-sibling::div[@class="rnkRanking_rank"]/div/div[@class="rnkRanking_dispRank"]').text
          # 1位～3位のためブランクデータになっているかチェックし、そうならば別処理で順位情報を取得。
          if raw_rank.blank?
            raw_rank = c.xpath('./../../../../../preceding-sibling::div[@class="rnkRanking_rank"]/div/div[@class="rnkRanking_rankIcon"]/img/@alt').text
          end
          # 100位以下のためブランクデータになっているかチェックし、そうならば別処理で順位情報を取得。
          if raw_rank.blank?
            raw_rank = c.xpath('./../../../../../preceding-sibling::div[@class="rnkRanking_rank"]/div/div[@class="rnkRanking_dispRank_overHundred"]').text
          end
          # 順位情報から「位」の文字を削除
          np.rank = raw_rank.delete!('位')
          np.price = c.xpath('./../../../../following-sibling::div[1]/div[@class="rnk_fixedRightBox"]/div[@class="rnkRanking_price"]').text.delete!(',円')
          np.entry_time = @et
          np.link = c.at_css('a').attribute('href').text
          np.save
        end
        @il_log.debug "■■■item_list: #{item_list}"
      rescue => e
        @il_log.debug "■■■エラー発生: アイテムリスト取得"
        @il_log.debug "■■■エラー内容: #{e.message}"
      end
    end
  end

end
