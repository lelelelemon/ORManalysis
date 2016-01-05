# Logfile created on 2016-01-05 10:31:30 -0600 by logger.rb/47272
D, [2016-01-05T10:31:30.957227 #2768] DEBUG -- :   [1m[36mUser Load (0.2ms)[0m  [1mSELECT  `users`.* FROM `users`  WHERE `users`.`session_token` = 'yMvDgquEClagp0qkFWmweNDKPFMLfRYlrUmNEDKS9vYY9ks7SltCng7dvAiw'  ORDER BY `users`.`id` ASC LIMIT 1[0m
D, [2016-01-05T10:31:30.963089 #2768] DEBUG -- :   [1m[35m (0.3ms)[0m  SELECT  `comments`.`thread_id` FROM `comments`  WHERE `comments`.`user_id` = 1 GROUP BY `comments`.`thread_id`  ORDER BY MAX(created_at) DESC LIMIT 20
D, [2016-01-05T10:31:30.965030 #2768] DEBUG -- :   [1m[36m (0.2ms)[0m  [1mSELECT  `comments`.`thread_id` FROM `comments` INNER JOIN `stories` ON `stories`.`id` = `comments`.`story_id` WHERE `stories`.`user_id` = 1 GROUP BY `comments`.`thread_id`  ORDER BY MAX(comments.created_at) DESC LIMIT 20[0m
D, [2016-01-05T10:31:30.973812 #2768] DEBUG -- :   [1m[35mComment Load (0.9ms)[0m  SELECT `comments`.* FROM `comments`  WHERE `comments`.`thread_id` IN (1)  ORDER BY confidence DESC
D, [2016-01-05T10:31:30.981072 #2768] DEBUG -- :   [1m[36mUser Load (4.8ms)[0m  [1mSELECT `users`.* FROM `users`  WHERE `users`.`id` IN (1)[0m
D, [2016-01-05T10:31:30.992699 #2768] DEBUG -- :   [1m[35mStory Load (0.2ms)[0m  SELECT `stories`.* FROM `stories`  WHERE `stories`.`id` IN (2)
D, [2016-01-05T10:31:30.994390 #2768] DEBUG -- :   [1m[36mVote Load (0.2ms)[0m  [1mSELECT `votes`.* FROM `votes`  WHERE `votes`.`user_id` = 1 AND `votes`.`story_id` IN (2) AND (comment_id IS NOT NULL)[0m
D, [2016-01-05T10:31:31.051079 #2768] DEBUG -- :   [1m[35mKeystore Load (0.2ms)[0m  SELECT  `keystores`.* FROM `keystores`  WHERE `keystores`.`key` = 'user:1:unread_messages'  ORDER BY `keystores`.`key` ASC LIMIT 1
D, [2016-01-05T10:31:31.053512 #2768] DEBUG -- :   [1m[36m (0.2ms)[0m  [1mSELECT COUNT(*) FROM `invitation_requests`  WHERE `invitation_requests`.`is_verified` = 1[0m
