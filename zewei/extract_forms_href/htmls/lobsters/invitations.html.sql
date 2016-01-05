# Logfile created on 2016-01-05 10:31:32 -0600 by logger.rb/47272
D, [2016-01-05T10:31:32.050899 #2768] DEBUG -- :   [1m[35mUser Load (0.2ms)[0m  SELECT  `users`.* FROM `users`  WHERE `users`.`session_token` = 'yMvDgquEClagp0qkFWmweNDKPFMLfRYlrUmNEDKS9vYY9ks7SltCng7dvAiw'  ORDER BY `users`.`id` ASC LIMIT 1
D, [2016-01-05T10:31:32.120113 #2768] DEBUG -- :   [1m[36mKeystore Load (0.1ms)[0m  [1mSELECT  `keystores`.* FROM `keystores`  WHERE `keystores`.`key` = 'user:1:unread_messages'  ORDER BY `keystores`.`key` ASC LIMIT 1[0m
D, [2016-01-05T10:31:32.121794 #2768] DEBUG -- :   [1m[35m (0.1ms)[0m  SELECT COUNT(*) FROM `invitation_requests`  WHERE `invitation_requests`.`is_verified` = 1
