require 'spec_helper'
require 'tempfile'
require 'lib/emerald'

RSpec.describe 'Emerald' do

  let(:stdout) { spy('STDOUT') }
  let(:user_comms) { Emerald::UserCommsHelper.new(stdout) }

  context "given a non-lisp file is passed in" do
    it "returns an error" do
      system( 'ruby ../lib/emerald.rb', 'test-file.lisp')
      expect(user_comms).to have_received(verify_lisp_file)
    end
  end
end
