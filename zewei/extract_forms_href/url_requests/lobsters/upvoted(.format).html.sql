# Logfile created on 2016-01-08 12:47:38 -0600 by logger.rb/47272
D, [2016-01-08T12:47:38.746168 #2716] DEBUG -- :   [1m[36mUser Load (0.2ms)[0m  [1mSELECT  `users`.* FROM `users`  WHERE `users`.`session_token` = 'yMvDgquEClagp0qkFWmweNDKPFMLfRYlrUmNEDKS9vYY9ks7SltCng7dvAiw'  ORDER BY `users`.`id` ASC LIMIT 1[0m
D, [2016-01-08T12:47:38.753077 #2716] DEBUG -- :   [1m[35mStory Load (0.3ms)[0m  SELECT  `stories`.* FROM `stories` INNER JOIN `votes` ON `stories`.`id` = `votes`.`story_id` WHERE `votes`.`comment_id` IS NULL AND `votes`.`vote` = 1 AND `votes`.`user_id` = 1  ORDER BY votes.id DESC LIMIT 26 OFFSET 0
D, [2016-01-08T12:47:38.755461 #2716] DEBUG -- :   [1m[36mUser Load (0.2ms)[0m  [1mSELECT `users`.* FROM `users`  WHERE `users`.`id` IN (1)[0m
D, [2016-01-08T12:47:38.757214 #2716] DEBUG -- :   [1m[35mTagging Load (0.2ms)[0m  SELECT `taggings`.* FROM `taggings`  WHERE `taggings`.`story_id` IN (3, 2, 1)
D, [2016-01-08T12:47:38.758829 #2716] DEBUG -- :   [1m[36mTag Load (0.2ms)[0m  [1mSELECT `tags`.* FROM `tags`  WHERE `tags`.`id` IN (1)[0m
D, [2016-01-08T12:47:38.760375 #2716] DEBUG -- :   [1m[35mVote Load (0.3ms)[0m  SELECT `votes`.* FROM `votes`  WHERE `votes`.`user_id` = 1 AND `votes`.`story_id` IN (3, 2, 1) AND `votes`.`comment_id` IS NULL
D, [2016-01-08T12:47:38.762894 #2716] DEBUG -- :   [1m[36mHiddenStory Load (0.2ms)[0m  [1mSELECT `hidden_stories`.* FROM `hidden_stories`  WHERE `hidden_stories`.`user_id` = 1 AND `hidden_stories`.`story_id` IN (3, 2, 1)[0m
D, [2016-01-08T12:47:38.835240 #2716] DEBUG -- :   [1m[35mKeystore Load (0.2ms)[0m  SELECT  `keystores`.* FROM `keystores`  WHERE `keystores`.`key` = 'user:1:unread_messages'  ORDER BY `keystores`.`key` ASC LIMIT 1
D, [2016-01-08T12:47:38.837494 #2716] DEBUG -- :   [1m[36m (0.2ms)[0m  [1mSELECT COUNT(*) FROM `invitation_requests`  WHERE `invitation_requests`.`is_verified` = 1[0m
