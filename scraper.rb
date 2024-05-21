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
      selector: 'span .price-update'
    },
    pa: {
      query: 'https://www.supermarchepa.com/search?q=',
      selector: 'div .grid-product-price'
    },
    provigo: {
      query: 'https://www.provigo.ca/search?search-bar=',
      selector: '.price__value .selling-price-list__item__price .selling-price-list__item__price--sale__value'
    }
  }
  puts 'Creating new browser instance'
  browser = Watir::Browser.new
  url = "#{stores_queries.dig(:pa, :query)}#{term}"
  puts "Navigating to #{url}"
  browser.goto(url)
  puts "Waiting for page to load selector #{stores_queries.dig(:pa, :selector)}"
  js_doc = browser.element(css: stores_queries.dig(:pa, :selector)).wait_until(&:present?)
  puts 'Printing content parsed by Nokogiri'
  p content = Nokogiri::HTML(js_doc.inner_html)
  puts 'Returning results'
  return content.class
end

puts fetch_prices('chicken')
