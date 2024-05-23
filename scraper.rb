# require 'open-uri'
require 'watir'
require 'nokogiri'

def fetch_prices(term)
  stores_queries = {
    iga: {
      query: 'https://www.iga.net/en/search?k=',
      selector: '.price'
    },
    metro: {
      query: 'https://www.metro.ca/en/online-grocery/search?filter=',
      selector: '.price-update'
    },
    pa: {
      query: 'https://www.supermarchepa.com/search?q=',
      selector: '.grid-product-price'
    },
    provigo: {
      query: 'https://www.provigo.ca/search?search-bar=',
      selector: '.selling-price-list__item__price--now-price__value'
    }
  }
  stores_queries.each_key do |key|
    puts 'Creating new browser instance'
    browser = Watir::Browser.new
    url = "#{stores_queries.dig(key, :query)}#{term}"
    puts "Navigating to #{url}"
    browser.goto(url)
    selector = stores_queries.dig(key, :selector)
    puts "Waiting for page to load selector '#{selector}'"
    begin
      js_doc = browser.element(css: selector).wait_until(&:present?)
      puts "Printing content parsed by Nokogiri for term '#{term}'"
      re = /\d+[.,]\d{2}/
      p re.match(Nokogiri::HTML(js_doc.inner_html).text)
    rescue StandardError => e
      puts e
    end
    puts 'Closing browser instance'
  end
end

fetch_prices('chocolate')
