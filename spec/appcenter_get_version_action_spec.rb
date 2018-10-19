describe Fastlane::Actions::AppcenterGetVersionAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The appcenter_get_version plugin is working!")

      Fastlane::Actions::AppcenterGetVersionAction.run(nil)
    end
  end
end
