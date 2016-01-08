# Logfile created on 2016-01-08 12:47:37 -0600 by logger.rb/47272
D, [2016-01-08T12:47:37.644910 #2716] DEBUG -- :   [1m[36mUser Load (0.3ms)[0m  [1mSELECT  `users`.* FROM `users`  WHERE `users`.`session_token` = 'yMvDgquEClagp0qkFWmweNDKPFMLfRYlrUmNEDKS9vYY9ks7SltCng7dvAiw'  ORDER BY `users`.`id` ASC LIMIT 1[0m
D, [2016-01-08T12:47:37.646561 #2716] DEBUG -- :   [1m[35mTagFilter Load (0.1ms)[0m  SELECT `tag_filters`.* FROM `tag_filters`  WHERE `tag_filters`.`user_id` = 1
D, [2016-01-08T12:47:37.650919 #2716] DEBUG -- :   [1m[36mStory Load (3.3ms)[0m  [1mSELECT  `stories`.* FROM `stories`  WHERE `stories`.`merged_story_id` IS NULL AND `stories`.`is_expired` = 0 AND (`stories`.`id` NOT IN (SELECT `hidden_stories`.`story_id` FROM `hidden_stories`  WHERE `hidden_stories`.`user_id` = 1))  ORDER BY stories.id DESC LIMIT 26 OFFSET 0[0m
D, [2016-01-08T12:47:37.654646 #2716] DEBUG -- :   [1m[35mUser Load (0.2ms)[0m  SELECT `users`.* FROM `users`  WHERE `users`.`id` IN (1)
D, [2016-01-08T12:47:37.657214 #2716] DEBUG -- :   [1m[36mTagging Load (0.3ms)[0m  [1mSELECT `taggings`.* FROM `taggings`  WHERE `taggings`.`story_id` IN (3, 2, 1)[0m
D, [2016-01-08T12:47:37.660335 #2716] DEBUG -- :   [1m[35mTag Load (0.2ms)[0m  SELECT `tags`.* FROM `tags`  WHERE `tags`.`id` IN (1)
D, [2016-01-08T12:47:37.661902 #2716] DEBUG -- :   [1m[36mVote Load (0.2ms)[0m  [1mSELECT `votes`.* FROM `votes`  WHERE `votes`.`user_id` = 1 AND `votes`.`story_id` IN (3, 2, 1) AND `votes`.`comment_id` IS NULL[0m
D, [2016-01-08T12:47:37.663716 #2716] DEBUG -- :   [1m[35mHiddenStory Load (0.2ms)[0m  SELECT `hidden_stories`.* FROM `hidden_stories`  WHERE `hidden_stories`.`user_id` = 1 AND `hidden_stories`.`story_id` IN (3, 2, 1)
D, [2016-01-08T12:47:37.739923 #2716] DEBUG -- :   [1m[36mKeystore Load (0.2ms)[0m  [1mSELECT  `keystores`.* FROM `keystores`  WHERE `keystores`.`key` = 'user:1:unread_messages'  ORDER BY `keystores`.`key` ASC LIMIT 1[0m
D, [2016-01-08T12:47:37.742238 #2716] DEBUG -- :   [1m[35m (0.2ms)[0m  SELECT COUNT(*) FROM `invitation_requests`  WHERE `invitation_requests`.`is_verified` = 1
