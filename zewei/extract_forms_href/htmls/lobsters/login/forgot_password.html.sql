# Logfile created on 2016-01-05 10:31:31 -0600 by logger.rb/47272
D, [2016-01-05T10:31:31.287798 #2768] DEBUG -- :   [1m[35mUser Load (0.3ms)[0m  SELECT  `users`.* FROM `users`  WHERE `users`.`session_token` = 'yMvDgquEClagp0qkFWmweNDKPFMLfRYlrUmNEDKS9vYY9ks7SltCng7dvAiw'  ORDER BY `users`.`id` ASC LIMIT 1
D, [2016-01-05T10:31:31.309260 #2768] DEBUG -- :   [1m[36m (0.3ms)[0m  [1mSELECT COUNT(*) AS count_all, tag_id AS tag_id FROM `tag_filters`  GROUP BY `tag_filters`.`tag_id`[0m
D, [2016-01-05T10:31:31.310390 #2768] DEBUG -- :   [1m[35mTag Load (0.2ms)[0m  SELECT `tags`.* FROM `tags`  WHERE `tags`.`inactive` = 0  ORDER BY `tags`.`tag` ASC
D, [2016-01-05T10:31:31.318325 #2768] DEBUG -- :   [1m[36mKeystore Load (1.2ms)[0m  [1mSELECT  `keystores`.* FROM `keystores`  WHERE `keystores`.`key` = 'user:1:stories_submitted'  ORDER BY `keystores`.`key` ASC LIMIT 1[0m
D, [2016-01-05T10:31:31.374991 #2768] DEBUG -- :   [1m[35mKeystore Load (0.2ms)[0m  SELECT  `keystores`.* FROM `keystores`  WHERE `keystores`.`key` = 'user:1:unread_messages'  ORDER BY `keystores`.`key` ASC LIMIT 1
D, [2016-01-05T10:31:31.379196 #2768] DEBUG -- :   [1m[36m (0.2ms)[0m  [1mSELECT COUNT(*) FROM `invitation_requests`  WHERE `invitation_requests`.`is_verified` = 1[0m
