require "open-uri"
require "nokogiri"

require_relative "lib/worker"
require_relative "lib/processor"

class TitleExtractorWorker
  include LateralKick::Worker

  def perform(url)
    document = Nokogiri::HTML(open(url))
    title = document.css("html > head > title").first.content
    p "[#{Thread.current.name}] #{title.gsub(/[[:space:]]+/, " ").strip}"
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

LateralKick.backend = Queue.new
LateralKick::Processor.start(4)

RUBYMAGIC.each do |url|
  TitleExtractorWorker.perform_async(url)
end

loop { sleep 1 }
