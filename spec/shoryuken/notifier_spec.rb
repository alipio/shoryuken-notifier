require 'spec_helper'

describe Shoryuken::Notifier do
  it 'has a version number' do
    expect(Shoryuken::Notifier::VERSION).not_to be nil
  end

  it 'calls Shoryuken.configure_server when .register is called' do
    expect(Shoryuken).to receive(:configure_server)
    described_class.register
  end

  it 'calls Shoryuken.server_middleware when .register is called' do
    expect(Shoryuken::Middleware::Chain).to receive(:add)
    described_class.register
  end
end
