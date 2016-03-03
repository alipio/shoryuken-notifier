require "shoryuken/notifier/version"

module Shoryuken
  module Notifier
    def self.register
      Shoryuken.configure_server do |config|
        config.server_middleware do |chain|
          Logging.logger.debug "shoryuken.notifier.hook added"
          chain.add Hook
        end
      end
    end

    class Hook
      def call(worker, queue, sqs_msg, body)
        Honeybadger.context(worker: worker.class, queue: queue, sqs_message: sqs_msg, body: body)
        yield
      rescue => e
        Logging.logger.debug "shoryuken.notifier #{e.class}, #{e.message}"
        Honeybadger.notify(e)
        raise e
      end
    end
  end
end

Shoryuken::Notifier.register
