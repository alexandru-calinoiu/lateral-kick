require "open-uri"
require "nokogiri"

require_relative "lib/worker"

class TitleExtractorWorker
  include LateralKick::Worker

  def perform(url)
    document = Nokogiri::HTML(open(url))
    title = document.css("html > head > title").first.content
    p title.gsub(/[[:space:]]+/, "")
  rescue
    p "Unable to find a title for #{url}"
  end
end

TitleExtractorWorker.perform_now("https://archlinux.org")
