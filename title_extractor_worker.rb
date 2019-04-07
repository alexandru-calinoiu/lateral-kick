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

RUBYMAGIC = %w(
  https://blog.appsignal.com/2019/04/02/background-processing-system-in-ruby.html
  https://blog.appsignal.com/2019/02/05/ruby-magic-classes-instances-and-metaclasses.html
  https://blog.appsignal.com/2019/03/05/stringscanner.html
  https://blog.appsignal.com/2019/01/08/ruby-magic-bindings-and-lexical-scope.html
)

RUBYMAGIC.each do |url|
  TitleExtractorWorker.perform_async(url)
end

Thread.list.each do |t|
  t.join if t != Thread.current
end
