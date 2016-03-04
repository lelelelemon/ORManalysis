# encoding: UTF-8
class StatisticsController < ApplicationController

  def tracker
    @stats = Statistics::Tracker.new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end

  def prizes
    @month = params[:month]
    @stats = Statistics::Prizes.new(@month)
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Statistiques d'aide au choix des primables - #{@stats.month.strftime "%m/%Y"}" 
 link_to "Mois prcdent", month: @stats.month.prev_month.strftime("%m-%Y") 
 link_to "Mois suivant", month: @stats.month.next_month.strftime("%m-%Y") 
 list_of @stats.best_score(News, 20) do |news, score| 
 link_to_content_with_score(news, score) 
 end 
 list_of @stats.sum_comments_score(News, 20) do |news, score| 
 link_to_content_with_score(news, score) 
 end 
 list_of @stats.longest_news(News, 20) do |news, score| 
 link_to_content_with_score(news, score) 
 end 
 list_of @stats.best_score(Diary, 20) do |diary, score| 
 link_to_content_with_score(diary, score) 
 end 
 list_of @stats.sum_comments_score(Diary, 20) do |diary, score| 
 link_to_content_with_score(diary, score) 
 end 
 list_of @stats.best_score(Post, 5) do |post, score| 
 link_to_content_with_score(post, score) 
 end 
 list_of @stats.sum_comments_score(Post, 5) do |post, score| 
 link_to_content_with_score(post, score) 
 end 
 list_of @stats.top_authors(News, 5) do |user, score| 
 link_to_user_with_score(user, score) 
 end 
 list_of @stats.top_authors(Diary, 5) do |user, score| 
 link_to_user_with_score(user, score) 
 end 
 list_of @stats.top_authors(Tracker, 5) do |user, score| 
 link_to_user_with_score(user, score) 
 end 
 list_of @stats.top_commenters(Tracker, 5) do |user, score| 
 link_to_user_with_score(user, score) 
 end 
 list_of @stats.top_commenters(Post, 5) do |user, score| 
 link_to_user_with_score(user, score) 
 end 

end

  end

  def users
    @stats = Statistics::Users.new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end

  def top
    @stats = Statistics::Tops.new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Top ou flop du site" 
 list_of @stats.top_authors(News, 30, true) do |user, score| 
 link_to_user_with_score(user, score) 
 end 
 list_of @stats.top_authors(News, 30, false) do |user, score| 
 link_to_user_with_score(user, score) 
 end 
 list_of @stats.top_authors(Diary, 15, true) do |user, score| 
 link_to_user_with_score(user, score) 
 end 
 list_of @stats.top_authors(Diary, 15, false) do |user, score| 
 link_to_user_with_score(user, score) 
 end 

end

  end

  def moderation
    @stats = Statistics::Moderation.new
    @goals = Statistics::Goals.new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 javascript_include_tag "sorttable" 
 h1 "Statistiques sur la modration" 
 width_stats = 400 
 if @stats.by_day.any? 
 maxval = @stats.by_day.map {|a| a["cnt"] }.max 
 @stats.by_day.each do |day| 
 day_name day["day"] 
 end 
 @stats.average_time.each do |avg| 
 if avg["cnt"] > 0 
 avg["year"] 
 (@stats.median_time(avg["year"],avg["cnt"],0.50)/3600) 
 (@stats.median_time(avg["year"],avg["cnt"],0.95)/3600) 
 (avg["duration"]/(avg["cnt"]*3600)).to_i 
 (avg["std"]/3600).to_i 
 (avg["min"]/60).to_i 
 (avg["max"]/3600).to_i 
 else 
 end 
 end 
 end 
 link_to("Sur les derniers jours", "#moderation") 
 link_to("Depuis Epoch ou le dbut des donnes", "#moderationEpoch") 
 extra = @stats.news_by_day * 365 / Date.today.yday() 
 "#{pluralize @stats.news_by_day, "dpche publie", "dpches publies"} (extrapolation annuelle de #{extra} pour un objectif de #{@goals.news_by_year} " 
 if (extra >= @goals.news_by_year) 
 image_tag "/images/icones/check.svg", alt: "Objectif atteint", title: "Objectif atteint", width: "16px" 
 end 
 extra2 = @stats.amr_news_by_day * 365 / Date.today.yday() 
 "#{pluralize @stats.amr_news_by_day, "dpche publie crite", "dpches publies crites"} par l'quipe du site (extrapolation annuelle de #{extra2} pour un objectif de #{@goals.amr_news_by_year} " 
 if (extra2 >= @goals.amr_news_by_year) 
 image_tag "/images/icones/check.svg", alt: "Objectif atteint", title: "Objectif atteint", width: "16px" 
 end 
 if Account.amr.any? 
 Account.amr.each do |user| 
 link_to user["login"], user.user 
 @stats.nb_moderations_x_days(user["user_id"],7) 
 @stats.nb_moderations_x_days(user["user_id"],31) 
 @stats.nb_editions_x_days(user["user_id"],7) 
 @stats.nb_editions_x_days(user["user_id"],31) 
 @stats.nb_votes_last_month(user["login"]) 
 @stats.last_news_at(user["user_id"]).each do |last| 
 last["last"] 
 end 
 @stats.news_by_week(user["user_id"]).each do |news| 
 "#{news["cnt"]} en #{pluralize news["weeks"], "semaine"}" 
 if news["cnt"] >= news["weeks"] * @goals.each_amr_news_by_week 
 image_tag "/images/icones/check.svg", alt: "Objectif atteint", title: "Objectif atteint", width: "16px" 
 end 
 end 
 end 
 else 
 end 
 if @stats.top_amr.any? 
 @stats.top_amr.each do |user| 
 link_to user["login"], User.find(user["moderator_id"]) 
 user["cnt"].to_i 
 @stats.nb_votes(user["login"]) 
 @stats.nb_editions_x_days(user["moderator_id"]) 
 end 
 else 
 end 

end

  end

  def redaction
    @stats = Statistics::Redaction.new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 javascript_include_tag "sorttable" 
 h1 "Statistiques sur la rdaction" 
 width_stats = 400 
 list_of @stats.top_week(30) do |stat| 
 end 
 list_of @stats.top_month(30) do |stat| 
 end 
 list_of @stats.top_created(7, 30) do |stat| 
 end 
 list_of @stats.top_created(30, 30) do |stat| 
 end 
 list_of @stats.top_edited(7, 30) do |stat| 
 end 
 list_of @stats.top_edited(30, 30) do |stat| 
 end 

end

  end

  def contents
    @stats = Statistics::Contents.new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end

  def comments
    @stats = Statistics::Comments.new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Statistiques sur les commentaires" 
 width_stats = 400 
 if @stats.comments["Total"] == 0 
 else 
 link_to("par type","#type") 
 link_to("par an","#annee") 
 link_to("par mois","#mois") 
 link_to("par jour de la semaine","#jour") 
 if @stats.comments["Total"] > 1 
 else 
 end 
 if @stats.comments["Total"] > 1 
 else 
 end 
 maxval=@stats.comments_by_year.values.max {|a,b| a.values.max <=> b.values.max}.values.max 
 @stats.comments_by_year.each do |year,comment| 
 newyear=true 
 comment.each do |type,cnt| 
 if newyear==true 
 comment.count 
 year 
 newyear=false 
 end 
 end 
 end 
 if @stats.comments["Total"] > 1 
 else 
 end 
 maxval=@stats.comments_by_month.values.max {|a,b| a.values.max <=> b.values.max}.values.max 
 @stats.comments_by_month.each do |month,comment| 
 newyear=true 
 comment.each do |type,cnt| 
 if newyear==true 
 comment.count 
 month.sub(/(\d{4})(\d{2})/, ' ') 
 newyear=false 
 end 
 end 
 end 
 maxval = @stats.comments_by_day.values.max 
 @stats.comments_by_day.each do |day,cnt| 
 day_name day 
 end 
 end 

end

  end

  def tags
    @stats = Statistics::Tags.new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Statistiques sur les tags" 
 width_stats = 400 
 link_to("gnral","#general") 
 link_to("par type","#type") 
 link_to("par an","#annee") 
 link_to("par mois","#mois") 
 link_to("par jour de la semaine","#jour") 
 if @stats.taggings["Total"] > 1 
 else 
 end 
 if @stats.taggings["Total"] > 1 
 else 
 end 
 maxval = @stats.taggings_by_year.values.map(&:values).flatten.max 
 @stats.taggings_by_year.each do |year,tag| 
 newyear = true 
 tag.each do |type,cnt| 
 if newyear 
 tag.count 
 year 
 newyear = false 
 end 
 end 
 end 
 if @stats.taggings["Total"] > 1 
 else 
 end 
 maxval = @stats.taggings_by_month.values.map(&:values).flatten.max 
 @stats.taggings_by_month.each do |month,tag| 
 newyear = true 
 tag.each do |type,cnt| 
 if newyear 
 tag.count 
 month.sub(/(\d{4})(\d{2})/, ' ') 
 newyear = false 
 end 
 end 
 end 
 if @stats.taggings["Total"] > 1 
 maxval = @stats.taggings_by_day.map {|a| a["cnt"] }.max 
 @stats.taggings_by_day.each do |day| 
 day_name day["day"] 
 end 
 else 
 end 

end

  end
end
