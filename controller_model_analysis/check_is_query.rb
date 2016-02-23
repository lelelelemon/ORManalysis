def check_method_keyword(_caller, k)
	if _caller != nil and _caller.include?("Dir.glob") or _caller == "File"
		return nil
	elsif k.index("find_by")==0
		return "SELECT"
	elsif k.end_with?("count")
	#for example: User.tags_count = Tag.where(user_id = :id).count
			
	else
		return $key_words[k]
	end
end

