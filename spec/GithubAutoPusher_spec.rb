RSpec.describe GithubAutoPusher do
  it "has a version number" do
    expect(GithubAutoPusher::VERSION).not_to be nil
  end

  describe "#update_repo" do
    it "runs #git_add, #git_commit, and #git_push" do
      # gh_auto_pusher = GithubAutoPusher.new
      gh_auto_pusher = GithubAutoPusher.new
      # allow(gh_auto_pusher).to receive(:git_add)
      allow(gh_auto_pusher).to receive(:git_commit)
      allow(gh_auto_pusher).to receive(:git_push)
      allow(gh_auto_pusher).to receive(:update_repo).and_call_original

      gh_auto_pusher.update_repo
      
      expect(gh_auto_pusher).to have_received(:git_add).once
      expect(gh_auto_pusher).to have_received(:git_commit).once
      expect(gh_auto_pusher).to have_received(:git_push).once
    end
  end
end

