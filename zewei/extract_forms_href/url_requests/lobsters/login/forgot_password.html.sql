# Logfile created on 2016-01-08 12:47:39 -0600 by logger.rb/47272
D, [2016-01-08T12:47:39.640265 #2716] DEBUG -- :   [1m[35mTag Load (0.3ms)[0m  SELECT  `tags`.* FROM `tags`  WHERE `tags`.`tag` = 'test'  ORDER BY `tags`.`id` ASC LIMIT 1
D, [2016-01-08T12:47:39.641558 #2716] DEBUG -- :   [1m[36mTag Load (0.2ms)[0m  [1mSELECT `tags`.* FROM `tags`  WHERE 1=0[0m
D, [2016-01-08T12:47:39.644097 #2716] DEBUG -- :   [1m[35mStory Load (0.4ms)[0m  SELECT  `stories`.* FROM `stories`  WHERE `stories`.`merged_story_id` IS NULL AND `stories`.`is_expired` = 0 AND ((CAST(upvotes AS signed) - CAST(downvotes AS signed)) >= -1) AND `stories`.`id` IN (SELECT `taggings`.`story_id` FROM `taggings`  WHERE `taggings`.`tag_id` = 1)  ORDER BY stories.created_at DESC LIMIT 26 OFFSET 0
D, [2016-01-08T12:47:39.647482 #2716] DEBUG -- :   [1m[36mUser Load (0.3ms)[0m  [1mSELECT `users`.* FROM `users`  WHERE `users`.`id` IN (1)[0m
D, [2016-01-08T12:47:39.650192 #2716] DEBUG -- :   [1m[35mTagging Load (0.3ms)[0m  SELECT `taggings`.* FROM `taggings`  WHERE `taggings`.`story_id` IN (3, 2, 1)
D, [2016-01-08T12:47:39.654744 #2716] DEBUG -- :   [1m[36mTag Load (0.2ms)[0m  [1mSELECT `tags`.* FROM `tags`  WHERE `tags`.`id` IN (1)[0m
