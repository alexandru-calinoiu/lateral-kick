require 'open-uri'
require 'nokogiri'

class TitleExtractorService
  def call(url)
    document = Nokogiri::HTML(open(url))
    title = document.css('html > head > title').first.content
    p title.gsub(/[[:space:]]+/, '')
  rescue
    p "Unable to find a title for #{url}"
  end
end

TitleExtractorService.new.call('https://archlinux.org')