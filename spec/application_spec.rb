# frozen_string_literal: true

require_relative '../application'

describe Application do
  let(:app) { Application.new }

  subject { get url }

  context 'GET /time' do
    let(:url) { '/time' }

    context 'when query is not present' do
      it { expect(subject.status).to eq 200 }
      it { expect(subject.body).to eq '' }
    end

    context 'when query is present' do
      let(:url) { '/time?format=year,month,day,hour,minute,second' }

      it { expect(subject.status).to eq 200 }
      it { expect(subject.body).to eq Time.now.strftime('%Y-%m-%d-%H-%M-%S') }
    end

    context 'when query is invalid' do
      let(:invalid_query_param) { 'qwerty' }
      let(:url) { "/time?format=#{invalid_query_param}" }

      it { expect(subject.status).to eq 400 }
      it { expect(subject.body).to eq "Unknown time format: [\"#{invalid_query_param}\"]" }
    end
  end

  context 'GET /some_unknown_url' do
    let(:url) { '/some_unknown_url' }

    it { expect(subject.status).to eq 404 }
    it { expect(subject.body).to eq "Resource not found: #{url}" }
  end
end
