>>>>>>>>>>>>>>>>
sign up

Started GET "/api/v1/users?includes=basic%2Cusername_tag%2Cavatar_url&avatar_size=20&usernames=" for 127.0.0.1 at 2015-10-07 08:12:10 -0700
Processing by Api::V1::UsersController#index as JSON
  Parameters: {"includes"=>"basic,username_tag,avatar_url", "avatar_size"=>"20", "usernames"=>""}
  User Load (3.0ms)  SELECT  "users".* FROM "users"  LIMIT 25 OFFSET 0
  Rendered api/v1/users/index.json.jbuilder (4.9ms)
Completed 200 OK in 25ms (Views: 18.1ms | ActiveRecord: 3.0ms)


Started POST "/users" for 127.0.0.1 at 2015-10-07 08:12:54 -0700
Processing by Devise::RegistrationsController#create as HTML
  Parameters: {"utf8"=>"✓", "authenticity_token"=>"89hS/A/ggWlGwH4eJ9qFnc/rgSrY0VAoVdf9OKJFp6U=", "user"=>{"username"=>"wallgigtest", "email"=>"wallgig@example.com", "password"=>"[FILTERED]", "password_confirmation"=>"[FILTERED]"}, "commit"=>"Sign up"}
   (1.3ms)  BEGIN
  User Exists (2.1ms)  SELECT  1 AS one FROM "users"  WHERE "users"."email" = 'wallgig@example.com' LIMIT 1
  User Exists (1.9ms)  SELECT  1 AS one FROM "users"  WHERE LOWER("users"."username") = LOWER('wallgigtest') LIMIT 1
  User Exists (1.7ms)  SELECT  1 AS one FROM "users"  WHERE "users"."authentication_token" = 'Vsav9nt9xeLxPnuRtMgA' LIMIT 1
  User Load (2.3ms)  SELECT  "users".* FROM "users"  WHERE "users"."confirmation_token" = '842d974eac9a44bd194ea51ee2b1b3e4afcf2c8f0b141ad2cceda97c1f43d45d'  ORDER BY "users"."id" ASC LIMIT 1
  SQL (1.3ms)  INSERT INTO "users" ("authentication_token", "confirmation_sent_at", "confirmation_token", "created_at", "email", "encrypted_password", "updated_at", "username") VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING "id"  [["authentication_token", "Vsav9nt9xeLxPnuRtMgA"], ["confirmation_sent_at", "2015-10-07 15:12:54.922656"], ["confirmation_token", "842d974eac9a44bd194ea51ee2b1b3e4afcf2c8f0b141ad2cceda97c1f43d45d"], ["created_at", "2015-10-07 15:12:54.722829"], ["email", "wallgig@example.com"], ["encrypted_password", "$2a$10$0F4YnFhnzi9ZZ94tDXs3X.5/gT94c0OJzmEe4y8BgVKkmmrlTV4Je"], ["updated_at", "2015-10-07 15:12:54.722829"], ["username", "wallgigtest"]]
  SQL (1.2ms)  INSERT INTO "user_profiles" ("created_at", "updated_at", "user_id") VALUES ($1, $2, $3) RETURNING "id"  [["created_at", "2015-10-07 15:12:54.979001"], ["updated_at", "2015-10-07 15:12:54.979001"], ["user_id", 1]]
  SQL (1.3ms)  INSERT INTO "user_settings" ("aspect_ratios", "created_at", "updated_at", "user_id") VALUES ($1, $2, $3, $4) RETURNING "id"  [["aspect_ratios", "--- []\n"], ["created_at", "2015-10-07 15:12:54.981768"], ["updated_at", "2015-10-07 15:12:54.981768"], ["user_id", 1]]
  Rendered devise/mailer/confirmation_instructions.html.erb (1.4ms)

Devise::Mailer#confirmation_instructions: processed outbound mail in 22.1ms
xprop:  unable to open display ''
xprop:  unable to open display ''

Sent mail to wallgig@example.com (293.2ms)
Date: Wed, 07 Oct 2015 08:12:55 -0700
From: test@example.com
Reply-To: test@example.com
To: wallgig@example.com
Message-ID: <561536775360_f1a53fe0c1fcb3182252c@dragon.mail>
Subject: Confirmation instructions
Mime-Version: 1.0
Content-Type: text/html;
 charset=UTF-8
Content-Transfer-Encoding: 7bit

<p>Welcome wallgig@example.com!</p>

<p>You can confirm your account email through the link below:</p>

<p><a href="http://localhost:3000/users/confirmation?confirmation_token=CYA9cTApF6uB2ZS-2Loa">Confirm my account</a></p>

   (10.1ms)  COMMIT
Redirected to http://localhost:3000/
Completed 302 Found in 764ms (ActiveRecord: 31.7ms)


Started GET "/" for 127.0.0.1 at 2015-10-07 08:12:55 -0700
Processing by WallpapersController#index as HTML
  Wallpaper Search (81.1ms)  curl http://localhost:9200/wallpapers_development/_search?pretty -d '{"query":{"match_all":{}},"size":20,"from":0,"sort":{"created_at":"desc"},"filter":{"and":[{"or":[{"term":{"purity":"sfw"}}]}]},"facets":{"tag":{"terms":{"field":"tag","size":170},"facet_filter":{"and":{"filters":[{"or":[{"term":{"purity":"sfw"}}]}]}}},"category":{"terms":{"field":"category","size":160},"facet_filter":{"and":{"filters":[{"or":[{"term":{"purity":"sfw"}}]}]}}}},"fields":[]}'
  Rendered api/v1/shared/_paging.jbuilder (0.0ms)
  Rendered api/v1/wallpapers/index.json.jbuilder (1.4ms)
  Rendered components/_wallpaper_search.html.haml (1.9ms)
  Rendered components/_wallpaper_index.html.haml (4.2ms)
  Rendered components/_collections_overlay.html.haml (1.4ms)
  Rendered wallpapers/index.html.haml within layouts/application (7.4ms)
  DonationGoal Load (2.2ms)  SELECT  "donation_goals".* FROM "donation_goals"  WHERE ("donation_goals"."starts_on" >= '2015-10-07' AND "donation_goals"."ends_on" < '2015-10-07')  ORDER BY "donation_goals"."starts_on" ASC LIMIT 1
  DonationGoal Load (1.5ms)  SELECT  "donation_goals".* FROM "donation_goals"   ORDER BY "donation_goals"."starts_on" DESC LIMIT 1
  Rendered shared/_segment_io.html.erb (0.2ms)
Completed 200 OK in 1655ms (Views: 1554.1ms | Searchkick: 81.1ms | ActiveRecord: 3.7ms)


>>>>>>>>>>>>>>>>>>>

click sign-in

Started GET "/api/v1/users?includes=basic%2Cusername_tag%2Cavatar_url&avatar_size=20&usernames=" for 127.0.0.1 at 2015-10-07 08:13:45 -0700
Processing by Api::V1::UsersController#index as JSON
  Parameters: {"includes"=>"basic,username_tag,avatar_url", "avatar_size"=>"20", "usernames"=>""}
  User Load (2.9ms)  SELECT  "users".* FROM "users"  LIMIT 25 OFFSET 0
  UserProfile Load (2.7ms)  SELECT "user_profiles".* FROM "user_profiles"  WHERE "user_profiles"."user_id" IN (1)
  Rendered api/v1/users/index.json.jbuilder (10.3ms)
Completed 200 OK in 29ms (Views: 20.6ms | ActiveRecord: 5.6ms)

>>>>>>>>>>>>>>>>
copy confirmation link address

Started GET "/users/confirmation?confirmation_token=CYA9cTApF6uB2ZS-2Loa" for 127.0.0.1 at 2015-10-07 08:18:28 -0700
Processing by Devise::ConfirmationsController#show as HTML
  Parameters: {"confirmation_token"=>"CYA9cTApF6uB2ZS-2Loa"}
  User Load (1.6ms)  SELECT  "users".* FROM "users"  WHERE "users"."confirmation_token" = '842d974eac9a44bd194ea51ee2b1b3e4afcf2c8f0b141ad2cceda97c1f43d45d'  ORDER BY "users"."id" ASC LIMIT 1
   (0.9ms)  BEGIN
  SQL (1.1ms)  UPDATE "users" SET "confirmation_token" = $1, "confirmed_at" = $2, "updated_at" = $3 WHERE "users"."id" = 1  [["confirmation_token", nil], ["confirmed_at", "2015-10-07 15:18:28.526815"], ["updated_at", "2015-10-07 15:18:28.528343"]]
   (1.2ms)  COMMIT
Redirected to http://localhost:3000/users/sign_in
Completed 302 Found in 12ms (ActiveRecord: 4.9ms)


Started GET "/users/sign_in" for 127.0.0.1 at 2015-10-07 08:18:28 -0700
Processing by Devise::SessionsController#new as HTML
  Rendered devise/shared/_links.erb (1.0ms)
  Rendered devise/sessions/new.html.haml within layouts/application (24.3ms)
  DonationGoal Load (2.0ms)  SELECT  "donation_goals".* FROM "donation_goals"  WHERE ("donation_goals"."starts_on" >= '2015-10-07' AND "donation_goals"."ends_on" < '2015-10-07')  ORDER BY "donation_goals"."starts_on" ASC LIMIT 1
  DonationGoal Load (1.2ms)  SELECT  "donation_goals".* FROM "donation_goals"   ORDER BY "donation_goals"."starts_on" DESC LIMIT 1
  Rendered shared/_segment_io.html.erb (0.2ms)
Completed 200 OK in 1282ms (Views: 1277.4ms | ActiveRecord: 3.2ms)


>>>>>>>>>>>>>
sign in

Started GET "/api/v1/users?includes=basic%2Cusername_tag%2Cavatar_url&avatar_size=20&usernames=" for 127.0.0.1 at 2015-10-07 08:20:24 -0700
Processing by Api::V1::UsersController#index as JSON
  Parameters: {"includes"=>"basic,username_tag,avatar_url", "avatar_size"=>"20", "usernames"=>""}
  User Load (2.6ms)  SELECT  "users".* FROM "users"  WHERE "users"."id" = 1  ORDER BY "users"."id" ASC LIMIT 1
  User Load (2.5ms)  SELECT  "users".* FROM "users"  LIMIT 25 OFFSET 0
  UserProfile Load (2.5ms)  SELECT "user_profiles".* FROM "user_profiles"  WHERE "user_profiles"."user_id" IN (2, 3, 1)
  Rendered api/v1/users/index.json.jbuilder (10.2ms)
Completed 200 OK in 34ms (Views: 20.6ms | ActiveRecord: 7.6ms)


Started GET "/" for 127.0.0.1 at 2015-10-07 08:20:25 -0700
Processing by WallpapersController#index as */*
*/
  User Load (2.5ms)  SELECT  "users".* FROM "users"  WHERE "users"."id" = 1  ORDER BY "users"."id" ASC LIMIT 1
  UserSetting Load (1.8ms)  SELECT  "user_settings".* FROM "user_settings"  WHERE "user_settings"."user_id" = $1 LIMIT 1  [["user_id", 1]]
  UserProfile Load (1.6ms)  SELECT  "user_profiles".* FROM "user_profiles"  WHERE "user_profiles"."user_id" = $1 LIMIT 1  [["user_id", 1]]
   (1.6ms)  BEGIN
   (1.6ms)  ROLLBACK
  Wallpaper Search (76.9ms)  curl http://localhost:9200/wallpapers_development/_search?pretty -d '{"query":{"match_all":{}},"size":20,"from":0,"sort":{"created_at":"desc"},"filter":{"and":[{"or":[{"term":{"purity":"sfw"}}]}]},"facets":{"tag":{"terms":{"field":"tag","size":170},"facet_filter":{"and":{"filters":[{"or":[{"term":{"purity":"sfw"}}]}]}}},"category":{"terms":{"field":"category","size":160},"facet_filter":{"and":{"filters":[{"or":[{"term":{"purity":"sfw"}}]}]}}}},"fields":[]}'
  Rendered api/v1/shared/_paging.jbuilder (0.0ms)
  Rendered api/v1/wallpapers/index.json.jbuilder (3.0ms)
  Rendered components/_wallpaper_search.html.haml (2.8ms)
  Rendered components/_wallpaper_index.html.haml (6.2ms)
  Rendered components/_collections_overlay.html.haml (2.0ms)
  Rendered wallpapers/index.html.haml within layouts/application (10.9ms)
  DonationGoal Load (1.9ms)  SELECT  "donation_goals".* FROM "donation_goals"  WHERE ("donation_goals"."starts_on" >= '2015-10-07' AND "donation_goals"."ends_on" < '2015-10-07')  ORDER BY "donation_goals"."starts_on" ASC LIMIT 1
  DonationGoal Load (1.5ms)  SELECT  "donation_goals".* FROM "donation_goals"   ORDER BY "donation_goals"."starts_on" DESC LIMIT 1
   (1.2ms)  SELECT COUNT(*) FROM "notifications"  WHERE "notifications"."user_id" = $1 AND "notifications"."read" = 'f'  [["user_id", 1]]
  Rendered shared/_segment_io.html.erb (0.2ms)
Completed 200 OK in 1588ms (Views: 1457.8ms | Searchkick: 76.9ms | ActiveRecord: 13.7ms)

>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

click "collections"

tarted GET "/collections" for 127.0.0.1 at 2015-10-07 08:20:57 -0700
Processing by CollectionsController#index as HTML
  User Load (2.7ms)  SELECT  "users".* FROM "users"  WHERE "users"."id" = 1  ORDER BY "users"."id" ASC LIMIT 1
  UserSetting Load (1.9ms)  SELECT  "user_settings".* FROM "user_settings"  WHERE "user_settings"."user_id" = $1 LIMIT 1  [["user_id", 1]]
  UserProfile Load (1.8ms)  SELECT  "user_profiles".* FROM "user_profiles"  WHERE "user_profiles"."user_id" = $1 LIMIT 1  [["user_id", 1]]
   (1.8ms)  BEGIN
   (2.2ms)  ROLLBACK
   (2.7ms)  SELECT COUNT(count_column) FROM (SELECT  1 AS count_column FROM "collections"  WHERE ((sfw_wallpapers_count) >= 4) AND (("collections"."user_id" = 1) OR ("collections"."public" = 't')) LIMIT 20 OFFSET 0) subquery_for_count
  Rendered collections/_list.html.haml (13.9ms)
  Rendered collections/index.html.haml within layouts/application (17.1ms)
  DonationGoal Load (1.5ms)  SELECT  "donation_goals".* FROM "donation_goals"  WHERE ("donation_goals"."starts_on" >= '2015-10-07' AND "donation_goals"."ends_on" < '2015-10-07')  ORDER BY "donation_goals"."starts_on" ASC LIMIT 1
  DonationGoal Load (1.3ms)  SELECT  "donation_goals".* FROM "donation_goals"   ORDER BY "donation_goals"."starts_on" DESC LIMIT 1
   (1.2ms)  SELECT COUNT(*) FROM "notifications"  WHERE "notifications"."user_id" = $1 AND "notifications"."read" = 'f'  [["user_id", 1]]
  Rendered shared/_segment_io.html.erb (0.2ms)
Completed 200 OK in 1508ms (Views: 1387.6ms | ActiveRecord: 24.5ms)


>>>>>>>>>>>>>>>>>>

Started GET "/wallpapers/new" for 127.0.0.1 at 2015-10-07 08:21:42 -0700
Processing by WallpapersController#new as HTML
  User Load (2.6ms)  SELECT  "users".* FROM "users"  WHERE "users"."id" = 1  ORDER BY "users"."id" ASC LIMIT 1
  UserSetting Load (1.7ms)  SELECT  "user_settings".* FROM "user_settings"  WHERE "user_settings"."user_id" = $1 LIMIT 1  [["user_id", 1]]
  UserProfile Load (1.6ms)  SELECT  "user_profiles".* FROM "user_profiles"  WHERE "user_profiles"."user_id" = $1 LIMIT 1  [["user_id", 1]]
   (1.6ms)  BEGIN
   (1.6ms)  ROLLBACK
  Rendered wallpapers/_form.html.haml (71.2ms)
  Rendered wallpapers/new.html.haml within layouts/application (75.5ms)
  DonationGoal Load (2.4ms)  SELECT  "donation_goals".* FROM "donation_goals"  WHERE ("donation_goals"."starts_on" >= '2015-10-07' AND "donation_goals"."ends_on" < '2015-10-07')  ORDER BY "donation_goals"."starts_on" ASC LIMIT 1
  DonationGoal Load (1.2ms)  SELECT  "donation_goals".* FROM "donation_goals"   ORDER BY "donation_goals"."starts_on" DESC LIMIT 1
   (1.1ms)  SELECT COUNT(*) FROM "notifications"  WHERE "notifications"."user_id" = $1 AND "notifications"."read" = 'f'  [["user_id", 1]]
  Rendered shared/_segment_io.html.erb (0.2ms)
Completed 200 OK in 1580ms (Views: 1494.2ms | ActiveRecord: 29.2ms)

>>>>>>>>>>>>>>>>>
This happends at every end of any operation
Started GET "/api/v1/users?includes=basic%2Cusername_tag%2Cavatar_url&avatar_size=20&usernames=" for 127.0.0.1 at 2015-10-07 08:21:49 -0700
Processing by Api::V1::UsersController#index as JSON
  Parameters: {"includes"=>"basic,username_tag,avatar_url", "avatar_size"=>"20", "usernames"=>""}
  User Load (2.8ms)  SELECT  "users".* FROM "users"  WHERE "users"."id" = 1  ORDER BY "users"."id" ASC LIMIT 1
  User Load (2.5ms)  SELECT  "users".* FROM "users"  LIMIT 25 OFFSET 0
  UserProfile Load (2.6ms)  SELECT "user_profiles".* FROM "user_profiles"  WHERE "user_profiles"."user_id" IN (2, 3, 1)
  Rendered api/v1/users/index.json.jbuilder (9.7ms)
Completed 200 OK in 32ms (Views: 19.7ms | ActiveRecord: 7.8ms)

>>>>>>>>>>>>>>>.>
click community/forums

Started GET "/forums" for 127.0.0.1 at 2015-10-07 08:27:50 -0700
Processing by ForumsController#index as HTML
  User Load (2.1ms)  SELECT  "users".* FROM "users"  WHERE "users"."id" = 1  ORDER BY "users"."id" ASC LIMIT 1
  UserSetting Load (1.1ms)  SELECT  "user_settings".* FROM "user_settings"  WHERE "user_settings"."user_id" = $1 LIMIT 1  [["user_id", 1]]
  UserProfile Load (1.1ms)  SELECT  "user_profiles".* FROM "user_profiles"  WHERE "user_profiles"."user_id" = $1 LIMIT 1  [["user_id", 1]]
   (1.1ms)  BEGIN
   (1.1ms)  ROLLBACK
   (3.6ms)  SELECT COUNT(DISTINCT count_column) FROM (SELECT  "topics"."id" AS count_column FROM "topics" LEFT OUTER JOIN "forums" ON "forums"."id" = "topics"."forum_id" LEFT OUTER JOIN "users" ON "users"."id" = "topics"."user_id" LEFT OUTER JOIN "user_profiles" ON "user_profiles"."user_id" = "users"."id" LEFT OUTER JOIN "users" "last_commented_bies_topics" ON "last_commented_bies_topics"."id" = "topics"."last_commented_by_id" LEFT OUTER JOIN "user_profiles" "profiles_users" ON "profiles_users"."user_id" = "last_commented_bies_topics"."id" WHERE "forums"."can_read" = 't' AND "topics"."hidden" = 'f' LIMIT 25 OFFSET 0) subquery_for_count
  Rendered forums/index.html.haml within layouts/forum (35.4ms)
  Rendered shared/forms/_search.html.haml (1.9ms)
  Forum Load (1.4ms)  SELECT "forums".* FROM "forums"  WHERE "forums"."can_read" = 't'  ORDER BY "forums"."position" ASC
  Rendered shared/_chitika.html.erb (0.7ms)
  DonationGoal Load (1.6ms)  SELECT  "donation_goals".* FROM "donation_goals"  WHERE ("donation_goals"."starts_on" >= '2015-10-07' AND "donation_goals"."ends_on" < '2015-10-07')  ORDER BY "donation_goals"."starts_on" ASC LIMIT 1
  DonationGoal Load (1.4ms)  SELECT  "donation_goals".* FROM "donation_goals"   ORDER BY "donation_goals"."starts_on" DESC LIMIT 1
   (1.1ms)  SELECT COUNT(*) FROM "notifications"  WHERE "notifications"."user_id" = $1 AND "notifications"."read" = 'f'  [["user_id", 1]]
  Rendered shared/_segment_io.html.erb (0.2ms)
  Rendered layouts/application.html.haml (1333.6ms)
Completed 200 OK in 1410ms (Views: 1356.0ms | ActiveRecord: 30.1ms)


