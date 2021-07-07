require 'open-uri'
require 'pry'
require 'Nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    page = Nokogiri::HTML(open(index_url))
    page.map{ |student_card|
      my_hash={}
      my_hash [:name] = student_card.css(".student-name").text
      my_hash [:location] = student_card.css(".student-location").text
      my_hash [:profile_url] = student_card.css("a").attr("href").value
      my_hash
    }

  end

  def self.scrape_profile_page(profile_url)

  end

end

#Scraper.scrape_index_page('./fixtures/student-site/index.html')
