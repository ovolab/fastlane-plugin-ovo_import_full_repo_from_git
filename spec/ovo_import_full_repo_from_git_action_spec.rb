describe Fastlane::Actions::OvoImportFullRepoFromGitAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The ovo_import_full_repo_from_git plugin is working!")

      Fastlane::Actions::OvoImportFullRepoFromGitAction.run(nil)
    end
  end
end
