require "GithubPusher"

RSpec.describe GithubPusher do
    describe "#commit_code_and_push" do
        before(:each) do
            @github_pusher = GithubPusher.new
            @gihub_pusher.stub(:git_add)
            @gihub_pusher.stub(:git_commit)
            @gihub_pusher.stub(:git_push)
            @github_pusher.stub(:commit_code_and_push)
        end

        it "should call #git_add, #git_commit, and #git_push in order" do
            @github_pusher.commit_code_and_push

            expect(@github_pusher).to have_received(:git_add).once
            expect(@github_pusher).to have_received(:git_commit).once
            expect(@github_pusher).to have_received(:git_push).once
        end
    end

    describe "#run" do
        context "given the user provided an interval" do
            it "should call #commit_code_and_push at that interval" do
                github_pusher = GithubPusher.new(interval: 0.1)
                github_pusher.stub(:commit_code_and_push)
                github_pusher.run

                expect(github_pusher).to_not have_received(:commit_code_and_push)
                sleep (60 * 0.1)
                expect(github_pusher).to have_received(:commit_code_and_push).once
            end
        end

        context "given the user didn't provide an interval" do
            it "should call #commit_code_and_push at the default interval" do
                github_pusher = GithubPusher.new
                github_pusher.stub(:commit_code_and_push)
                github_pusher.run

                expect(github_pusher).to_not have_received(:commit_code_and_push)
                sleep (60 * 0.1)
                expect(github_pusher).to have_received(:commit_code_and_push).once
            end
        end
    end
end
