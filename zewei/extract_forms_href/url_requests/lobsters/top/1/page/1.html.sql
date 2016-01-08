# Logfile created on 2016-01-08 12:47:39 -0600 by logger.rb/47272
D, [2016-01-08T12:47:39.243284 #2716] DEBUG -- :   [1m[35mUser Load (0.2ms)[0m  SELECT  `users`.* FROM `users`  WHERE `users`.`session_token` = 'yMvDgquEClagp0qkFWmweNDKPFMLfRYlrUmNEDKS9vYY9ks7SltCng7dvAiw'  ORDER BY `users`.`id` ASC LIMIT 1
D, [2016-01-08T12:47:39.248016 #2716] DEBUG -- :   [1m[36m (0.2ms)[0m  [1mSELECT  `comments`.`thread_id` FROM `comments`  WHERE `comments`.`user_id` = 1 GROUP BY `comments`.`thread_id`  ORDER BY MAX(created_at) DESC LIMIT 20[0m
D, [2016-01-08T12:47:39.249833 #2716] DEBUG -- :   [1m[35m (0.2ms)[0m  SELECT  `comments`.`thread_id` FROM `comments` INNER JOIN `stories` ON `stories`.`id` = `comments`.`story_id` WHERE `stories`.`user_id` = 1 GROUP BY `comments`.`thread_id`  ORDER BY MAX(comments.created_at) DESC LIMIT 20
D, [2016-01-08T12:47:39.250959 #2716] DEBUG -- :   [1m[36mComment Load (0.1ms)[0m  [1mSELECT `comments`.* FROM `comments`  WHERE `comments`.`thread_id` IN (7, 5, 3, 1)  ORDER BY confidence DESC[0m
D, [2016-01-08T12:47:39.254231 #2716] DEBUG -- :   [1m[35mUser Load (0.3ms)[0m  SELECT `users`.* FROM `users`  WHERE `users`.`id` IN (1)
D, [2016-01-08T12:47:39.262627 #2716] DEBUG -- :   [1m[36mStory Load (0.2ms)[0m  [1mSELECT `stories`.* FROM `stories`  WHERE `stories`.`id` IN (2, 1)[0m
D, [2016-01-08T12:47:39.264981 #2716] DEBUG -- :   [1m[35mVote Load (0.2ms)[0m  SELECT `votes`.* FROM `votes`  WHERE `votes`.`user_id` = 1 AND `votes`.`story_id` IN (2, 1) AND (comment_id IS NOT NULL)
D, [2016-01-08T12:47:39.334277 #2716] DEBUG -- :   [1m[36mKeystore Load (0.2ms)[0m  [1mSELECT  `keystores`.* FROM `keystores`  WHERE `keystores`.`key` = 'user:1:unread_messages'  ORDER BY `keystores`.`key` ASC LIMIT 1[0m
D, [2016-01-08T12:47:39.337217 #2716] DEBUG -- :   [1m[35m (0.3ms)[0m  SELECT COUNT(*) FROM `invitation_requests`  WHERE `invitation_requests`.`is_verified` = 1
