require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
  index_page = Nokogiri::HTML(open(index_url))
  index_page.css(".roster-cards-container .student-card").map{
    |student_card|
    my_hash={}
    my_hash[:name] = student_card.css(".student-name").text
    my_hash[:location] = student_card.css(".student-location").text
    my_hash[:profile_url] = student_card.css("a").attr("href").value
    my_hash
  }
  
  
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
       student_hash = {}
       student_hash = {
      :bio => doc.css("div.bio-block p").text,
      :profile_quote => doc.css("div.profile-quote").text,
    }
    doc.css(".social-icon-container a").each {
      |element|
      link=element.attr("href")
      domain = link.split("/")[2]
      case domain
      when "github.com"
        student_hash[:github] = link
      when "twitter.com"
        student_hash[:twitter] = link
      when "www.linkedin.com"
        student_hash[:linkedin] = link
      else
        student_hash[:blog] = link
      end
    }
    
    
    student_hash
  end

end

