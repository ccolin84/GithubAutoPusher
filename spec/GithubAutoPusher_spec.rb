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
      it "runs update_repo once in one interval" do
        finished_looping_mock = Proc.new { |num_loops| num_loops > 0 }
        gh_auto_pusher = GithubAutoPusher.new(
          interval: 0.5,
          finished_looping: finished_looping_mock
        )
        allow(gh_auto_pusher).to receive(:git_add)
        allow(gh_auto_pusher).to receive(:git_commit)
        allow(gh_auto_pusher).to receive(:git_push)
        allow(gh_auto_pusher).to receive(:update_repo)

        gh_auto_pusher.run_loop

        expect(gh_auto_pusher).to have_received(:update_repo).once
      end

      it "runs update_repo twice in intervals" do
        finished_looping_mock = Proc.new { |num_loops| num_loops > 1 }
        gh_auto_pusher = GithubAutoPusher.new(
          interval: 0.5,
          finished_looping: finished_looping_mock
        )
        allow(gh_auto_pusher).to receive(:git_add)
        allow(gh_auto_pusher).to receive(:git_commit)
        allow(gh_auto_pusher).to receive(:git_push)
        allow(gh_auto_pusher).to receive(:update_repo)

        gh_auto_pusher.run_loop

        expect(gh_auto_pusher).to have_received(:update_repo).twice
      end

      it "runs at the user provided rate" do
        finished_looping_mock = Proc.new { |num_loops| num_loops > 0 }
        mock_interval = 0.5
        gh_auto_pusher = GithubAutoPusher.new(
          interval: mock_interval,
          finished_looping: finished_looping_mock
        )
        allow(gh_auto_pusher).to receive(:git_add)
        allow(gh_auto_pusher).to receive(:git_commit)
        allow(gh_auto_pusher).to receive(:git_push)
        allow(gh_auto_pusher).to receive(:update_repo)

        start = Time.now
        gh_auto_pusher.run_loop
        finish = Time.now
        duration = finish - start
        delta_duration_vs_interval = (duration - mock_interval).abs
        difference_tolerance = mock_interval* 0.05

        expect(delta_duration_vs_interval).to be < difference_tolerance
        expect(gh_auto_pusher).to have_received(:update_repo).once
      end
    end

    context "a time interval is not passed in the constructor" do
      it "runs at the default interval" do
        finished_looping_mock = Proc.new { |num_loops| num_loops > 0 }
        old_default_update_interval = GithubAutoPusher::DEFAULT_UPDATE_INTERVAL
        GithubAutoPusher::DEFAULT_UPDATE_INTERVAL = 0.5
        gh_auto_pusher = GithubAutoPusher.new(finished_looping: finished_looping_mock)
        allow(gh_auto_pusher).to receive(:git_add)
        allow(gh_auto_pusher).to receive(:git_commit)
        allow(gh_auto_pusher).to receive(:git_push)
        allow(gh_auto_pusher).to receive(:update_repo)

        start = Time.now
        gh_auto_pusher.run_loop
        finish = Time.now
        duration = finish - start
        delta_duration_vs_interval = (duration - GithubAutoPusher::DEFAULT_UPDATE_INTERVAL).abs
        difference_tolerance = GithubAutoPusher::DEFAULT_UPDATE_INTERVAL * 0.05

        expect(delta_duration_vs_interval).to be < difference_tolerance
        expect(gh_auto_pusher).to have_received(:update_repo).once

        GithubAutoPusher::DEFAULT_UPDATE_INTERVAL = old_default_update_interval
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

