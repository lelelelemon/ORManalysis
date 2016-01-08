# Logfile created on 2016-01-08 12:47:38 -0600 by logger.rb/47272
D, [2016-01-08T12:47:38.380951 #2716] DEBUG -- :   [1m[35mUser Load (0.2ms)[0m  SELECT  `users`.* FROM `users`  WHERE `users`.`session_token` = 'yMvDgquEClagp0qkFWmweNDKPFMLfRYlrUmNEDKS9vYY9ks7SltCng7dvAiw'  ORDER BY `users`.`id` ASC LIMIT 1
D, [2016-01-08T12:47:38.385791 #2716] DEBUG -- :   [1m[36mTagFilter Load (0.3ms)[0m  [1mSELECT `tag_filters`.* FROM `tag_filters`  WHERE `tag_filters`.`user_id` = 1[0m
D, [2016-01-08T12:47:38.387866 #2716] DEBUG -- :   [1m[35mStory Load (1.0ms)[0m  SELECT  `stories`.* FROM `stories`  WHERE `stories`.`merged_story_id` IS NULL AND `stories`.`is_expired` = 0 AND `stories`.`id` IN (SELECT `hidden_stories`.`story_id` FROM `hidden_stories`  WHERE `hidden_stories`.`user_id` = 1)  ORDER BY hotness LIMIT 26 OFFSET 0
D, [2016-01-08T12:47:38.388951 #2716] DEBUG -- :   [1m[36mVote Load (0.2ms)[0m  [1mSELECT `votes`.* FROM `votes`  WHERE `votes`.`user_id` = 1 AND 1=0 AND `votes`.`comment_id` IS NULL[0m
D, [2016-01-08T12:47:38.389806 #2716] DEBUG -- :   [1m[35mHiddenStory Load (0.3ms)[0m  SELECT `hidden_stories`.* FROM `hidden_stories`  WHERE `hidden_stories`.`user_id` = 1 AND 1=0
D, [2016-01-08T12:47:38.436830 #2716] DEBUG -- :   [1m[36mKeystore Load (4.8ms)[0m  [1mSELECT  `keystores`.* FROM `keystores`  WHERE `keystores`.`key` = 'user:1:unread_messages'  ORDER BY `keystores`.`key` ASC LIMIT 1[0m
D, [2016-01-08T12:47:38.438421 #2716] DEBUG -- :   [1m[35m (0.2ms)[0m  SELECT COUNT(*) FROM `invitation_requests`  WHERE `invitation_requests`.`is_verified` = 1
