class ProductsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    #現在日時を取得し文字列に変換
    ds = Time.now.strftime("%Y%m%d%H%M%S")
    # ランダム時間待機用の変数を定義
    random = Random.new
    #ログオブジェクトを生成。'w'は同名ファイルがあれば上書き。'a'は指定ファイルに追記。
    il_log = Logger.new('log/' + 'item_list_' + ds + '.log')
    # ダウンロードURL（未加工）を指定
    raw_top_url = 'https://ranking.rakuten.co.jp/daily/565950/p='

    # Mechanizeの初期設定を実行
    # Mechanizeクラスのオブジェクトを作成
    agent = Mechanize.new
    # 保持する履歴の最大数を指定。「0」だとリファラー周りで不都合があるが、大きいとメモリ容量を取るため、「2」辺りが妥当。
    agent.max_history = 2
    # HTTPリクエストのヘッダーに偽装User-Agentを設定。指定文言以外だとMechanizeの情報が送信されてしまうため注意。
    agent.user_agent_alias = 'Windows Mozilla'
    # キャッシュに存在するページへの再アクセス時に更新チェックを行うかどうかを設定。true：変更が無ければキャッシュを再利用。
    agent.conditional_requests = false

    # ページ番号ごとに処理開始
    #(1..2).each do |num| # FIXME: ■■■数値は適宜変更、sleep設定も有効にする■■■
      begin
        # トップページを読み込み
        # サンプル文字列　https://ranking.rakuten.co.jp/daily/565950/p=1/
        #top_url = raw_top_url + num.to_s + "/"
        # テスト用データ
        top_url = 'https://ranking.rakuten.co.jp/daily/565950/p=1/'
        #il_log.debug "■■■top_url: #{top_url}"
        # 必要に応じてリトライ用のカウンタをセット。||= はnilまたはfalseの場合に値を代入する。
        #fc_top ||= 0
        # MechanizeにてURLからHTMLを取得し、パースを阻害するJavascript関連のタグを削除。
        html = agent.get(top_url).body.gsub!(/<script.*?>/, "").gsub!(/<\/script>/, "")
        #puts html
        #sleep(random.rand(2.0)+10)
      rescue => e
        il_log.debug "■■■エラー発生: #{top_url}"
        il_log.debug "■■■エラー内容: #{e.message}"
        #fc_top += 1
        #sleep(random.rand(2.0)+10)
        #retry if fc_top < 5
      end

      begin
        #ページを読み込み、アイテム名を配列として取得する。
        top_page = Nokogiri::HTML.parse(html, nil, 'utf-8')
        #il_log.debug "■■■top_page: #{top_page}"
        item_list = top_page.xpath('//div[@class="rnkRanking_itemName"]').map do |c|
          c.css('a').text
        end
        il_log.debug "■■■item_list: #{item_list}"
      rescue => e
        il_log.debug "■■■エラー発生: アイテムリスト取得"
        il_log.debug "■■■エラー内容: #{e.message}"
        #fc_top += 1
        #sleep(random.rand(2.0)+10)
        #retry if fc_top < 5
      end
      #テスト用データ
      #● = ["http://●.html", "http://●.html"]
    #end

  end

end
