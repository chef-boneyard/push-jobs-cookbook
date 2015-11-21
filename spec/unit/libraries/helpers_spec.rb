require 'spec_helper'

describe PushJobsHelper do
  let(:path) { File.expand_path('spec/support') }

  subject do
    described_class
  end

  describe '.version_from_manifest' do
    it 'returns push-jobs version from manifest' do
      expect(subject.version_from_manifest(path)).to eq('1.3.4')
    end
  end
end
