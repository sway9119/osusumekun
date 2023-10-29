require 'net/http'
require 'uri'
require 'json'
require 'nokogiri'
require 'open-uri'

LINE_USER = ENV['LINE_USER']
LINE_CHANNEL_ACCESS_TOKEN = ENV['LINE_CHANNEL_ACCESS_TOKEN']

def lambda_handler(event)
  # 日替わりセールの情報を取得
  books = fetch_amazon_sale_books

  # LINEへのPUSHメッセージ作成
  resmessage = create_books_message(books)

  # LINEへメッセージを送信
  push_line_message(resmessage)
end

private

def fetch_amazon_sale_books
  # スクレイピング対象のURL
  url = 'https://yapi.ta2o.net/kndlsl/'

  # URLからHTMLを取得
  html = URI.open(url, 'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36').read

  # Nokogiriを使用してHTMLをパース
  doc = Nokogiri::HTML(html)

  # 日替わりセールの情報を取得
  books = doc.css('.book-list li')

  # 本の情報をパースする
  parse_books_from_html(books)
end

def parse_books_from_html(books_html)
  result = []
  books_html.each do |book|
    title = book.at('a').text.strip
    price = book.at('span').text.strip
    link = book.at('a')['href']
    result << { title: title, price: price, link: link }
  end
  result
end

def create_books_message(books)
  text = ''
  books.each do |book|
    textline = "#{book[:title]}\n#{book[:price]}\n#{book[:link]}\n"
    separator = "---------------------------------\n"
    text << textline << separator
  end

  [{ type: 'text', text: text }]
end

def push_line_message(resmessage)
  payload = { 'to' => LINE_USER, 'messages' => resmessage }
  # カスタムヘッダーの生成(hash形式)
  headers = { 'Content-Type' => 'application/json', 'Authorization' => "Bearer #{LINE_CHANNEL_ACCESS_TOKEN}"}

  # URIを作成
  uri = URI.parse('https://api.line.me/v2/bot/message/push')

  # HTTPリクエストを生成
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true

  request = Net::HTTP::Post.new(uri.path, headers)
  request.body = JSON.generate(payload)

  # リクエストを送信
  response = http.request(request)

  puts "LINEレスポンス: #{response.body}"
end
