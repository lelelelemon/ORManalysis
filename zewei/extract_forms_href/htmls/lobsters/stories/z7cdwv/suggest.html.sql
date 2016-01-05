# Logfile created on 2016-01-05 10:31:31 -0600 by logger.rb/47272
D, [2016-01-05T10:31:31.580605 #2768] DEBUG -- :   [1m[35mUser Load (0.5ms)[0m  SELECT  `users`.* FROM `users`  WHERE `users`.`session_token` = 'yMvDgquEClagp0qkFWmweNDKPFMLfRYlrUmNEDKS9vYY9ks7SltCng7dvAiw'  ORDER BY `users`.`id` ASC LIMIT 1
D, [2016-01-05T10:31:31.582992 #2768] DEBUG -- :   [1m[36mComment Load (0.3ms)[0m  [1mSELECT  `comments`.* FROM `comments`  WHERE `comments`.`short_id` = 'hmjnmu'  ORDER BY `comments`.`id` ASC LIMIT 1[0m
D, [2016-01-05T10:31:31.585111 #2768] DEBUG -- :   [1m[35mVote Load (0.4ms)[0m  SELECT  `votes`.* FROM `votes`  WHERE `votes`.`user_id` = 1 AND `votes`.`story_id` = 2 AND `votes`.`comment_id` = 1  ORDER BY `votes`.`id` ASC LIMIT 1
