# Logfile created on 2016-01-08 12:47:38 -0600 by logger.rb/47272
D, [2016-01-08T12:47:38.169589 #2716] DEBUG -- :   [1m[36mUser Load (0.2ms)[0m  [1mSELECT  `users`.* FROM `users`  WHERE `users`.`session_token` = 'yMvDgquEClagp0qkFWmweNDKPFMLfRYlrUmNEDKS9vYY9ks7SltCng7dvAiw'  ORDER BY `users`.`id` ASC LIMIT 1[0m
D, [2016-01-08T12:47:38.171980 #2716] DEBUG -- :   [1m[35mTagFilter Load (0.2ms)[0m  SELECT `tag_filters`.* FROM `tag_filters`  WHERE `tag_filters`.`user_id` = 1
D, [2016-01-08T12:47:38.174147 #2716] DEBUG -- :   [1m[36mStory Load (0.2ms)[0m  [1mSELECT `stories`.`id`, `stories`.`upvotes`, `stories`.`downvotes`, `stories`.`user_id` FROM `stories`  WHERE `stories`.`merged_story_id` IS NULL AND `stories`.`is_expired` = 0 AND (`stories`.`id` NOT IN (SELECT `hidden_stories`.`story_id` FROM `hidden_stories`  WHERE `hidden_stories`.`user_id` = 1)) AND (`stories`.`created_at` > '2016-01-05 18:47:38')  ORDER BY stories.id DESC, stories.created_at DESC[0m
D, [2016-01-08T12:47:38.175996 #2716] DEBUG -- :   [1m[35mStory Load (0.0ms)[0m  SELECT `stories`.`id`, `stories`.`upvotes`, `stories`.`downvotes`, `stories`.`user_id` FROM `stories`  WHERE `stories`.`merged_story_id` IS NULL AND `stories`.`is_expired` = 0 AND (`stories`.`id` NOT IN (SELECT `hidden_stories`.`story_id` FROM `hidden_stories`  WHERE `hidden_stories`.`user_id` = 1)) AND (`stories`.`created_at` > '2016-01-04 18:47:38')  ORDER BY stories.id DESC, stories.created_at DESC
D, [2016-01-08T12:47:38.177806 #2716] DEBUG -- :   [1m[36mStory Load (0.2ms)[0m  [1mSELECT `stories`.`id`, `stories`.`upvotes`, `stories`.`downvotes`, `stories`.`user_id` FROM `stories`  WHERE `stories`.`merged_story_id` IS NULL AND `stories`.`is_expired` = 0 AND (`stories`.`id` NOT IN (SELECT `hidden_stories`.`story_id` FROM `hidden_stories`  WHERE `hidden_stories`.`user_id` = 1)) AND (`stories`.`created_at` > '2016-01-03 18:47:38')  ORDER BY stories.id DESC, stories.created_at DESC[0m
D, [2016-01-08T12:47:38.179505 #2716] DEBUG -- :   [1m[35mStory Load (0.2ms)[0m  SELECT `stories`.`id`, `stories`.`upvotes`, `stories`.`downvotes`, `stories`.`user_id` FROM `stories`  WHERE `stories`.`merged_story_id` IS NULL AND `stories`.`is_expired` = 0 AND (`stories`.`id` NOT IN (SELECT `hidden_stories`.`story_id` FROM `hidden_stories`  WHERE `hidden_stories`.`user_id` = 1)) AND (`stories`.`created_at` > '2016-01-02 18:47:38')  ORDER BY stories.id DESC, stories.created_at DESC
D, [2016-01-08T12:47:38.185457 #2716] DEBUG -- :   [1m[36mStory Load (0.8ms)[0m  [1mSELECT `stories`.`id`, `stories`.`upvotes`, `stories`.`downvotes`, `stories`.`user_id` FROM `stories`  WHERE `stories`.`merged_story_id` IS NULL AND `stories`.`is_expired` = 0 AND (`stories`.`id` NOT IN (SELECT `hidden_stories`.`story_id` FROM `hidden_stories`  WHERE `hidden_stories`.`user_id` = 1)) AND (`stories`.`created_at` > '2016-01-01 18:47:38')  ORDER BY stories.id DESC, stories.created_at DESC[0m
D, [2016-01-08T12:47:38.188679 #2716] DEBUG -- :   [1m[35mStory Load (0.6ms)[0m  SELECT `stories`.`id`, `stories`.`upvotes`, `stories`.`downvotes`, `stories`.`user_id` FROM `stories`  WHERE `stories`.`merged_story_id` IS NULL AND `stories`.`is_expired` = 0 AND (`stories`.`id` NOT IN (SELECT `hidden_stories`.`story_id` FROM `hidden_stories`  WHERE `hidden_stories`.`user_id` = 1)) AND (`stories`.`created_at` > '2015-12-31 18:47:38')  ORDER BY stories.id DESC, stories.created_at DESC
D, [2016-01-08T12:47:38.191464 #2716] DEBUG -- :   [1m[36mStory Load (0.2ms)[0m  [1mSELECT `stories`.`id`, `stories`.`upvotes`, `stories`.`downvotes`, `stories`.`user_id` FROM `stories`  WHERE `stories`.`merged_story_id` IS NULL AND `stories`.`is_expired` = 0 AND (`stories`.`id` NOT IN (SELECT `hidden_stories`.`story_id` FROM `hidden_stories`  WHERE `hidden_stories`.`user_id` = 1)) AND (`stories`.`created_at` > '2015-12-30 18:47:38')  ORDER BY stories.id DESC, stories.created_at DESC[0m
D, [2016-01-08T12:47:38.193517 #2716] DEBUG -- :   [1m[35mStory Load (0.2ms)[0m  SELECT `stories`.`id`, `stories`.`upvotes`, `stories`.`downvotes`, `stories`.`user_id` FROM `stories`  WHERE `stories`.`merged_story_id` IS NULL AND `stories`.`is_expired` = 0 AND (`stories`.`id` NOT IN (SELECT `hidden_stories`.`story_id` FROM `hidden_stories`  WHERE `hidden_stories`.`user_id` = 1)) AND (`stories`.`created_at` > '2015-12-29 18:47:38')  ORDER BY stories.id DESC, stories.created_at DESC
D, [2016-01-08T12:47:38.195627 #2716] DEBUG -- :   [1m[36mStory Load (0.3ms)[0m  [1mSELECT `stories`.`id`, `stories`.`upvotes`, `stories`.`downvotes`, `stories`.`user_id` FROM `stories`  WHERE `stories`.`merged_story_id` IS NULL AND `stories`.`is_expired` = 0 AND (`stories`.`id` NOT IN (SELECT `hidden_stories`.`story_id` FROM `hidden_stories`  WHERE `hidden_stories`.`user_id` = 1)) AND (`stories`.`created_at` > '2015-12-28 18:47:38')  ORDER BY stories.id DESC, stories.created_at DESC[0m
D, [2016-01-08T12:47:38.197984 #2716] DEBUG -- :   [1m[35mStory Load (0.2ms)[0m  SELECT `stories`.`id`, `stories`.`upvotes`, `stories`.`downvotes`, `stories`.`user_id` FROM `stories`  WHERE `stories`.`merged_story_id` IS NULL AND `stories`.`is_expired` = 0 AND (`stories`.`id` NOT IN (SELECT `hidden_stories`.`story_id` FROM `hidden_stories`  WHERE `hidden_stories`.`user_id` = 1)) AND (`stories`.`created_at` > '2015-12-27 18:47:38')  ORDER BY stories.id DESC, stories.created_at DESC
D, [2016-01-08T12:47:38.199479 #2716] DEBUG -- :   [1m[36mStory Load (0.2ms)[0m  [1mSELECT  `stories`.* FROM `stories`  WHERE `stories`.`merged_story_id` IS NULL AND `stories`.`is_expired` = 0 AND (`stories`.`id` NOT IN (SELECT `hidden_stories`.`story_id` FROM `hidden_stories`  WHERE `hidden_stories`.`user_id` = 1))  ORDER BY stories.id DESC, stories.created_at DESC LIMIT 26 OFFSET 0[0m
D, [2016-01-08T12:47:38.201780 #2716] DEBUG -- :   [1m[35mUser Load (0.2ms)[0m  SELECT `users`.* FROM `users`  WHERE `users`.`id` IN (1)
D, [2016-01-08T12:47:38.203864 #2716] DEBUG -- :   [1m[36mTagging Load (0.4ms)[0m  [1mSELECT `taggings`.* FROM `taggings`  WHERE `taggings`.`story_id` IN (3, 2, 1)[0m
D, [2016-01-08T12:47:38.205666 #2716] DEBUG -- :   [1m[35mTag Load (0.2ms)[0m  SELECT `tags`.* FROM `tags`  WHERE `tags`.`id` IN (1)
D, [2016-01-08T12:47:38.206917 #2716] DEBUG -- :   [1m[36mVote Load (0.2ms)[0m  [1mSELECT `votes`.* FROM `votes`  WHERE `votes`.`user_id` = 1 AND `votes`.`story_id` IN (3, 2, 1) AND `votes`.`comment_id` IS NULL[0m
D, [2016-01-08T12:47:38.207925 #2716] DEBUG -- :   [1m[35mHiddenStory Load (0.2ms)[0m  SELECT `hidden_stories`.* FROM `hidden_stories`  WHERE `hidden_stories`.`user_id` = 1 AND `hidden_stories`.`story_id` IN (3, 2, 1)
D, [2016-01-08T12:47:38.271512 #2716] DEBUG -- :   [1m[36mKeystore Load (3.5ms)[0m  [1mSELECT  `keystores`.* FROM `keystores`  WHERE `keystores`.`key` = 'user:1:unread_messages'  ORDER BY `keystores`.`key` ASC LIMIT 1[0m
D, [2016-01-08T12:47:38.274352 #2716] DEBUG -- :   [1m[35m (0.2ms)[0m  SELECT COUNT(*) FROM `invitation_requests`  WHERE `invitation_requests`.`is_verified` = 1
