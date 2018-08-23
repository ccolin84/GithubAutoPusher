class GithubAutoPusher
  VERSION = "0.1.0" 
  UPDATE_INTERVAL = 30 * 60 
  DEFAULT_COMMIT_MESSAGE = "scheduled auto commit"

  def run
    while true
      sleep UPDATE_INTERVAL
      update_repo
    end
  end

  def update_repo
    git_add
    git_commit
    git_push
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
end
