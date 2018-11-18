require 'open-uri'
require 'pry'

class Scraper

#studentArray = {:name ,:location, :profile_url}
  def self.scrape_index_page(index_url)
    html = File.read(index_url)
    index_page = Nokogiri::HTML(html)
    index_page.css(".roster-cards-container .student-card").map {|student_card|
      student_hash = {}
      student_hash[:name] = student_card.css(".student-name").text
      student_hash[:location] = student_card.css(".student-location").text
      # student_hash[:profile_url] = student_card.css("a").map {|link| link["href"]}[0]
      student_hash[:profile_url] = student_card.css("a").attr("href").value
      student_hash
    }
  end

  def self.scrape_profile_page(profile_url)
       doc = Nokogiri::HTML(open(profile_url))
       student_hash = {}
       student_hash = {
      :bio => doc.css("div.bio-block p").text,
      :profile_quote => doc.css("div.profile-quote").text,
    }
    doc.css(".social-icon-container a").each {|a|
    
      link = a.attr("href")
      splitLink = link.split("/")[2]
      #binding.pry
      case splitLink
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
    #binding.pry 
  end

end

