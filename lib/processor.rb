module LateralKick
  class Processor
    def self.start(concurency = 1)
      concurency.times { |n| new("Processor #{n}") }
    end

    def initialize(name)
      thread = Thread.new do
        loop do
          payload = LateralKick.backend.pop
          worker_class = payload[:worker]
          worker_class.new.perform(*payload[:args])
        end
      end

      thread.name = name
    end
  end
end
