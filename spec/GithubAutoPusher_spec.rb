class MockDir
  def initialize(entries: [])
    @entries = entries
  end
  def entries(some_dir)
    @entries
  end
end

RSpec.describe GithubAutoPusher do
  it "has a version number" do
    expect(GithubAutoPusher::VERSION).not_to be nil
  end

  describe "#update_repo" do
    it "runs #git_add, #git_commit, and #git_push" do
      gh_auto_pusher = GithubAutoPusher.new(wait: ->(x) {})
      allow(gh_auto_pusher).to receive(:git_add)
      allow(gh_auto_pusher).to receive(:git_commit)
      allow(gh_auto_pusher).to receive(:git_push)
      allow(gh_auto_pusher).to receive(:update_repo).and_call_original

      gh_auto_pusher.update_repo
      
      expect(gh_auto_pusher).to have_received(:git_add).once
      expect(gh_auto_pusher).to have_received(:git_commit).once
      expect(gh_auto_pusher).to have_received(:git_push).once
    end
  end

  describe "#run_loop" do
    context "a time interval is passed in the constructor" do
      it "runs at the provided interval" do
        fail "TODO"
      end
    end

    context "a time interval is not passed in the constructor" do
      it "runs at the default interval" do
        fail "TODO"
      end
    end
  end

  describe "#in_git_repo?" do
    it "returns true when inside a git repo" do
      dir_mock = MockDir.new(entries: ['..', '.git', '.'])
      gh_auto_pusher = GithubAutoPusher.new(filesystem: dir_mock)
      expect(gh_auto_pusher.in_git_repo?).to be true
    end

    it "returns false when outside a git repo" do
      dir_mock = MockDir.new(entries: ['..', '.gity', '.'])
      gh_auto_pusher = GithubAutoPusher.new(filesystem: dir_mock)
      expect(gh_auto_pusher.in_git_repo?).to be false
    end
  end
end

