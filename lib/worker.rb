module LateralKick
  module Worker
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def perform_async(*args)
        LateralKick.backend.push(worker: self, args: args)
      end

      def perform_now(*args)
        new.perform(*args)
      end
    end

    def perform(*)
      raise NotImplementedError
    end
  end

  def self.backend
    @backend
  end

  def self.backend=(backend)
    @backend = backend
  end
end
