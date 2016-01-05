# Logfile created on 2016-01-05 10:31:31 -0600 by logger.rb/47272
D, [2016-01-05T10:31:31.966262 #2768] DEBUG -- :   [1m[36mUser Load (0.2ms)[0m  [1mSELECT  `users`.* FROM `users`  WHERE `users`.`session_token` = 'yMvDgquEClagp0qkFWmweNDKPFMLfRYlrUmNEDKS9vYY9ks7SltCng7dvAiw'  ORDER BY `users`.`id` ASC LIMIT 1[0m
D, [2016-01-05T10:31:31.972733 #2768] DEBUG -- :   [1m[35mInvitationRequest Load (0.2ms)[0m  SELECT `invitation_requests`.* FROM `invitation_requests`  WHERE `invitation_requests`.`is_verified` = 1
D, [2016-01-05T10:31:31.974099 #2768] DEBUG -- :   [1m[36m (0.2ms)[0m  [1mSELECT COUNT(*) FROM `invitation_requests`  WHERE `invitation_requests`.`is_verified` = 1[0m
D, [2016-01-05T10:31:32.036078 #2768] DEBUG -- :   [1m[35mKeystore Load (0.1ms)[0m  SELECT  `keystores`.* FROM `keystores`  WHERE `keystores`.`key` = 'user:1:unread_messages'  ORDER BY `keystores`.`key` ASC LIMIT 1
D, [2016-01-05T10:31:32.037478 #2768] DEBUG -- :   [1m[36mCACHE (0.0ms)[0m  [1mSELECT COUNT(*) FROM `invitation_requests`  WHERE `invitation_requests`.`is_verified` = 1[0m
