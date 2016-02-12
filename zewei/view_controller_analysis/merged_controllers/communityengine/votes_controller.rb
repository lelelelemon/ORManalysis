class VotesController < BaseController
  before_action :find_choice, :only => [:create]
  before_action :login_required
  
  def new
    @post = Post.find(params[:post_id])
    redirect_to user_post_path(@post.user, @post)
  end
  
  def create
    @vote = @choice.votes.new(:user => current_user, :poll => @choice.poll )
    
    @vote.save
    respond_to do |format|
      format.js
    end
 if @vote.valid? 
 @choice.poll.id.to_s 
 ( has_voted = logged_in? && poll.voted?(current_user) 
 poll.question 
 :total_votes.l 
 poll.votes.size 
 poll.choices.each do |choice|      
 if @is_current_user || has_voted 
 choice.votes_percentage 
 choice.votes_percentage 
 else 
 if logged_in? && !has_voted 
 link_to :vote.l, votes_path(:choice_id => choice), :method => :post, :class => 'act-via-ajax' 
 elsif !logged_in? 
 link_to :vote.l, new_vote_path(:post_id => poll.post.id), {:title => :log_in_to_vote.l, :class => 'vote'} 
 end 
 end 
 choice.description 
 end 
 if !has_voted 
 :you_must_vote_to_see_the_results.l 
 elsif logged_in? 
 :you_have_already_voted.l 
 end 
).gsub('"', '\"').gsub("\n", "").html_safe 
 else 
 @vote.errors.full_messages.join(', ') 
 end 

  end
  
  protected
  
  def find_choice
    @choice = Choice.find(params[:choice_id])    
  end
end
