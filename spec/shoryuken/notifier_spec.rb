require 'spec_helper'

describe Shoryuken::Notifier do

  it 'has a version number' do
    expect(Shoryuken::Notifier::VERSION).not_to be nil
  end

  it 'calls Shoryuken.configure_server when .register is called' do
    expect(Shoryuken).to receive(:configure_server)
    subject.register
  end

  xit 'adds middleware hook' do
    expect(Shoryuken.logger).to receive(:debug)
    # subject.register
  end

  context 'when a worker performs' do

    let(:queue) { 'default' }
    let(:sqs_queue) { double Shoryuken::Queue, visibility_timeout: 60 }

    let(:sqs_msg) do
      double Shoryuken::Message,
        queue_url: queue,
        body: 'test',
        message_id: 'fc754df7-9cc2-4c41-96ca-5996a44b771e'
    end

    before do
      allow(Shoryuken::Client).to receive(:queues).with(queue).and_return(sqs_queue)
    end

    it 'calls honeybadger context' do
      expect(Honeybadger).to receive(:context).with(worker: TestWorker, queue: queue, sqs_message: sqs_msg, body: sqs_msg.body)

      expect {
        subject::Hook.new.call(TestWorker.new, queue, sqs_msg, sqs_msg.body) { raise 'Error' }
      }.to raise_error(RuntimeError, 'Error')
    end

    it 'calls honeybadger notify' do
      expect(Honeybadger).to receive(:context).with(worker: TestWorker, queue: queue, sqs_message: sqs_msg, body: sqs_msg.body)
      expect(Honeybadger).to receive(:notify)

      expect {
        subject::Hook.new.call(TestWorker.new, queue, sqs_msg, sqs_msg.body) { raise 'Error' }
      }.to raise_error(RuntimeError, 'Error')
    end
  end
end
