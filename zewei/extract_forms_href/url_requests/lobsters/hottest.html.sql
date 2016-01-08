# Logfile created on 2016-01-08 12:47:37 -0600 by logger.rb/47272
D, [2016-01-08T12:47:37.424965 #2716] DEBUG -- :   [1m[36mUser Load (1.3ms)[0m  [1mSELECT  `users`.* FROM `users`  WHERE `users`.`session_token` = 'yMvDgquEClagp0qkFWmweNDKPFMLfRYlrUmNEDKS9vYY9ks7SltCng7dvAiw'  ORDER BY `users`.`id` ASC LIMIT 1[0m
D, [2016-01-08T12:47:37.429606 #2716] DEBUG -- :   [1m[35mTagFilter Load (0.2ms)[0m  SELECT `tag_filters`.* FROM `tag_filters`  WHERE `tag_filters`.`user_id` = 1
D, [2016-01-08T12:47:37.433361 #2716] DEBUG -- :   [1m[36mStory Load (0.2ms)[0m  [1mSELECT  `stories`.* FROM `stories`  WHERE `stories`.`merged_story_id` IS NULL AND `stories`.`is_expired` = 0 AND ((CAST(upvotes AS signed) - CAST(downvotes AS signed)) >= -1) AND (`stories`.`id` NOT IN (SELECT `hidden_stories`.`story_id` FROM `hidden_stories`  WHERE `hidden_stories`.`user_id` = 1))  ORDER BY hotness LIMIT 26 OFFSET 0[0m
D, [2016-01-08T12:47:37.436860 #2716] DEBUG -- :   [1m[35mUser Load (0.3ms)[0m  SELECT `users`.* FROM `users`  WHERE `users`.`id` IN (1)
D, [2016-01-08T12:47:37.440291 #2716] DEBUG -- :   [1m[36mTagging Load (0.2ms)[0m  [1mSELECT `taggings`.* FROM `taggings`  WHERE `taggings`.`story_id` IN (3, 2, 1)[0m
D, [2016-01-08T12:47:37.446524 #2716] DEBUG -- :   [1m[35mTag Load (0.2ms)[0m  SELECT `tags`.* FROM `tags`  WHERE `tags`.`id` IN (1)
D, [2016-01-08T12:47:37.464452 #2716] DEBUG -- :   [1m[36mVote Load (15.3ms)[0m  [1mSELECT `votes`.* FROM `votes`  WHERE `votes`.`user_id` = 1 AND `votes`.`story_id` IN (3, 2, 1) AND `votes`.`comment_id` IS NULL[0m
D, [2016-01-08T12:47:37.465868 #2716] DEBUG -- :   [1m[35mHiddenStory Load (0.2ms)[0m  SELECT `hidden_stories`.* FROM `hidden_stories`  WHERE `hidden_stories`.`user_id` = 1 AND `hidden_stories`.`story_id` IN (3, 2, 1)
D, [2016-01-08T12:47:37.613982 #2716] DEBUG -- :   [1m[36mKeystore Load (0.3ms)[0m  [1mSELECT  `keystores`.* FROM `keystores`  WHERE `keystores`.`key` = 'user:1:unread_messages'  ORDER BY `keystores`.`key` ASC LIMIT 1[0m
D, [2016-01-08T12:47:37.616031 #2716] DEBUG -- :   [1m[35m (0.1ms)[0m  SELECT COUNT(*) FROM `invitation_requests`  WHERE `invitation_requests`.`is_verified` = 1
