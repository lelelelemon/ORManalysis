# Logfile created on 2016-01-05 10:31:31 -0600 by logger.rb/47272
D, [2016-01-05T10:31:31.472228 #2768] DEBUG -- :   [1m[36mUser Load (0.2ms)[0m  [1mSELECT  `users`.* FROM `users`  WHERE `users`.`session_token` = 'yMvDgquEClagp0qkFWmweNDKPFMLfRYlrUmNEDKS9vYY9ks7SltCng7dvAiw'  ORDER BY `users`.`id` ASC LIMIT 1[0m
D, [2016-01-05T10:31:31.474023 #2768] DEBUG -- :   [1m[35mStory Load (0.2ms)[0m  SELECT  `stories`.* FROM `stories`  WHERE `stories`.`short_id` = 'z7cdwv'  ORDER BY `stories`.`id` ASC LIMIT 1
D, [2016-01-05T10:31:31.475644 #2768] DEBUG -- :   [1m[36mVote Load (0.2ms)[0m  [1mSELECT  `votes`.* FROM `votes`  WHERE `votes`.`user_id` = 1 AND `votes`.`story_id` = 1 AND `votes`.`comment_id` IS NULL  ORDER BY `votes`.`id` ASC LIMIT 1[0m
D, [2016-01-05T10:31:31.485998 #2768] DEBUG -- :   [1m[35m (0.1ms)[0m  SELECT COUNT(*) FROM `suggested_taggings`  WHERE `suggested_taggings`.`story_id` = 1 AND `suggested_taggings`.`user_id` = 1
D, [2016-01-05T10:31:31.492504 #2768] DEBUG -- :   [1m[36mSuggestedTitle Load (0.8ms)[0m  [1mSELECT  `suggested_titles`.* FROM `suggested_titles`  WHERE `suggested_titles`.`story_id` = 1 AND `suggested_titles`.`user_id` = 1  ORDER BY `suggested_titles`.`id` ASC LIMIT 1[0m
D, [2016-01-05T10:31:31.500787 #2768] DEBUG -- :   [1m[35m (0.2ms)[0m  SELECT COUNT(*) AS count_all, tag_id AS tag_id FROM `tag_filters`  GROUP BY `tag_filters`.`tag_id`
D, [2016-01-05T10:31:31.502068 #2768] DEBUG -- :   [1m[36mTag Load (0.2ms)[0m  [1mSELECT `tags`.* FROM `tags`  WHERE `tags`.`inactive` = 0  ORDER BY `tags`.`tag` ASC[0m
D, [2016-01-05T10:31:31.504320 #2768] DEBUG -- :   [1m[35mTagging Load (0.2ms)[0m  SELECT `taggings`.* FROM `taggings`  WHERE `taggings`.`story_id` = 1
D, [2016-01-05T10:31:31.505590 #2768] DEBUG -- :   [1m[36mTag Load (0.2ms)[0m  [1mSELECT  `tags`.* FROM `tags`  WHERE `tags`.`id` = 1 LIMIT 1[0m
D, [2016-01-05T10:31:31.561810 #2768] DEBUG -- :   [1m[35mKeystore Load (0.2ms)[0m  SELECT  `keystores`.* FROM `keystores`  WHERE `keystores`.`key` = 'user:1:unread_messages'  ORDER BY `keystores`.`key` ASC LIMIT 1
D, [2016-01-05T10:31:31.564530 #2768] DEBUG -- :   [1m[36m (0.5ms)[0m  [1mSELECT COUNT(*) FROM `invitation_requests`  WHERE `invitation_requests`.`is_verified` = 1[0m
