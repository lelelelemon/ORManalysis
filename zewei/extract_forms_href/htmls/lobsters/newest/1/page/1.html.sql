# Logfile created on 2016-01-05 10:31:29 -0600 by logger.rb/47272
D, [2016-01-05T10:31:29.952184 #2768] DEBUG -- :   [1m[35mUser Load (0.2ms)[0m  SELECT  `users`.* FROM `users`  WHERE `users`.`session_token` = 'yMvDgquEClagp0qkFWmweNDKPFMLfRYlrUmNEDKS9vYY9ks7SltCng7dvAiw'  ORDER BY `users`.`id` ASC LIMIT 1
D, [2016-01-05T10:31:29.954183 #2768] DEBUG -- :   [1m[36mTagFilter Load (0.2ms)[0m  [1mSELECT `tag_filters`.* FROM `tag_filters`  WHERE `tag_filters`.`user_id` = 1[0m
D, [2016-01-05T10:31:29.958699 #2768] DEBUG -- :   [1m[35mStory Load (0.6ms)[0m  SELECT `stories`.`id`, `stories`.`upvotes`, `stories`.`downvotes`, `stories`.`user_id` FROM `stories`  WHERE `stories`.`merged_story_id` IS NULL AND `stories`.`is_expired` = 0 AND (`stories`.`id` NOT IN (SELECT `hidden_stories`.`story_id` FROM `hidden_stories`  WHERE `hidden_stories`.`user_id` = 1)) AND (`stories`.`created_at` > '2016-01-02 16:31:29')  ORDER BY stories.id DESC, stories.created_at DESC
D, [2016-01-05T10:31:29.961447 #2768] DEBUG -- :   [1m[36mStory Load (0.6ms)[0m  [1mSELECT `stories`.`id`, `stories`.`upvotes`, `stories`.`downvotes`, `stories`.`user_id` FROM `stories`  WHERE `stories`.`merged_story_id` IS NULL AND `stories`.`is_expired` = 0 AND (`stories`.`id` NOT IN (SELECT `hidden_stories`.`story_id` FROM `hidden_stories`  WHERE `hidden_stories`.`user_id` = 1)) AND (`stories`.`created_at` > '2016-01-01 16:31:29')  ORDER BY stories.id DESC, stories.created_at DESC[0m
D, [2016-01-05T10:31:29.964199 #2768] DEBUG -- :   [1m[35mStory Load (0.4ms)[0m  SELECT `stories`.`id`, `stories`.`upvotes`, `stories`.`downvotes`, `stories`.`user_id` FROM `stories`  WHERE `stories`.`merged_story_id` IS NULL AND `stories`.`is_expired` = 0 AND (`stories`.`id` NOT IN (SELECT `hidden_stories`.`story_id` FROM `hidden_stories`  WHERE `hidden_stories`.`user_id` = 1)) AND (`stories`.`created_at` > '2015-12-31 16:31:29')  ORDER BY stories.id DESC, stories.created_at DESC
D, [2016-01-05T10:31:29.969123 #2768] DEBUG -- :   [1m[36mStory Load (1.5ms)[0m  [1mSELECT `stories`.`id`, `stories`.`upvotes`, `stories`.`downvotes`, `stories`.`user_id` FROM `stories`  WHERE `stories`.`merged_story_id` IS NULL AND `stories`.`is_expired` = 0 AND (`stories`.`id` NOT IN (SELECT `hidden_stories`.`story_id` FROM `hidden_stories`  WHERE `hidden_stories`.`user_id` = 1)) AND (`stories`.`created_at` > '2015-12-30 16:31:29')  ORDER BY stories.id DESC, stories.created_at DESC[0m
D, [2016-01-05T10:31:29.971759 #2768] DEBUG -- :   [1m[35mStory Load (0.7ms)[0m  SELECT `stories`.`id`, `stories`.`upvotes`, `stories`.`downvotes`, `stories`.`user_id` FROM `stories`  WHERE `stories`.`merged_story_id` IS NULL AND `stories`.`is_expired` = 0 AND (`stories`.`id` NOT IN (SELECT `hidden_stories`.`story_id` FROM `hidden_stories`  WHERE `hidden_stories`.`user_id` = 1)) AND (`stories`.`created_at` > '2015-12-29 16:31:29')  ORDER BY stories.id DESC, stories.created_at DESC
D, [2016-01-05T10:31:29.974221 #2768] DEBUG -- :   [1m[36mStory Load (0.5ms)[0m  [1mSELECT `stories`.`id`, `stories`.`upvotes`, `stories`.`downvotes`, `stories`.`user_id` FROM `stories`  WHERE `stories`.`merged_story_id` IS NULL AND `stories`.`is_expired` = 0 AND (`stories`.`id` NOT IN (SELECT `hidden_stories`.`story_id` FROM `hidden_stories`  WHERE `hidden_stories`.`user_id` = 1)) AND (`stories`.`created_at` > '2015-12-28 16:31:29')  ORDER BY stories.id DESC, stories.created_at DESC[0m
D, [2016-01-05T10:31:29.976652 #2768] DEBUG -- :   [1m[35mStory Load (0.6ms)[0m  SELECT `stories`.`id`, `stories`.`upvotes`, `stories`.`downvotes`, `stories`.`user_id` FROM `stories`  WHERE `stories`.`merged_story_id` IS NULL AND `stories`.`is_expired` = 0 AND (`stories`.`id` NOT IN (SELECT `hidden_stories`.`story_id` FROM `hidden_stories`  WHERE `hidden_stories`.`user_id` = 1)) AND (`stories`.`created_at` > '2015-12-27 16:31:29')  ORDER BY stories.id DESC, stories.created_at DESC
D, [2016-01-05T10:31:29.978277 #2768] DEBUG -- :   [1m[36mStory Load (0.4ms)[0m  [1mSELECT `stories`.`id`, `stories`.`upvotes`, `stories`.`downvotes`, `stories`.`user_id` FROM `stories`  WHERE `stories`.`merged_story_id` IS NULL AND `stories`.`is_expired` = 0 AND (`stories`.`id` NOT IN (SELECT `hidden_stories`.`story_id` FROM `hidden_stories`  WHERE `hidden_stories`.`user_id` = 1)) AND (`stories`.`created_at` > '2015-12-26 16:31:29')  ORDER BY stories.id DESC, stories.created_at DESC[0m
D, [2016-01-05T10:31:29.979310 #2768] DEBUG -- :   [1m[35mStory Load (0.4ms)[0m  SELECT `stories`.`id`, `stories`.`upvotes`, `stories`.`downvotes`, `stories`.`user_id` FROM `stories`  WHERE `stories`.`merged_story_id` IS NULL AND `stories`.`is_expired` = 0 AND (`stories`.`id` NOT IN (SELECT `hidden_stories`.`story_id` FROM `hidden_stories`  WHERE `hidden_stories`.`user_id` = 1)) AND (`stories`.`created_at` > '2015-12-25 16:31:29')  ORDER BY stories.id DESC, stories.created_at DESC
D, [2016-01-05T10:31:29.980732 #2768] DEBUG -- :   [1m[36mStory Load (0.4ms)[0m  [1mSELECT `stories`.`id`, `stories`.`upvotes`, `stories`.`downvotes`, `stories`.`user_id` FROM `stories`  WHERE `stories`.`merged_story_id` IS NULL AND `stories`.`is_expired` = 0 AND (`stories`.`id` NOT IN (SELECT `hidden_stories`.`story_id` FROM `hidden_stories`  WHERE `hidden_stories`.`user_id` = 1)) AND (`stories`.`created_at` > '2015-12-24 16:31:29')  ORDER BY stories.id DESC, stories.created_at DESC[0m
D, [2016-01-05T10:31:29.981752 #2768] DEBUG -- :   [1m[35mStory Load (0.1ms)[0m  SELECT  `stories`.* FROM `stories`  WHERE `stories`.`merged_story_id` IS NULL AND `stories`.`is_expired` = 0 AND (`stories`.`id` NOT IN (SELECT `hidden_stories`.`story_id` FROM `hidden_stories`  WHERE `hidden_stories`.`user_id` = 1))  ORDER BY stories.id DESC, stories.created_at DESC LIMIT 26 OFFSET 0
D, [2016-01-05T10:31:29.982891 #2768] DEBUG -- :   [1m[36mUser Load (0.1ms)[0m  [1mSELECT `users`.* FROM `users`  WHERE `users`.`id` IN (1)[0m
D, [2016-01-05T10:31:29.984119 #2768] DEBUG -- :   [1m[35mTagging Load (0.1ms)[0m  SELECT `taggings`.* FROM `taggings`  WHERE `taggings`.`story_id` IN (2, 1)
D, [2016-01-05T10:31:29.985776 #2768] DEBUG -- :   [1m[36mTag Load (0.3ms)[0m  [1mSELECT `tags`.* FROM `tags`  WHERE `tags`.`id` IN (1)[0m
D, [2016-01-05T10:31:29.987226 #2768] DEBUG -- :   [1m[35mVote Load (0.2ms)[0m  SELECT `votes`.* FROM `votes`  WHERE `votes`.`user_id` = 1 AND `votes`.`story_id` IN (2, 1) AND `votes`.`comment_id` IS NULL
D, [2016-01-05T10:31:29.988544 #2768] DEBUG -- :   [1m[36mHiddenStory Load (0.2ms)[0m  [1mSELECT `hidden_stories`.* FROM `hidden_stories`  WHERE `hidden_stories`.`user_id` = 1 AND `hidden_stories`.`story_id` IN (2, 1)[0m
D, [2016-01-05T10:31:30.028098 #2768] DEBUG -- :   [1m[35mKeystore Load (0.4ms)[0m  SELECT  `keystores`.* FROM `keystores`  WHERE `keystores`.`key` = 'user:1:unread_messages'  ORDER BY `keystores`.`key` ASC LIMIT 1
D, [2016-01-05T10:31:30.031072 #2768] DEBUG -- :   [1m[36m (0.2ms)[0m  [1mSELECT COUNT(*) FROM `invitation_requests`  WHERE `invitation_requests`.`is_verified` = 1[0m