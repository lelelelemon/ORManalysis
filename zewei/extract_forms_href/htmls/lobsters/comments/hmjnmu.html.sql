# Logfile created on 2016-01-05 10:31:31 -0600 by logger.rb/47272
D, [2016-01-05T10:31:31.601309 #2768] DEBUG -- :   [1m[36mUser Load (0.2ms)[0m  [1mSELECT  `users`.* FROM `users`  WHERE `users`.`session_token` = 'yMvDgquEClagp0qkFWmweNDKPFMLfRYlrUmNEDKS9vYY9ks7SltCng7dvAiw'  ORDER BY `users`.`id` ASC LIMIT 1[0m
D, [2016-01-05T10:31:31.610801 #2768] DEBUG -- :   [1m[35m (0.2ms)[0m  SELECT COUNT(*) FROM `messages`  WHERE `messages`.`author_user_id` = 1 AND `messages`.`deleted_by_author` = 0
D, [2016-01-05T10:31:31.949826 #2768] DEBUG -- :   [1m[36mKeystore Load (0.2ms)[0m  [1mSELECT  `keystores`.* FROM `keystores`  WHERE `keystores`.`key` = 'user:1:unread_messages'  ORDER BY `keystores`.`key` ASC LIMIT 1[0m
D, [2016-01-05T10:31:31.950874 #2768] DEBUG -- :   [1m[35m (0.2ms)[0m  SELECT COUNT(*) FROM `invitation_requests`  WHERE `invitation_requests`.`is_verified` = 1
