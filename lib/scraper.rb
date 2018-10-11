require 'open-uri'
require 'pry'
require 'nokogiri'
require "pry"
class Scraper

  def self.scrape_index_page(index_url)
    html = open(index_url)
    doc = Nokogiri::HTML(html)
    #binding.pry
    doc.css(".student-card").map do |student|
    #  binding.pry
      {name: student.css(".student-name").text,
        location: student.css(".student-location").text,
        profile_url: student.css("a").attr('href').value
      }
    end
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
  #  binding.pry
    socials_arr = []
      #binding.pry
    socials = doc.css("div.vitals-container a").map {|social| social.values}.flatten
    #binding.pry

    twitter = socials.find {|social|
      social[0...15] == "https://twitter"}


    linkedin = socials.find {|social|
      social[0...20]  == "https://www.linkedin"}

    github = socials.find {|social| social[0...14] == "https://github"}
    # binding.pry
    unless socials[-1] == twitter || socials[-1] == linkedin || socials[-1] == github 
      blog = socials[-1]
    end
    pro_quote = doc.css("div.profile-quote").text
    bio = doc.css("p").text
    #binding.pry


     hash = {
      twitter: twitter,
      linkedin: linkedin,
      github: github,
      blog: blog,
      profile_quote: pro_quote,
      bio: bio
    }.delete_if {|k, v| v == nil}


    #binding.pry

  end

end
