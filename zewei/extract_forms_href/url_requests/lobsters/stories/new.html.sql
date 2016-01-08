# Logfile created on 2016-01-08 12:47:39 -0600 by logger.rb/47272
D, [2016-01-08T12:47:39.916823 #2716] DEBUG -- :   [1m[35mStory Load (0.4ms)[0m  SELECT  `stories`.* FROM `stories`  WHERE `stories`.`short_id` = 'z7cdwv'  ORDER BY `stories`.`id` ASC LIMIT 1
D, [2016-01-08T12:47:39.919376 #2716] DEBUG -- :   [1m[36mStory Load (0.2ms)[0m  [1mSELECT `stories`.`id` FROM `stories`  WHERE `stories`.`merged_story_id` = 1[0m
D, [2016-01-08T12:47:39.921268 #2716] DEBUG -- :   [1m[35mComment Load (0.2ms)[0m  SELECT `comments`.* FROM `comments`  WHERE `comments`.`story_id` IN (1)  ORDER BY confidence DESC
D, [2016-01-08T12:47:39.925014 #2716] DEBUG -- :   [1m[36mUser Load (0.3ms)[0m  [1mSELECT `users`.* FROM `users`  WHERE `users`.`id` IN (1)[0m
D, [2016-01-08T12:47:39.926334 #2716] DEBUG -- :   [1m[35mStory Load (0.2ms)[0m  SELECT `stories`.* FROM `stories`  WHERE `stories`.`id` IN (1)
D, [2016-01-08T12:47:39.933119 #2716] DEBUG -- :   [1m[36mTagging Load (0.2ms)[0m  [1mSELECT `taggings`.* FROM `taggings`  WHERE `taggings`.`story_id` = 1[0m
D, [2016-01-08T12:47:39.934627 #2716] DEBUG -- :   [1m[35mTag Load (0.2ms)[0m  SELECT  `tags`.* FROM `tags`  WHERE `tags`.`id` = 1 LIMIT 1
D, [2016-01-08T12:47:39.938264 #2716] DEBUG -- :   [1m[36mStory Load (0.3ms)[0m  [1mSELECT `stories`.* FROM `stories`  WHERE `stories`.`merged_story_id` = 1[0m
D, [2016-01-08T12:47:39.939873 #2716] DEBUG -- :   [1m[35mUser Load (0.3ms)[0m  SELECT  `users`.* FROM `users`  WHERE `users`.`id` = 1 LIMIT 1
