require 'open-uri'
require 'nokogiri' ##standard to include both of these in order to do this scraping
require 'pry'


class Scraper

  def self.scrape_index_page(index_url)

    doc = Nokogiri::HTML(open(index_url))

    doc.css("div.student-card").map do |student|      
      student_hash = {
        name: student.css('h4.student-name').text,
        location: student.css('p.student-location').text,
        profile_url: student.css("a").attr('href').value        
      }
    end
    
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))    
    profile_hash = {
      bio: doc.css(".description-holder p").text,
      profile_quote: doc.css(".profile-quote").text
    }       
   
    social_array = doc.css(".social-icon-container a")
    self.parse_socials(profile_hash, social_array)
  end

  def self.parse_socials(profile_hash, social_array)
    social_array.each do |noko_el|
      link = noko_el.attr("href")
      if link.include?("twitter")
        profile_hash[:twitter] = link
      elsif link.include?("facebook")
        profile_hash[:facebook] = link
      elsif link.include?("github")
        profile_hash[:github] = link
      elsif link.include?("linkedin")
        profile_hash[:linkedin] = link
      else
        profile_hash[:blog] = link
      end 
    end
    profile_hash
  end

end