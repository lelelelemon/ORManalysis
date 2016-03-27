
signup as congyan
[60b3386d-16b4-4c5b-b81c-e2de373dc83b] Started GET "/users/profile/congyan" for 127.0.0.1 at 2015-10-06 10:33:42 -0700
[60b3386d-16b4-4c5b-b81c-e2de373dc83b] Processing by UsersController#show as HTML
[60b3386d-16b4-4c5b-b81c-e2de373dc83b]   Parameters: {"id"=>"congyan"}
[60b3386d-16b4-4c5b-b81c-e2de373dc83b]   User Load (0.9ms)  SELECT  `users`.* FROM `users` WHERE `users`.`id` = 1 LIMIT 1
[60b3386d-16b4-4c5b-b81c-e2de373dc83b] Authenticated as user:1 (congyan)
[60b3386d-16b4-4c5b-b81c-e2de373dc83b]   User Load (0.7ms)  SELECT  `users`.* FROM `users` WHERE `users`.`username` = 'congyan' LIMIT 1
[60b3386d-16b4-4c5b-b81c-e2de373dc83b]    (0.4ms)  SELECT COUNT(*) FROM `exchanges` WHERE `exchanges`.`type` IN ('Discussion') AND `exchanges`.`poster_id` = 1
[60b3386d-16b4-4c5b-b81c-e2de373dc83b]    (0.4ms)  SELECT COUNT(*) FROM `exchanges` INNER JOIN `discussion_relationships` ON `exchanges`.`id` = `discussion_relationships`.`discussion_id` WHERE `exchanges`.`type` IN ('Discussion') AND `discussion_relationships`.`user_id` = 1 AND `exchanges`.`type` IN ('Discussion') AND `discussion_relationships`.`participated` = 1
[60b3386d-16b4-4c5b-b81c-e2de373dc83b]    (0.3ms)  SELECT COUNT(*) FROM `posts` WHERE `posts`.`user_id` = 1 AND `posts`.`conversation` = 0
[60b3386d-16b4-4c5b-b81c-e2de373dc83b]    (0.3ms)  SELECT COUNT(*) FROM `users` WHERE `users`.`inviter_id` = 1
[60b3386d-16b4-4c5b-b81c-e2de373dc83b]   Post Load (0.3ms)  SELECT  `posts`.* FROM `posts` WHERE `posts`.`user_id` = 1 AND `posts`.`conversation` = 0  ORDER BY created_at DESC LIMIT 15 OFFSET 0
[60b3386d-16b4-4c5b-b81c-e2de373dc83b]   Rendered users/show.html.erb within layouts/application (57.2ms)
[60b3386d-16b4-4c5b-b81c-e2de373dc83b]    (0.5ms)  SELECT COUNT(*) FROM `conversation_relationships` WHERE `conversation_relationships`.`user_id` = 1 AND `conversation_relationships`.`new_posts` = 1
[60b3386d-16b4-4c5b-b81c-e2de373dc83b]    (0.3ms)  SELECT COUNT(*) FROM `invites` WHERE `invites`.`user_id` = 1

>>>>>>>>>>>>>>>>>>>>

click "conversation"

[9178bf11-01f6-4d24-9650-bdf22da7df1a] Started GET "/conversations" for 127.0.0.1 at 2015-10-06 10:34:54 -0700
[9178bf11-01f6-4d24-9650-bdf22da7df1a] Processing by ConversationsController#index as HTML
[9178bf11-01f6-4d24-9650-bdf22da7df1a]   User Load (0.3ms)  SELECT  `users`.* FROM `users` WHERE `users`.`id` = 1 LIMIT 1
[9178bf11-01f6-4d24-9650-bdf22da7df1a] Authenticated as user:1 (congyan)
[9178bf11-01f6-4d24-9650-bdf22da7df1a]   Conversation Load (1.0ms)  SELECT  `exchanges`.* FROM `exchanges` INNER JOIN `conversation_relationships` ON `exchanges`.`id` = `conversation_relationships`.`conversation_id` WHERE `exchanges`.`type` IN ('Conversation') AND `conversation_relationships`.`user_id` = 1  ORDER BY sticky DESC, last_post_at DESC LIMIT 30 OFFSET 0
[9178bf11-01f6-4d24-9650-bdf22da7df1a]    (0.3ms)  SELECT COUNT(*) FROM `exchanges` WHERE `exchanges`.`type` IN ('Discussion')
[9178bf11-01f6-4d24-9650-bdf22da7df1a]   Rendered discussions/_sidebar.html.erb (5.6ms)
[9178bf11-01f6-4d24-9650-bdf22da7df1a]   Rendered exchanges/_table.html.erb (3.1ms)
[9178bf11-01f6-4d24-9650-bdf22da7df1a]   Rendered conversations/index.html.erb within layouts/application (13.1ms)
[9178bf11-01f6-4d24-9650-bdf22da7df1a]    (0.2ms)  SELECT COUNT(*) FROM `conversation_relationships` WHERE `conversation_relationships`.`user_id` = 1 AND `conversation_relationships`.`new_posts` = 1
[9178bf11-01f6-4d24-9650-bdf22da7df1a]    (0.2ms)  SELECT COUNT(*) FROM `invites` WHERE `invites`.`user_id` = 1
[9178bf11-01f6-4d24-9650-bdf22da7df1a] Completed 200 OK in 85ms (Views: 42.4ms | ActiveRecord: 2.1ms | Solr: 0.0ms)


>>>>>>>>>>>>>>>>>>>>
click "discussion"
[1000fb3b-c3b7-4089-bd86-39779d82a668] Started GET "/discussions" for 127.0.0.1 at 2015-10-06 10:35:41 -0700
[1000fb3b-c3b7-4089-bd86-39779d82a668] Processing by DiscussionsController#index as HTML
[1000fb3b-c3b7-4089-bd86-39779d82a668]   User Load (0.4ms)  SELECT  `users`.* FROM `users` WHERE `users`.`id` = 1 LIMIT 1
[1000fb3b-c3b7-4089-bd86-39779d82a668] Authenticated as user:1 (congyan)
[1000fb3b-c3b7-4089-bd86-39779d82a668]   Discussion Load (0.9ms)  SELECT `exchanges`.* FROM `exchanges` INNER JOIN `discussion_relationships` ON `exchanges`.`id` = `discussion_relationships`.`discussion_id` WHERE `exchanges`.`type` IN ('Discussion') AND `discussion_relationships`.`user_id` = 1 AND `exchanges`.`type` IN ('Discussion') AND `discussion_relationships`.`hidden` = 1
[1000fb3b-c3b7-4089-bd86-39779d82a668]   Discussion Load (0.5ms)  SELECT  `exchanges`.* FROM `exchanges` WHERE `exchanges`.`type` IN ('Discussion') AND (NOT (1=0))  ORDER BY sticky DESC, last_post_at DESC LIMIT 30 OFFSET 0
[1000fb3b-c3b7-4089-bd86-39779d82a668]    (0.2ms)  SELECT COUNT(*) FROM `exchanges` WHERE `exchanges`.`type` IN ('Discussion')
[1000fb3b-c3b7-4089-bd86-39779d82a668]   Rendered discussions/_sidebar.html.erb (2.8ms)
[1000fb3b-c3b7-4089-bd86-39779d82a668]   Rendered exchanges/_table.html.erb (2.5ms)
[1000fb3b-c3b7-4089-bd86-39779d82a668]   Rendered discussions/index.html.erb within layouts/application (9.1ms)
[1000fb3b-c3b7-4089-bd86-39779d82a668]    (0.2ms)  SELECT COUNT(*) FROM `conversation_relationships` WHERE `conversation_relationships`.`user_id` = 1 AND `conversation_relationships`.`new_posts` = 1
[1000fb3b-c3b7-4089-bd86-39779d82a668]    (0.2ms)  SELECT COUNT(*) FROM `invites` WHERE `invites`.`user_id` = 1



>>>>>>>>>>>>>>>>>>>>>>>
click create discussion
[9ad85b86-0411-4c4d-9dfb-7ac4c56e258c] Started GET "/discussions/new" for 127.0.0.1 at 2015-10-06 10:36:03 -0700
[9ad85b86-0411-4c4d-9dfb-7ac4c56e258c] Processing by DiscussionsController#new as HTML
[9ad85b86-0411-4c4d-9dfb-7ac4c56e258c]   User Load (0.3ms)  SELECT  `users`.* FROM `users` WHERE `users`.`id` = 1 LIMIT 1
[9ad85b86-0411-4c4d-9dfb-7ac4c56e258c] Authenticated as user:1 (congyan)
[9ad85b86-0411-4c4d-9dfb-7ac4c56e258c]   Rendered exchanges/_form.html.erb (66.0ms)
[9ad85b86-0411-4c4d-9dfb-7ac4c56e258c]   Rendered exchanges/new.html.erb within layouts/application (71.3ms)
[9ad85b86-0411-4c4d-9dfb-7ac4c56e258c]    (0.4ms)  SELECT COUNT(*) FROM `conversation_relationships` WHERE `conversation_relationships`.`user_id` = 1 AND `conversation_relationships`.`new_posts` = 1
[9ad85b86-0411-4c4d-9dfb-7ac4c56e258c]    (0.2ms)  SELECT COUNT(*) FROM `invites` WHERE `invites`.`user_id` = 1
[9ad85b86-0411-4c4d-9dfb-7ac4c56e258c] Completed 200 OK in 131ms (Views: 90.1ms | ActiveRecord: 1.0ms | Solr: 0.0ms)
[04204bc6-1f59-4add-99ea-b73850a77375]


>>>>>>>>>>>>>>>>
create discussion
User Load (0.7ms)  SELECT  `users`.* FROM `users` WHERE `users`.`id` = 1 LIMIT 1
[6cbc5d06-41dc-4e28-aa0c-ae2610321c8b] Authenticated as user:1 (congyan)
[6cbc5d06-41dc-4e28-aa0c-ae2610321c8b] Unpermitted parameter: type
D, [2015-10-23T04:00:57.808303 #51007] DEBUG -- :    (0.3ms)  BEGIN
D, [2015-10-23T04:00:57.814999 #51007] DEBUG -- :   SQL (0.7ms)  INSERT INTO `exchanges` (`type`, `title`, `trusted`, `poster_id`, `created_at`, `updated_at`) VALUES ('Discussion', 'Sugar conf new discussion', 1, 1, '2015-10-23 11:00:57', '2015-10-23 11:00:57')
D, [2015-10-23T04:00:57.854404 #51007] DEBUG -- :   Exchange Load (0.6ms)  SELECT  `exchanges`.* FROM `exchanges` WHERE `exchanges`.`id` = 6 LIMIT 1
D, [2015-10-23T04:00:57.900889 #51007] DEBUG -- :   SQL (0.5ms)  INSERT INTO `posts` (`user_id`, `body`, `exchange_id`, `edited_at`, `trusted`, `body_html`, `created_at`, `updated_at`) VALUES (1, 'Copyright (c) 2008 Inge Jørgensen\r\n\r\nPermission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\r\n\r\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\r\n\r\nTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.', 6, '2015-10-23 11:00:57', 1, '<p>Copyright (c) 2008 Inge Jørgensen</p>\n\n<p>Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:</p>\n\n<p>The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.</p>\n\n<p>THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.</p>\n', '2015-10-23 11:00:57', '2015-10-23 11:00:57')
D, [2015-10-23T04:00:57.902498 #51007] DEBUG -- :   SQL (0.4ms)  UPDATE `users` SET `posts_count` = COALESCE(`posts_count`, 0) + 1 WHERE `users`.`id` = 1
D, [2015-10-23T04:00:57.903401 #51007] DEBUG -- :   SQL (0.2ms)  UPDATE `exchanges` SET `posts_count` = COALESCE(`posts_count`, 0) + 1 WHERE `exchanges`.`id` = 6
D, [2015-10-23T04:00:57.906130 #51007] DEBUG -- :   SQL (0.2ms)  UPDATE `exchanges` SET `last_poster_id` = 1, `last_post_at` = '2015-10-23 11:00:57', `updated_at` = '2015-10-23 11:00:57' WHERE `exchanges`.`id` = 6
[6cbc5d06-41dc-4e28-aa0c-ae2610321c8b]   SOLR Request (8.0ms)  [ path=update parameters={} ]
D, [2015-10-23T04:00:57.920867 #51007] DEBUG -- :    (0.2ms)  ROLLBACK


>>>>>>>>>>>>>>>>>>>>>>>

click favorite
[f916b7cd-ed42-4164-8640-66e4abe08ddd] Started GET "/discussions/favorites" for 127.0.0.1 at 2015-10-06 10:39:26 -0700
[f916b7cd-ed42-4164-8640-66e4abe08ddd] Processing by DiscussionsController#favorites as HTML
[f916b7cd-ed42-4164-8640-66e4abe08ddd]   User Load (0.4ms)  SELECT  `users`.* FROM `users` WHERE `users`.`id` = 1 LIMIT 1
[f916b7cd-ed42-4164-8640-66e4abe08ddd] Authenticated as user:1 (congyan)
[f916b7cd-ed42-4164-8640-66e4abe08ddd]   Discussion Load (0.9ms)  SELECT  `exchanges`.* FROM `exchanges` INNER JOIN `discussion_relationships` ON `exchanges`.`id` = `discussion_relationships`.`discussion_id` WHERE `exchanges`.`type` IN ('Discussion') AND `discussion_relationships`.`user_id` = 1 AND `exchanges`.`type` IN ('Discussion') AND `discussion_relationships`.`favorite` = 1  ORDER BY sticky DESC, last_post_at DESC LIMIT 30 OFFSET 0
[f916b7cd-ed42-4164-8640-66e4abe08ddd]    (0.2ms)  SELECT COUNT(*) FROM `exchanges` WHERE `exchanges`.`type` IN ('Discussion')
[f916b7cd-ed42-4164-8640-66e4abe08ddd]   Rendered discussions/_sidebar.html.erb (2.5ms)
[f916b7cd-ed42-4164-8640-66e4abe08ddd]   Rendered exchanges/_table.html.erb (0.1ms)
[f916b7cd-ed42-4164-8640-66e4abe08ddd]   Rendered discussions/favorites.html.erb within layouts/application (35.2ms)
[f916b7cd-ed42-4164-8640-66e4abe08ddd]    (0.2ms)  SELECT COUNT(*) FROM `conversation_relationships` WHERE `conversation_relationships`.`user_id` = 1 AND `conversation_relationships`.`new_posts` = 1
[f916b7cd-ed42-4164-8640-66e4abe08ddd]    (0.2ms)  SELECT COUNT(*) FROM `invites` WHERE `invites`.`user_id` = 1
[f916b7cd-ed42-4164-8640-66e4abe08ddd] Completed 200 OK in 66ms (Views: 50.8ms | ActiveRecord: 1.9ms | Solr: 0.0ms)

>>>>>>>>>>>>>>>>>>>
click on one discussion


[8b52dca2-ef28-4509-9f7a-dadc793b0090] Started GET "/discussions/2-This-is-the-title-of-the-first-discussion" for 127.0.0.1 at 2015-10-06 10:41:49 -0700
[8b52dca2-ef28-4509-9f7a-dadc793b0090] Processing by DiscussionsController#show as HTML
[8b52dca2-ef28-4509-9f7a-dadc793b0090]   Parameters: {"id"=>"2-This-is-the-title-of-the-first-discussion"}
[8b52dca2-ef28-4509-9f7a-dadc793b0090]   User Load (0.3ms)  SELECT  `users`.* FROM `users` WHERE `users`.`id` = 1 LIMIT 1
[8b52dca2-ef28-4509-9f7a-dadc793b0090] Authenticated as user:1 (congyan)
[8b52dca2-ef28-4509-9f7a-dadc793b0090]   Exchange Load (0.8ms)  SELECT  `exchanges`.* FROM `exchanges` WHERE `exchanges`.`id` = 2 LIMIT 1
[8b52dca2-ef28-4509-9f7a-dadc793b0090]   Post Load (0.8ms)  SELECT  `posts`.* FROM `posts` WHERE `posts`.`exchange_id` = 2  ORDER BY created_at ASC LIMIT 50 OFFSET 0
[8b52dca2-ef28-4509-9f7a-dadc793b0090]   User Load (0.3ms)  SELECT `users`.* FROM `users` WHERE `users`.`id` IN (1)
[8b52dca2-ef28-4509-9f7a-dadc793b0090]    (0.7ms)  SELECT COUNT(count_column) FROM (SELECT  1 AS count_column FROM `posts` WHERE `posts`.`exchange_id` = 2 LIMIT 50 OFFSET 0) subquery_for_count
[8b52dca2-ef28-4509-9f7a-dadc793b0090]   ExchangeView Load (0.4ms)  SELECT  `exchange_views`.* FROM `exchange_views` WHERE `exchange_views`.`user_id` = 1 AND `exchange_views`.`exchange_id` = 2  ORDER BY `exchange_views`.`id` ASC LIMIT 1
[8b52dca2-ef28-4509-9f7a-dadc793b0090]    (0.2ms)  BEGIN
[8b52dca2-ef28-4509-9f7a-dadc793b0090]   SQL (0.5ms)  INSERT INTO `exchange_views` (`exchange_id`, `user_id`, `post_index`, `post_id`) VALUES (2, 1, 1, 2)
[8b52dca2-ef28-4509-9f7a-dadc793b0090]    (0.2ms)  COMMIT
[8b52dca2-ef28-4509-9f7a-dadc793b0090]    (0.4ms)  SELECT COUNT(*) FROM `posts` WHERE `posts`.`exchange_id` = 2
[8b52dca2-ef28-4509-9f7a-dadc793b0090]   CACHE (0.0ms)  SELECT COUNT(*) FROM `posts` WHERE `posts`.`exchange_id` = 2  [["exchange_id", 2]]
[8b52dca2-ef28-4509-9f7a-dadc793b0090]   DiscussionRelationship Load (0.4ms)  SELECT  `discussion_relationships`.* FROM `discussion_relationships` WHERE `discussion_relationships`.`user_id` = 1 AND `discussion_relationships`.`discussion_id` = 2  ORDER BY `discussion_relationships`.`id` ASC LIMIT 1
[8b52dca2-ef28-4509-9f7a-dadc793b0090]   CACHE (0.0ms)  SELECT COUNT(*) FROM `posts` WHERE `posts`.`exchange_id` = 2  [["exchange_id", 2]]
[8b52dca2-ef28-4509-9f7a-dadc793b0090]   CACHE (0.0ms)  SELECT  `discussion_relationships`.* FROM `discussion_relationships` WHERE `discussion_relationships`.`user_id` = 1 AND `discussion_relationships`.`discussion_id` = 2  ORDER BY `discussion_relationships`.`id` ASC LIMIT 1  [["user_id", 1], ["discussion_id", 2]]
[8b52dca2-ef28-4509-9f7a-dadc793b0090]   CACHE (0.0ms)  SELECT COUNT(*) FROM `posts` WHERE `posts`.`exchange_id` = 2  [["exchange_id", 2]]
[8b52dca2-ef28-4509-9f7a-dadc793b0090]   CACHE (0.0ms)  SELECT  `discussion_relationships`.* FROM `discussion_relationships` WHERE `discussion_relationships`.`user_id` = 1 AND `discussion_relationships`.`discussion_id` = 2  ORDER BY `discussion_relationships`.`id` ASC LIMIT 1  [["user_id", 1], ["discussion_id", 2]]
[8b52dca2-ef28-4509-9f7a-dadc793b0090]   CACHE (0.0ms)  SELECT COUNT(*) FROM `posts` WHERE `posts`.`exchange_id` = 2  [["exchange_id", 2]]
[8b52dca2-ef28-4509-9f7a-dadc793b0090]   CACHE (0.0ms)  SELECT COUNT(*) FROM `posts` WHERE `posts`.`exchange_id` = 2  [["exchange_id", 2]]
[8b52dca2-ef28-4509-9f7a-dadc793b0090]   CACHE (0.0ms)  SELECT COUNT(*) FROM `posts` WHERE `posts`.`exchange_id` = 2  [["exchange_id", 2]]
[8b52dca2-ef28-4509-9f7a-dadc793b0090]   Rendered components/_pagination.html.erb (4.5ms)
[8b52dca2-ef28-4509-9f7a-dadc793b0090]   Exchange Load (0.2ms)  SELECT  `exchanges`.* FROM `exchanges` WHERE `exchanges`.`id` = 2 LIMIT 1
[8b52dca2-ef28-4509-9f7a-dadc793b0090]   CACHE (0.0ms)  SELECT COUNT(*) FROM `posts` WHERE `posts`.`exchange_id` = 2  [["exchange_id", 2]]
[8b52dca2-ef28-4509-9f7a-dadc793b0090]   Rendered posts/_post.html.erb (18.1ms)
[8b52dca2-ef28-4509-9f7a-dadc793b0090]   CACHE (0.0ms)  SELECT COUNT(*) FROM `posts` WHERE `posts`.`exchange_id` = 2  [["exchange_id", 2]]
[8b52dca2-ef28-4509-9f7a-dadc793b0090]   CACHE (0.0ms)  SELECT COUNT(*) FROM `posts` WHERE `posts`.`exchange_id` = 2  [["exchange_id", 2]]
[8b52dca2-ef28-4509-9f7a-dadc793b0090]   Rendered components/_pagination.html.erb (1.4ms)
[8b52dca2-ef28-4509-9f7a-dadc793b0090]   Rendered posts/_posts.html.erb (28.7ms)
[8b52dca2-ef28-4509-9f7a-dadc793b0090]   CACHE (0.0ms)  SELECT  `discussion_relationships`.* FROM `discussion_relationships` WHERE `discussion_relationships`.`user_id` = 1 AND `discussion_relationships`.`discussion_id` = 2  ORDER BY `discussion_relationships`.`id` ASC LIMIT 1  [["user_id", 1], ["discussion_id", 2]]
[8b52dca2-ef28-4509-9f7a-dadc793b0090]   CACHE (0.0ms)  SELECT COUNT(*) FROM `posts` WHERE `posts`.`exchange_id` = 2  [["exchange_id", 2]]
[8b52dca2-ef28-4509-9f7a-dadc793b0090]   CACHE (0.0ms)  SELECT COUNT(*) FROM `posts` WHERE `posts`.`exchange_id` = 2  [["exchange_id", 2]]
[8b52dca2-ef28-4509-9f7a-dadc793b0090]   Rendered exchanges/_post_form.html.erb (6.2ms)
[8b52dca2-ef28-4509-9f7a-dadc793b0090]   Rendered discussions/show.html.erb within layouts/application (67.4ms)
[8b52dca2-ef28-4509-9f7a-dadc793b0090]    (0.2ms)  SELECT COUNT(*) FROM `conversation_relationships` WHERE `conversation_relationships`.`user_id` = 1 AND `conversation_relationships`.`new_posts` = 1
[8b52dca2-ef28-4509-9f7a-dadc793b0090]    (0.2ms)  SELECT COUNT(*) FROM `invites` WHERE `invites`.`user_id` = 1
[8b52dca2-ef28-4509-9f7a-dadc793b0090] Completed 200 OK in 130ms (Views: 80.4ms | ActiveRecord: 8.4ms | Solr: 0.0ms)
[65ca2a39-d2d8-4faf-90e9-e2712df5aa3c]
[65ca2a39-d2d8-4faf-90e9-e2712df5aa3c]
[65ca2a39-d2d8-4faf-90e9-e2712df5aa3c] Started GET "/discussions/2/posts/count.json?1444153319443" for 127.0.0.1 at 2015-10-06 10:41:59 -0700
[65ca2a39-d2d8-4faf-90e9-e2712df5aa3c] Processing by PostsController#count as JSON
[65ca2a39-d2d8-4faf-90e9-e2712df5aa3c]   Parameters: {"1444153319443"=>nil, "discussion_id"=>"2"}
[65ca2a39-d2d8-4faf-90e9-e2712df5aa3c]   User Load (0.3ms)  SELECT  `users`.* FROM `users` WHERE `users`.`id` = 1 LIMIT 1
[65ca2a39-d2d8-4faf-90e9-e2712df5aa3c] Authenticated as user:1 (congyan)
[65ca2a39-d2d8-4faf-90e9-e2712df5aa3c]   Discussion Load (1.0ms)  SELECT  `exchanges`.* FROM `exchanges` WHERE `exchanges`.`type` IN ('Discussion') AND `exchanges`.`id` = 2 LIMIT 1
[65ca2a39-d2d8-4faf-90e9-e2712df5aa3c] Completed 200 OK in 16ms (Views: 0.7ms | ActiveRecord: 1.4ms | Solr: 0.0ms)


>>>>>>>>>>>>>
click "check response", sth like that

085dc2c2-8ba4-47f3-b1f7-d1877e413550] Started GET "/discussions/2/posts/since/1" for 127.0.0.1 at 2015-10-06 10:43:09 -0700
[085dc2c2-8ba4-47f3-b1f7-d1877e413550] Processing by PostsController#since as */*
*/
[085dc2c2-8ba4-47f3-b1f7-d1877e413550]   Parameters: {"discussion_id"=>"2", "index"=>"1"}
[085dc2c2-8ba4-47f3-b1f7-d1877e413550]   User Load (0.4ms)  SELECT  `users`.* FROM `users` WHERE `users`.`id` = 1 LIMIT 1
[085dc2c2-8ba4-47f3-b1f7-d1877e413550] Authenticated as user:1 (congyan)
[085dc2c2-8ba4-47f3-b1f7-d1877e413550]   Discussion Load (0.3ms)  SELECT  `exchanges`.* FROM `exchanges` WHERE `exchanges`.`type` IN ('Discussion') AND `exchanges`.`id` = 2 LIMIT 1
[085dc2c2-8ba4-47f3-b1f7-d1877e413550]   Post Load (1.0ms)  SELECT  `posts`.* FROM `posts` WHERE `posts`.`exchange_id` = 2  ORDER BY created_at ASC LIMIT 200 OFFSET 1
[085dc2c2-8ba4-47f3-b1f7-d1877e413550]   User Load (0.6ms)  SELECT `users`.* FROM `users` WHERE `users`.`id` IN (1)
[085dc2c2-8ba4-47f3-b1f7-d1877e413550]   Exchange Load (0.9ms)  SELECT  `exchanges`.* FROM `exchanges` WHERE `exchanges`.`id` = 2 LIMIT 1
[085dc2c2-8ba4-47f3-b1f7-d1877e413550]    (0.7ms)  SELECT COUNT(*) FROM `posts` WHERE `posts`.`exchange_id` = 2 AND (id < 4)
[085dc2c2-8ba4-47f3-b1f7-d1877e413550]   Rendered posts/_post.html.erb (27.8ms)
[085dc2c2-8ba4-47f3-b1f7-d1877e413550]   Rendered posts/_posts.html.erb (44.1ms)
[085dc2c2-8ba4-47f3-b1f7-d1877e413550]   Rendered posts/since.html.erb (51.7ms)
[085dc2c2-8ba4-47f3-b1f7-d1877e413550]   ExchangeView Load (0.5ms)  SELECT  `exchange_views`.* FROM `exchange_views` WHERE `exchange_views`.`user_id` = 1 AND `exchange_views`.`exchange_id` = 2  ORDER BY `exchange_views`.`id` ASC LIMIT 1
[085dc2c2-8ba4-47f3-b1f7-d1877e413550]    (0.2ms)  BEGIN
[085dc2c2-8ba4-47f3-b1f7-d1877e413550]   SQL (0.5ms)  UPDATE `exchange_views` SET `post_index` = 2, `post_id` = 4 WHERE `exchange_views`.`id` = 1
[085dc2c2-8ba4-47f3-b1f7-d1877e413550]    (0.2ms)  COMMIT
[085dc2c2-8ba4-47f3-b1f7-d1877e413550] Completed 200 OK in 86ms (Views: 60.2ms | ActiveRecord: 5.3ms | Solr: 0.0ms)
[accb0407-5e60-4df0-8579-c80b9a71402f]
[accb0407-5e60-4df0-8579-c80b9a71402f]
[accb0407-5e60-4df0-8579-c80b9a71402f] Started GET "/discussions/2/posts/count.json?1444153390722" for 127.0.0.1 at 2015-10-06 10:43:10 -0700
[accb0407-5e60-4df0-8579-c80b9a71402f] Processing by PostsController#count as JSON
[accb0407-5e60-4df0-8579-c80b9a71402f]   Parameters: {"1444153390722"=>nil, "discussion_id"=>"2"}
[accb0407-5e60-4df0-8579-c80b9a71402f]   User Load (0.4ms)  SELECT  `users`.* FROM `users` WHERE `users`.`id` = 1 LIMIT 1
[accb0407-5e60-4df0-8579-c80b9a71402f] Authenticated as user:1 (congyan)
[accb0407-5e60-4df0-8579-c80b9a71402f]   Discussion Load (0.4ms)  SELECT  `exchanges`.* FROM `exchanges` WHERE `exchanges`.`type` IN ('Discussion') AND `exchanges`.`id` = 2 LIMIT 1
[accb0407-5e60-4df0-8579-c80b9a71402f] Completed 200 OK in 13ms (Views: 0.5ms | ActiveRecord: 0.7ms | Solr: 0.0ms)
[af70337b-94ee-42f3-9452-d02319127ad2]
[af70337b-94ee-42f3-9452-d02319127ad2]
[af70337b-94ee-42f3-9452-d02319127ad2] Started GET "/discussions/2/posts/count.json?1444153395722" for 127.0.0.1 at 2015-10-06 10:43:15 -0700
[af70337b-94ee-42f3-9452-d02319127ad2] Processing by PostsController#count as JSON
[af70337b-94ee-42f3-9452-d02319127ad2]   Parameters: {"1444153395722"=>nil, "discussion_id"=>"2"}
[af70337b-94ee-42f3-9452-d02319127ad2]   User Load (0.4ms)  SELECT  `users`.* FROM `users` WHERE `users`.`id` = 1 LIMIT 1
[af70337b-94ee-42f3-9452-d02319127ad2] Authenticated as user:1 (congyan)
[af70337b-94ee-42f3-9452-d02319127ad2]   Discussion Load (0.3ms)  SELECT  `exchanges`.* FROM `exchanges` WHERE `exchanges`.`type` IN ('Discussion') AND `exchanges`.`id` = 2 LIMIT 1
[af70337b-94ee-42f3-9452-d02319127ad2] Completed 200 OK in 12ms (Views: 0.4ms | ActiveRecord: 0.7ms | Solr: 0.0ms)
[f6d80a30-6966-4f69-8dc9-2b8507fb26b5]
[f6d80a30-6966-4f69-8dc9-2b8507fb26b5]
[f6d80a30-6966-4f69-8dc9-2b8507fb26b5] Started GET "/discussions/2/posts/count.json?1444153400721" for 127.0.0.1 at 2015-10-06 10:43:20 -0700
[f6d80a30-6966-4f69-8dc9-2b8507fb26b5] Processing by PostsController#count as JSON
[f6d80a30-6966-4f69-8dc9-2b8507fb26b5]   Parameters: {"1444153400721"=>nil, "discussion_id"=>"2"}
[f6d80a30-6966-4f69-8dc9-2b8507fb26b5]   User Load (0.4ms)  SELECT  `users`.* FROM `users` WHERE `users`.`id` = 1 LIMIT 1
[f6d80a30-6966-4f69-8dc9-2b8507fb26b5] Authenticated as user:1 (congyan)
[f6d80a30-6966-4f69-8dc9-2b8507fb26b5]   Discussion Load (0.3ms)  SELECT  `exchanges`.* FROM `exchanges` WHERE `exchanges`.`type` IN ('Discussion') AND `exchanges`.`id` = 2 LIMIT 1
[f6d80a30-6966-4f69-8dc9-2b8507fb26b5] Completed 200 OK in 12ms (Views: 0.4ms | ActiveRecord: 0.7ms | Solr: 0.0ms)
[a02ab893-12df-42f2-83db-3c2e04bac7ec]
[a02ab893-12df-42f2-83db-3c2e04bac7ec]
[a02ab893-12df-42f2-83db-3c2e04bac7ec] Started GET "/discussions/2/posts/count.json?1444153405722" for 127.0.0.1 at 2015-10-06 10:43:25 -0700
[a02ab893-12df-42f2-83db-3c2e04bac7ec] Processing by PostsController#count as JSON
[a02ab893-12df-42f2-83db-3c2e04bac7ec]   Parameters: {"1444153405722"=>nil, "discussion_id"=>"2"}
[a02ab893-12df-42f2-83db-3c2e04bac7ec]   User Load (0.4ms)  SELECT  `users`.* FROM `users` WHERE `users`.`id` = 1 LIMIT 1
[a02ab893-12df-42f2-83db-3c2e04bac7ec] Authenticated as user:1 (congyan)
[a02ab893-12df-42f2-83db-3c2e04bac7ec]   Discussion Load (0.3ms)  SELECT  `exchanges`.* FROM `exchanges` WHERE `exchanges`.`type` IN ('Discussion') AND `exchanges`.`id` = 2 LIMIT 1
[a02ab893-12df-42f2-83db-3c2e04bac7ec] Completed 200 OK in 12ms (Views: 0.5ms | ActiveRecord: 0.7ms | Solr: 0.0ms)


>>>>>>>>>>>>>>>>>>>>
for some specific discussion click "follow"
77b89eb9-ab3d-47ef-b80e-e74f9354b467] Started GET "/discussions/2-This-is-the-title-of-the-first-discussion/1" for 127.0.0.1 at 2015-10-06 10:44:46 -0700
[77b89eb9-ab3d-47ef-b80e-e74f9354b467] Processing by DiscussionsController#show as HTML
[77b89eb9-ab3d-47ef-b80e-e74f9354b467]   Parameters: {"id"=>"2-This-is-the-title-of-the-first-discussion", "page"=>"1"}
[77b89eb9-ab3d-47ef-b80e-e74f9354b467]   User Load (0.3ms)  SELECT  `users`.* FROM `users` WHERE `users`.`id` = 1 LIMIT 1
[77b89eb9-ab3d-47ef-b80e-e74f9354b467] Authenticated as user:1 (congyan)
[77b89eb9-ab3d-47ef-b80e-e74f9354b467]   Exchange Load (0.2ms)  SELECT  `exchanges`.* FROM `exchanges` WHERE `exchanges`.`id` = 2 LIMIT 1
[77b89eb9-ab3d-47ef-b80e-e74f9354b467]   Post Load (0.6ms)  SELECT  `posts`.* FROM `posts` WHERE `posts`.`exchange_id` = 2  ORDER BY created_at ASC LIMIT 50 OFFSET 0
[77b89eb9-ab3d-47ef-b80e-e74f9354b467]   User Load (0.6ms)  SELECT `users`.* FROM `users` WHERE `users`.`id` IN (1)
[77b89eb9-ab3d-47ef-b80e-e74f9354b467]    (0.7ms)  SELECT COUNT(count_column) FROM (SELECT  1 AS count_column FROM `posts` WHERE `posts`.`exchange_id` = 2 LIMIT 50 OFFSET 0) subquery_for_count
[77b89eb9-ab3d-47ef-b80e-e74f9354b467]   ExchangeView Load (0.5ms)  SELECT  `exchange_views`.* FROM `exchange_views` WHERE `exchange_views`.`user_id` = 1 AND `exchange_views`.`exchange_id` = 2  ORDER BY `exchange_views`.`id` ASC LIMIT 1
[77b89eb9-ab3d-47ef-b80e-e74f9354b467]    (0.4ms)  SELECT COUNT(*) FROM `posts` WHERE `posts`.`exchange_id` = 2
[77b89eb9-ab3d-47ef-b80e-e74f9354b467]   CACHE (0.0ms)  SELECT COUNT(*) FROM `posts` WHERE `posts`.`exchange_id` = 2  [["exchange_id", 2]]
[77b89eb9-ab3d-47ef-b80e-e74f9354b467]   DiscussionRelationship Load (0.5ms)  SELECT  `discussion_relationships`.* FROM `discussion_relationships` WHERE `discussion_relationships`.`user_id` = 1 AND `discussion_relationships`.`discussion_id` = 2  ORDER BY `discussion_relationships`.`id` ASC LIMIT 1
[77b89eb9-ab3d-47ef-b80e-e74f9354b467]   CACHE (0.0ms)  SELECT  `discussion_relationships`.* FROM `discussion_relationships` WHERE `discussion_relationships`.`user_id` = 1 AND `discussion_relationships`.`discussion_id` = 2  ORDER BY `discussion_relationships`.`id` ASC LIMIT 1  [["user_id", 1], ["discussion_id", 2]]
[77b89eb9-ab3d-47ef-b80e-e74f9354b467]   CACHE (0.0ms)  SELECT COUNT(*) FROM `posts` WHERE `posts`.`exchange_id` = 2  [["exchange_id", 2]]
[77b89eb9-ab3d-47ef-b80e-e74f9354b467]   CACHE (0.0ms)  SELECT  `discussion_relationships`.* FROM `discussion_relationships` WHERE `discussion_relationships`.`user_id` = 1 AND `discussion_relationships`.`discussion_id` = 2  ORDER BY `discussion_relationships`.`id` ASC LIMIT 1  [["user_id", 1], ["discussion_id", 2]]
[77b89eb9-ab3d-47ef-b80e-e74f9354b467]   CACHE (0.0ms)  SELECT  `discussion_relationships`.* FROM `discussion_relationships` WHERE `discussion_relationships`.`user_id` = 1 AND `discussion_relationships`.`discussion_id` = 2  ORDER BY `discussion_relationships`.`id` ASC LIMIT 1  [["user_id", 1], ["discussion_id", 2]]
[77b89eb9-ab3d-47ef-b80e-e74f9354b467]   CACHE (0.0ms)  SELECT COUNT(*) FROM `posts` WHERE `posts`.`exchange_id` = 2  [["exchange_id", 2]]
[77b89eb9-ab3d-47ef-b80e-e74f9354b467]   CACHE (0.0ms)  SELECT  `discussion_relationships`.* FROM `discussion_relationships` WHERE `discussion_relationships`.`user_id` = 1 AND `discussion_relationships`.`discussion_id` = 2  ORDER BY `discussion_relationships`.`id` ASC LIMIT 1  [["user_id", 1], ["discussion_id", 2]]
[77b89eb9-ab3d-47ef-b80e-e74f9354b467]   CACHE (0.0ms)  SELECT  `discussion_relationships`.* FROM `discussion_relationships` WHERE `discussion_relationships`.`user_id` = 1 AND `discussion_relationships`.`discussion_id` = 2  ORDER BY `discussion_relationships`.`id` ASC LIMIT 1  [["user_id", 1], ["discussion_id", 2]]
[77b89eb9-ab3d-47ef-b80e-e74f9354b467]   CACHE (0.0ms)  SELECT COUNT(*) FROM `posts` WHERE `posts`.`exchange_id` = 2  [["exchange_id", 2]]
[77b89eb9-ab3d-47ef-b80e-e74f9354b467]   CACHE (0.0ms)  SELECT COUNT(*) FROM `posts` WHERE `posts`.`exchange_id` = 2  [["exchange_id", 2]]
[77b89eb9-ab3d-47ef-b80e-e74f9354b467]   CACHE (0.0ms)  SELECT COUNT(*) FROM `posts` WHERE `posts`.`exchange_id` = 2  [["exchange_id", 2]]
[77b89eb9-ab3d-47ef-b80e-e74f9354b467]   Rendered components/_pagination.html.erb (2.0ms)
[77b89eb9-ab3d-47ef-b80e-e74f9354b467]   Exchange Load (0.3ms)  SELECT  `exchanges`.* FROM `exchanges` WHERE `exchanges`.`id` = 2 LIMIT 1
[77b89eb9-ab3d-47ef-b80e-e74f9354b467]   CACHE (0.0ms)  SELECT COUNT(*) FROM `posts` WHERE `posts`.`exchange_id` = 2  [["exchange_id", 2]]
[77b89eb9-ab3d-47ef-b80e-e74f9354b467]   Rendered posts/_post.html.erb (17.8ms)
[77b89eb9-ab3d-47ef-b80e-e74f9354b467]   CACHE (0.0ms)  SELECT  `exchanges`.* FROM `exchanges` WHERE `exchanges`.`id` = 2 LIMIT 1  [["id", 2]]
[77b89eb9-ab3d-47ef-b80e-e74f9354b467]   CACHE (0.1ms)  SELECT COUNT(*) FROM `posts` WHERE `posts`.`exchange_id` = 2  [["exchange_id", 2]]
[77b89eb9-ab3d-47ef-b80e-e74f9354b467]   Rendered posts/_post.html.erb (9.6ms)
[77b89eb9-ab3d-47ef-b80e-e74f9354b467]   CACHE (0.0ms)  SELECT COUNT(*) FROM `posts` WHERE `posts`.`exchange_id` = 2  [["exchange_id", 2]]
[77b89eb9-ab3d-47ef-b80e-e74f9354b467]   CACHE (0.0ms)  SELECT COUNT(*) FROM `posts` WHERE `posts`.`exchange_id` = 2  [["exchange_id", 2]]
[77b89eb9-ab3d-47ef-b80e-e74f9354b467]   Rendered components/_pagination.html.erb (1.7ms)
[77b89eb9-ab3d-47ef-b80e-e74f9354b467]   Rendered posts/_posts.html.erb (34.8ms)
[77b89eb9-ab3d-47ef-b80e-e74f9354b467]   CACHE (0.0ms)  SELECT  `discussion_relationships`.* FROM `discussion_relationships` WHERE `discussion_relationships`.`user_id` = 1 AND `discussion_relationships`.`discussion_id` = 2  ORDER BY `discussion_relationships`.`id` ASC LIMIT 1  [["user_id", 1], ["discussion_id", 2]]
[77b89eb9-ab3d-47ef-b80e-e74f9354b467]   CACHE (0.0ms)  SELECT  `discussion_relationships`.* FROM `discussion_relationships` WHERE `discussion_relationships`.`user_id` = 1 AND `discussion_relationships`.`discussion_id` = 2  ORDER BY `discussion_relationships`.`id` ASC LIMIT 1  [["user_id", 1], ["discussion_id", 2]]
[77b89eb9-ab3d-47ef-b80e-e74f9354b467]   CACHE (0.0ms)  SELECT COUNT(*) FROM `posts` WHERE `posts`.`exchange_id` = 2  [["exchange_id", 2]]
[77b89eb9-ab3d-47ef-b80e-e74f9354b467]   CACHE (0.0ms)  SELECT COUNT(*) FROM `posts` WHERE `posts`.`exchange_id` = 2  [["exchange_id", 2]]
[77b89eb9-ab3d-47ef-b80e-e74f9354b467]   Rendered exchanges/_post_form.html.erb (5.1ms)
[77b89eb9-ab3d-47ef-b80e-e74f9354b467]   Rendered discussions/show.html.erb within layouts/application (61.4ms)
[77b89eb9-ab3d-47ef-b80e-e74f9354b467]    (0.2ms)  SELECT COUNT(*) FROM `conversation_relationships` WHERE `conversation_relationships`.`user_id` = 1 AND `conversation_relationships`.`new_posts` = 1
[77b89eb9-ab3d-47ef-b80e-e74f9354b467]    (0.2ms)  SELECT COUNT(*) FROM `invites` WHERE `invites`.`user_id` = 1
[77b89eb9-ab3d-47ef-b80e-e74f9354b467] Completed 200 OK in 99ms (Views: 78.9ms | ActiveRecord: 5.0ms | Solr: 0.0ms)
[09631cd7-20c1-464c-a834-eed8caa43a03]
[09631cd7-20c1-464c-a834-eed8caa43a03]
[09631cd7-20c1-464c-a834-eed8caa43a03] Started GET "/discussions/2/posts/count.json?1444153493433" for 127.0.0.1 at 2015-10-06 10:44:53 -0700
[09631cd7-20c1-464c-a834-eed8caa43a03] Processing by PostsController#count as JSON
[09631cd7-20c1-464c-a834-eed8caa43a03]   Parameters: {"1444153493433"=>nil, "discussion_id"=>"2"}
[09631cd7-20c1-464c-a834-eed8caa43a03]   User Load (0.3ms)  SELECT  `users`.* FROM `users` WHERE `users`.`id` = 1 LIMIT 1
[09631cd7-20c1-464c-a834-eed8caa43a03] Authenticated as user:1 (congyan)
[09631cd7-20c1-464c-a834-eed8caa43a03]   Discussion Load (0.4ms)  SELECT  `exchanges`.* FROM `exchanges` WHERE `exchanges`.`type` IN ('Discussion') AND `exchanges`.`id` = 2 LIMIT 1
[09631cd7-20c1-464c-a834-eed8caa43a03] Completed 200 OK in 15ms (Views: 0.5ms | ActiveRecord: 0.7ms | Solr: 0.0ms)
[b953ec6a-81b3-4b7c-8b77-7b3e122b0310]
[b953ec6a-81b3-4b7c-8b77-7b3e122b0310]
[b953ec6a-81b3-4b7c-8b77-7b3e122b0310] Started GET "/discussions/2/posts/count.json?1444153498432" for 127.0.0.1 at 2015-10-06 10:44:58 -0700
[b953ec6a-81b3-4b7c-8b77-7b3e122b0310] Processing by PostsController#count as JSON
[b953ec6a-81b3-4b7c-8b77-7b3e122b0310]   Parameters: {"1444153498432"=>nil, "discussion_id"=>"2"}
[b953ec6a-81b3-4b7c-8b77-7b3e122b0310]   User Load (0.5ms)  SELECT  `users`.* FROM `users` WHERE `users`.`id` = 1 LIMIT 1
[b953ec6a-81b3-4b7c-8b77-7b3e122b0310] Authenticated as user:1 (congyan)
[b953ec6a-81b3-4b7c-8b77-7b3e122b0310]   Discussion Load (0.3ms)  SELECT  `exchanges`.* FROM `exchanges` WHERE `exchanges`.`type` IN ('Discussion') AND `exchanges`.`id` = 2 LIMIT 1
[b953ec6a-81b3-4b7c-8b77-7b3e122b0310] Completed 200 OK in 13ms (Views: 0.5ms | ActiveRecord: 0.8ms | Solr: 0.0ms)

