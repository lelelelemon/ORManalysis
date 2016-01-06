# Logfile created on 2016-01-05 10:31:31 -0600 by logger.rb/47272
D, [2016-01-05T10:31:31.392475 #2768] DEBUG -- :   [1m[35mUser Load (0.2ms)[0m  SELECT  `users`.* FROM `users`  WHERE `users`.`session_token` = 'yMvDgquEClagp0qkFWmweNDKPFMLfRYlrUmNEDKS9vYY9ks7SltCng7dvAiw'  ORDER BY `users`.`id` ASC LIMIT 1
D, [2016-01-05T10:31:31.394327 #2768] DEBUG -- :   [1m[36mStory Load (0.2ms)[0m  [1mSELECT  `stories`.* FROM `stories`  WHERE `stories`.`short_id` = 'z7cdwv'  ORDER BY `stories`.`id` ASC LIMIT 1[0m
D, [2016-01-05T10:31:31.397667 #2768] DEBUG -- :   [1m[35mStory Load (0.2ms)[0m  SELECT `stories`.`id` FROM `stories`  WHERE `stories`.`merged_story_id` = 1
D, [2016-01-05T10:31:31.399134 #2768] DEBUG -- :   [1m[36mComment Load (0.3ms)[0m  [1mSELECT `comments`.* FROM `comments`  WHERE `comments`.`story_id` IN (1)  ORDER BY confidence DESC[0m
D, [2016-01-05T10:31:31.402248 #2768] DEBUG -- :   [1m[35mVote Load (0.2ms)[0m  SELECT  `votes`.* FROM `votes`  WHERE `votes`.`user_id` = 1 AND `votes`.`story_id` = 1 AND `votes`.`comment_id` IS NULL  ORDER BY `votes`.`id` ASC LIMIT 1
D, [2016-01-05T10:31:31.404545 #2768] DEBUG -- :   [1m[36mHiddenStory Load (0.2ms)[0m  [1mSELECT  `hidden_stories`.* FROM `hidden_stories`  WHERE `hidden_stories`.`user_id` = 1 AND `hidden_stories`.`story_id` = 1  ORDER BY `hidden_stories`.`id` ASC LIMIT 1[0m
D, [2016-01-05T10:31:31.406237 #2768] DEBUG -- :   [1m[35mVote Load (0.3ms)[0m  SELECT `votes`.* FROM `votes`  WHERE `votes`.`user_id` = 1 AND `votes`.`story_id` = 1 AND (comment_id IS NOT NULL)
D, [2016-01-05T10:31:31.412016 #2768] DEBUG -- :   [1m[36mTagging Load (0.2ms)[0m  [1mSELECT `taggings`.* FROM `taggings`  WHERE `taggings`.`story_id` = 1[0m
D, [2016-01-05T10:31:31.413317 #2768] DEBUG -- :   [1m[35mTag Load (0.1ms)[0m  SELECT  `tags`.* FROM `tags`  WHERE `tags`.`id` = 1 LIMIT 1
D, [2016-01-05T10:31:31.415134 #2768] DEBUG -- :   [1m[36mStory Load (0.2ms)[0m  [1mSELECT `stories`.* FROM `stories`  WHERE `stories`.`merged_story_id` = 1[0m
D, [2016-01-05T10:31:31.416263 #2768] DEBUG -- :   [1m[35mUser Load (0.0ms)[0m  SELECT  `users`.* FROM `users`  WHERE `users`.`id` = 1 LIMIT 1
D, [2016-01-05T10:31:31.419519 #2768] DEBUG -- :   [1m[36m (0.2ms)[0m  [1mSELECT COUNT(*) FROM `hidden_stories`  WHERE `hidden_stories`.`story_id` = 1[0m
D, [2016-01-05T10:31:31.422962 #2768] DEBUG -- :   [1m[35mHat Exists (0.2ms)[0m  SELECT  1 AS one FROM `hats`  WHERE `hats`.`user_id` = 1 LIMIT 1
D, [2016-01-05T10:31:31.459269 #2768] DEBUG -- :   [1m[36mKeystore Load (0.2ms)[0m  [1mSELECT  `keystores`.* FROM `keystores`  WHERE `keystores`.`key` = 'user:1:unread_messages'  ORDER BY `keystores`.`key` ASC LIMIT 1[0m
D, [2016-01-05T10:31:31.461275 #2768] DEBUG -- :   [1m[35m (0.2ms)[0m  SELECT COUNT(*) FROM `invitation_requests`  WHERE `invitation_requests`.`is_verified` = 1
