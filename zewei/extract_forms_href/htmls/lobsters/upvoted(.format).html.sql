# Logfile created on 2016-01-05 10:31:30 -0600 by logger.rb/47272
D, [2016-01-05T10:31:30.508037 #2768] DEBUG -- :   [1m[35mUser Load (0.3ms)[0m  SELECT  `users`.* FROM `users`  WHERE `users`.`session_token` = 'yMvDgquEClagp0qkFWmweNDKPFMLfRYlrUmNEDKS9vYY9ks7SltCng7dvAiw'  ORDER BY `users`.`id` ASC LIMIT 1
D, [2016-01-05T10:31:30.515342 #2768] DEBUG -- :   [1m[36mStory Load (0.3ms)[0m  [1mSELECT  `stories`.* FROM `stories` INNER JOIN `votes` ON `stories`.`id` = `votes`.`story_id` WHERE `votes`.`comment_id` IS NULL AND `votes`.`vote` = 1 AND `votes`.`user_id` = 1  ORDER BY votes.id DESC LIMIT 26 OFFSET 0[0m
D, [2016-01-05T10:31:30.517467 #2768] DEBUG -- :   [1m[35mUser Load (0.2ms)[0m  SELECT `users`.* FROM `users`  WHERE `users`.`id` IN (1)
D, [2016-01-05T10:31:30.520766 #2768] DEBUG -- :   [1m[36mTagging Load (0.3ms)[0m  [1mSELECT `taggings`.* FROM `taggings`  WHERE `taggings`.`story_id` IN (2, 1)[0m
D, [2016-01-05T10:31:30.522335 #2768] DEBUG -- :   [1m[35mTag Load (0.2ms)[0m  SELECT `tags`.* FROM `tags`  WHERE `tags`.`id` IN (1)
D, [2016-01-05T10:31:30.523355 #2768] DEBUG -- :   [1m[36mVote Load (0.1ms)[0m  [1mSELECT `votes`.* FROM `votes`  WHERE `votes`.`user_id` = 1 AND `votes`.`story_id` IN (2, 1) AND `votes`.`comment_id` IS NULL[0m
D, [2016-01-05T10:31:30.524315 #2768] DEBUG -- :   [1m[35mHiddenStory Load (0.1ms)[0m  SELECT `hidden_stories`.* FROM `hidden_stories`  WHERE `hidden_stories`.`user_id` = 1 AND `hidden_stories`.`story_id` IN (2, 1)
D, [2016-01-05T10:31:30.578469 #2768] DEBUG -- :   [1m[36mKeystore Load (0.3ms)[0m  [1mSELECT  `keystores`.* FROM `keystores`  WHERE `keystores`.`key` = 'user:1:unread_messages'  ORDER BY `keystores`.`key` ASC LIMIT 1[0m
D, [2016-01-05T10:31:30.580375 #2768] DEBUG -- :   [1m[35m (0.2ms)[0m  SELECT COUNT(*) FROM `invitation_requests`  WHERE `invitation_requests`.`is_verified` = 1
