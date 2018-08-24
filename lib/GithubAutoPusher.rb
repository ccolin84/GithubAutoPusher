class GithubAutoPusher
  VERSION = "0.1.0" 
  UPDATE_INTERVAL = 30 * 60 
  DEFAULT_COMMIT_MESSAGE = "scheduled auto commit"

  def initialize(
    filesystem: Dir,
    interval: UPDATE_INTERVAL,
    wait: ->(milli_seconds) { wait milli_seconds }
  )
    @interval = interval
    @filesystem = filesystem
    @wait = ->(milli_seconds) { wait milli_seconds }
  end

  def start
    run_loop
  end

  def run_loop
    while true
      @wait.call(@interval)
      update_repo
    end
  end

  def update_repo
    git_add
    git_commit
    git_push
  end

  def in_git_repo?
    @filesystem.entries(".").any? { |x| x == ".git"}
  end

  private
  def git_add
    `git add .`
  end

  def git_commit
    `git commit -m "#{DEFAULT_COMMIT_MESSAGE}"`
  end

  def git_push
    `git push`
  end

  def git_current_branch
    `git rev-parse --abbrev-ref HEAD --`
  end
end
