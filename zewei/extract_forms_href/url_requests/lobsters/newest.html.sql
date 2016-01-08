# Logfile created on 2016-01-08 12:47:37 -0600 by logger.rb/47272
D, [2016-01-08T12:47:37.757943 #2716] DEBUG -- :   [1m[36mUser Load (0.2ms)[0m  [1mSELECT  `users`.* FROM `users`  WHERE `users`.`session_token` = 'yMvDgquEClagp0qkFWmweNDKPFMLfRYlrUmNEDKS9vYY9ks7SltCng7dvAiw'  ORDER BY `users`.`id` ASC LIMIT 1[0m
D, [2016-01-08T12:47:37.760408 #2716] DEBUG -- :   [1m[35mTagFilter Load (0.2ms)[0m  SELECT `tag_filters`.* FROM `tag_filters`  WHERE `tag_filters`.`user_id` = 1
D, [2016-01-08T12:47:37.763219 #2716] DEBUG -- :   [1m[36mStory Load (0.3ms)[0m  [1mSELECT  `stories`.* FROM `stories`  WHERE `stories`.`merged_story_id` IS NULL AND `stories`.`is_expired` = 0 AND (`stories`.`id` NOT IN (SELECT `hidden_stories`.`story_id` FROM `hidden_stories`  WHERE `hidden_stories`.`user_id` = 1))  ORDER BY stories.id DESC LIMIT 26 OFFSET 0[0m
D, [2016-01-08T12:47:37.766019 #2716] DEBUG -- :   [1m[35mUser Load (0.2ms)[0m  SELECT `users`.* FROM `users`  WHERE `users`.`id` IN (1)
D, [2016-01-08T12:47:37.768441 #2716] DEBUG -- :   [1m[36mTagging Load (0.2ms)[0m  [1mSELECT `taggings`.* FROM `taggings`  WHERE `taggings`.`story_id` IN (3, 2, 1)[0m
D, [2016-01-08T12:47:37.772708 #2716] DEBUG -- :   [1m[35mTag Load (0.4ms)[0m  SELECT `tags`.* FROM `tags`  WHERE `tags`.`id` IN (1)
D, [2016-01-08T12:47:37.774781 #2716] DEBUG -- :   [1m[36mVote Load (0.4ms)[0m  [1mSELECT `votes`.* FROM `votes`  WHERE `votes`.`user_id` = 1 AND `votes`.`story_id` IN (3, 2, 1) AND `votes`.`comment_id` IS NULL[0m
D, [2016-01-08T12:47:37.776925 #2716] DEBUG -- :   [1m[35mHiddenStory Load (0.2ms)[0m  SELECT `hidden_stories`.* FROM `hidden_stories`  WHERE `hidden_stories`.`user_id` = 1 AND `hidden_stories`.`story_id` IN (3, 2, 1)
D, [2016-01-08T12:47:37.895388 #2716] DEBUG -- :   [1m[36mKeystore Load (0.7ms)[0m  [1mSELECT  `keystores`.* FROM `keystores`  WHERE `keystores`.`key` = 'user:1:unread_messages'  ORDER BY `keystores`.`key` ASC LIMIT 1[0m
D, [2016-01-08T12:47:37.899521 #2716] DEBUG -- :   [1m[35m (0.3ms)[0m  SELECT COUNT(*) FROM `invitation_requests`  WHERE `invitation_requests`.`is_verified` = 1
