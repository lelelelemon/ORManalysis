require 'nokogiri'

def getStoryIds(url, html_text)
	if url == $prefix or url.include?("recent")
		page = Nokogiri::HTML(html_text)
		page.css("li").each do |li|
			if li.attr("data-shortid")
				story_id = li.attr("data-shortid")
				puts "Short id  = #{story_id}"
				if $story_id_list.include?(story_id)
				else
					$story_id_list.push(story_id)
				end
			end
		end
	end 
end

def getCommentIds(url, html_text)
	if url.include?("/s/")
		page = Nokogiri::HTML(html_text)
		page.css("li").each do |li|
			if li.attr("data-shortid")
				comment_id = li.attr("data-shortid")
				if $comment_id_list.include?(comment_id)
				else
					$comment_id_list.push(comment_id)
				end
			end
		end
	end
end

def generateEntrancePage
	@html = "<html><head></head><body>\n"

	#story_id upvote, unvote, downvote, hide, unhide
	$story_id_list.each do |s|
		target = "#{$prefix}stories/#{s}/upvote"
		@html += "<form name=\"form_#{s}_upvote\" method=\"post\" action=\"#{target}\">\n"
		@html += "<input name=\"#{s}_upvote\" type=\"submit\"></input>\n"
		@html += "</form>\n"

		target = "#{$prefix}stories/#{s}/unvote"
		@html += "<form name=\"form_#{s}_unvote\" method=\"post\" action=\"#{target}\">\n"
		@html += "<input name=\"#{s}_unvote\" type=\"submit\"></input>\n"
		@html += "</form>\n"

		target = "#{$prefix}stories/#{s}/downvote"
		@html += "<form name=\"form_#{s}_downvote\" method=\"post\" action=\"#{target}\">\n"
		@html += "<input name=\"#{s}_downvote\" type=\"submit\"></input>\n"
		@html += "</form>\n"

		target = "#{$prefix}stories/#{s}/hide"
		@html += "<form name=\"form_#{s}_hide\" method=\"post\" action=\"#{target}\">\n"
		@html += "<input name=\"#{s}_hide\" type=\"submit\"></input>\n"
		@html += "</form>\n"

		target = "#{$prefix}stories/#{s}/unhide"
		@html += "<form name=\"form_#{s}_unhide\" method=\"post\" action=\"#{target}\">\n"
		@html += "<input name=\"#{s}_unhide\" type=\"submit\"></input>\n"
		@html += "</form>\n"
	end

	@html += "\n\n"
	
	$comment_id_list.each do |c|
		target = "#{$prefix}comments/#{c}/reply"
		@html += "<form name=\"form_#{c}_reply\" method=\"post\" action=\"#{target}\">\n"
		@html += "<input name=\"#{c}_reply\" type=\"submit\"></input>\n"
		@html += "</form>\n"

		target = "#{$prefix}comments/#{c}/upvote"
		@html += "<form name=\"form_#{c}_upvote\" method=\"post\" action=\"#{target}\">\n"
		@html += "<input name=\"#{c}_upvote\" type=\"submit\"></input>\n"
		@html += "</form>\n"

		target = "#{$prefix}comments/#{c}/unvote"
		@html += "<form name=\"form_#{c}_unvote\" method=\"post\" action=\"#{target}\">\n"
		@html += "<input name=\"#{c}_unvote\" type=\"submit\"></input>\n"
		@html += "</form>\n"
		
		target = "#{$prefix}comments/#{c}/delete"
		@html += "<form name=\"form_#{c}_delete\" method=\"post\" action=\"#{target}\">\n"
		@html += "<input name=\"#{c}_delete\" type=\"submit\"></input>\n"
		@html += "</form>\n"

		target = "#{$prefix}comments/#{c}/delete"
		@html += "<form name=\"form_#{c}_delete\" method=\"post\" action=\"#{target}\">\n"
		@html += "<input name=\"#{c}_delete\" type=\"submit\"></input>\n"
		@html += "</form>\n"

		target = "#{$prefix}comments/#{c}/undelete"
		@html += "<form name=\"form_#{c}_undelete\" method=\"post\" action=\"#{target}\">\n"
		@html += "<input name=\"#{c}_undelete\" type=\"submit\"></input>\n"
		@html += "</form>\n"
	end

	@html += "\n\n"
	$entrance_list.each do |ent|
		@html += "<a href=\"#{ent}\"></a>\n"
	end

	$comment_id_list.each do |c|
		@html += "<a href=\"#{$prefix}/comments/#{c}/reply\"></a>\n"
	end

	@html += '</body></html>'

	location = "file:///home/congy/ruby_source/ORM_analysis/profiling/lobsters_data/test.html"
	fp=File.open("test.html", "w")
	fp.puts(@html)
	fp.close

	return location
end

