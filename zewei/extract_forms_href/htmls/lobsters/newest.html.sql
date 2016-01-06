# Logfile created on 2016-01-05 10:31:29 -0600 by logger.rb/47272
D, [2016-01-05T10:31:29.784839 #2768] DEBUG -- :   [1m[35mUser Load (0.1ms)[0m  SELECT  `users`.* FROM `users`  WHERE `users`.`session_token` = 'yMvDgquEClagp0qkFWmweNDKPFMLfRYlrUmNEDKS9vYY9ks7SltCng7dvAiw'  ORDER BY `users`.`id` ASC LIMIT 1
D, [2016-01-05T10:31:29.786840 #2768] DEBUG -- :   [1m[36mTagFilter Load (0.1ms)[0m  [1mSELECT `tag_filters`.* FROM `tag_filters`  WHERE `tag_filters`.`user_id` = 1[0m
D, [2016-01-05T10:31:29.788002 #2768] DEBUG -- :   [1m[35mStory Load (0.1ms)[0m  SELECT  `stories`.* FROM `stories`  WHERE `stories`.`merged_story_id` IS NULL AND `stories`.`is_expired` = 0 AND (`stories`.`id` NOT IN (SELECT `hidden_stories`.`story_id` FROM `hidden_stories`  WHERE `hidden_stories`.`user_id` = 1))  ORDER BY stories.id DESC LIMIT 26 OFFSET 0
D, [2016-01-05T10:31:29.789173 #2768] DEBUG -- :   [1m[36mUser Load (0.1ms)[0m  [1mSELECT `users`.* FROM `users`  WHERE `users`.`id` IN (1)[0m
D, [2016-01-05T10:31:29.790005 #2768] DEBUG -- :   [1m[35mTagging Load (0.1ms)[0m  SELECT `taggings`.* FROM `taggings`  WHERE `taggings`.`story_id` IN (2, 1)
D, [2016-01-05T10:31:29.790830 #2768] DEBUG -- :   [1m[36mTag Load (0.1ms)[0m  [1mSELECT `tags`.* FROM `tags`  WHERE `tags`.`id` IN (1)[0m
D, [2016-01-05T10:31:29.791520 #2768] DEBUG -- :   [1m[35mVote Load (0.0ms)[0m  SELECT `votes`.* FROM `votes`  WHERE `votes`.`user_id` = 1 AND `votes`.`story_id` IN (2, 1) AND `votes`.`comment_id` IS NULL
D, [2016-01-05T10:31:29.793021 #2768] DEBUG -- :   [1m[36mHiddenStory Load (0.2ms)[0m  [1mSELECT `hidden_stories`.* FROM `hidden_stories`  WHERE `hidden_stories`.`user_id` = 1 AND `hidden_stories`.`story_id` IN (2, 1)[0m
D, [2016-01-05T10:31:29.839656 #2768] DEBUG -- :   [1m[35mKeystore Load (0.3ms)[0m  SELECT  `keystores`.* FROM `keystores`  WHERE `keystores`.`key` = 'user:1:unread_messages'  ORDER BY `keystores`.`key` ASC LIMIT 1
D, [2016-01-05T10:31:29.843100 #2768] DEBUG -- :   [1m[36m (0.5ms)[0m  [1mSELECT COUNT(*) FROM `invitation_requests`  WHERE `invitation_requests`.`is_verified` = 1[0m
