>>>>>>>>>>>>
sign up a user

Started POST "/admins" for 127.0.0.1 at 2015-10-07 15:11:50 -0700
Processing by AdminsController#create as HTML
  Parameters: {"utf8"=>"✓", "authenticity_token"=>"n2yQA44skgLKtOI7iD23Hr6U3eNx62Od/3kIaN8mpDdO382mi8wtNTDj5UbvexW2nstSo+Nho1VKKftEQaFHIQ==", "user"=>{"name"=>"congy", "email"=>"admin@example.com", "password"=>"[FILTERED]", "password_confirmation"=>"[FILTERED]"}, "commit"=>"Create admin account"}
  User Load (0.2ms)  SELECT  "users".* FROM "users" WHERE "users"."is_admin" = ? LIMIT 1  [["is_admin", "t"]]
  User Load (0.3ms)  SELECT  "users".* FROM "users" WHERE "users"."id" IS NULL LIMIT 1
   (0.1ms)  begin transaction
  User Exists (0.4ms)  SELECT  1 AS one FROM "users" WHERE "users"."name" = 'congy' LIMIT 1
  User Exists (0.1ms)  SELECT  1 AS one FROM "users" WHERE "users"."email" = 'admin@example.com' LIMIT 1
  SQL (0.6ms)  INSERT INTO "users" ("name", "email", "password_salt", "hashed_password", "is_admin", "created_at", "updated_at", "signup_token", "signup_token_expires_at") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)  [["name", "congy"], ["email", "admin@example.com"], ["password_salt", "i1cDCsRwIpITi3GJc+M4dVG0GIOdvmieZSec1Jvo27w="], ["hashed_password", "0f1ef861e75185be6dcfd6caa33de13bf494541ebeb87c5915f13b98e3790eb5"], ["is_admin", "t"], ["created_at", "2015-10-07 22:11:50.509638"], ["updated_at", "2015-10-07 22:11:50.509638"], ["signup_token", "6d81281db3eee12c2071"], ["signup_token_expires_at", "2015-10-21 22:11:50.510357"]]
  Folder Exists (0.2ms)  SELECT  1 AS one FROM "folders" WHERE ("folders"."name" = 'Root folder' AND "folders"."parent_id" IS NULL) LIMIT 1
  SQL (0.2ms)  INSERT INTO "folders" ("name", "created_at", "updated_at") VALUES (?, ?, ?)  [["name", "Root folder"], ["created_at", "2015-10-07 22:11:50.540363"], ["updated_at", "2015-10-07 22:11:50.540363"]]
  Group Exists (0.1ms)  SELECT  1 AS one FROM "groups" WHERE "groups"."name" = 'Admins' LIMIT 1
  SQL (0.1ms)  INSERT INTO "groups" ("name", "created_at", "updated_at") VALUES (?, ?, ?)  [["name", "Admins"], ["created_at", "2015-10-07 22:11:50.573665"], ["updated_at", "2015-10-07 22:11:50.573665"]]
  Folder Load (0.1ms)  SELECT  "folders".* FROM "folders"  ORDER BY "folders"."id" ASC LIMIT 1000
  SQL (0.2ms)  INSERT INTO "permissions" ("group_id", "folder_id", "can_create", "can_read", "can_update", "can_delete") VALUES (?, ?, ?, ?, ?, ?)  [["group_id", 1], ["folder_id", 1], ["can_create", "t"], ["can_read", "t"], ["can_update", "t"], ["can_delete", "t"]]
  SQL (0.1ms)  INSERT INTO "groups_users" ("user_id", "group_id") VALUES (?, ?)  [["user_id", 1], ["group_id", 1]]
   (1.6ms)  commit transaction
Redirected to http://localhost:3000/sessions/new
Completed 302 Found in 114ms (ActiveRecord: 5.5ms)


Started GET "/sessions/new" for 127.0.0.1 at 2015-10-07 15:11:50 -0700
Processing by SessionsController#new as HTML
  User Load (0.2ms)  SELECT  "users".* FROM "users" WHERE "users"."is_admin" = ? LIMIT 1  [["is_admin", "t"]]
  Rendered sessions/new.html.erb within layouts/application (3.3ms)
  User Load (0.2ms)  SELECT  "users".* FROM "users" WHERE "users"."id" IS NULL LIMIT 1
  Rendered shared/_header.html.erb (3.1ms)
  CACHE (0.0ms)  SELECT  "users".* FROM "users" WHERE "users"."id" IS NULL LIMIT 1
  Rendered shared/_menu.html.erb (0.5ms)
  Rendered shared/_footer.html.erb (0.0ms)
Completed 200 OK in 65ms (Views: 63.6ms | ActiveRecord: 0.3ms)


>>>>>>>>>>>>>>>>>>>>>
sign in

tarted POST "/sessions" for 127.0.0.1 at 2015-10-07 15:12:49 -0700
Processing by SessionsController#create as HTML
  Parameters: {"utf8"=>"✓", "authenticity_token"=>"U9j3ovdwY97igr2cNjLP8mNSGsTkn7mpwtV8VGRgpm6Ca6oH8pDc6RjVuuFRdG1aQw2VhHYVeWF3hY94+udFeA==", "username"=>"congy", "password"=>"[FILTERED]", "commit"=>"Sign in"}
  User Load (0.3ms)  SELECT  "users".* FROM "users" WHERE "users"."is_admin" = ? LIMIT 1  [["is_admin", "t"]]
  User Load (0.5ms)  SELECT  "users".* FROM "users" WHERE "users"."name" = ? LIMIT 1  [["name", "congy"]]
Redirected to http://localhost:3000/folders
Completed 302 Found in 6ms (ActiveRecord: 0.8ms)


Started GET "/folders" for 127.0.0.1 at 2015-10-07 15:12:49 -0700
Processing by FoldersController#index as HTML
  User Load (0.3ms)  SELECT  "users".* FROM "users" WHERE "users"."is_admin" = ? LIMIT 1  [["is_admin", "t"]]
  User Load (0.6ms)  SELECT  "users".* FROM "users" WHERE "users"."id" = ? LIMIT 1  [["id", 1]]
  Folder Load (0.3ms)  SELECT  "folders".* FROM "folders" WHERE "folders"."name" = ? AND "folders"."parent_id" IS NULL LIMIT 1  [["name", "Root folder"]]
Redirected to http://localhost:3000/folders/1
Completed 302 Found in 8ms (ActiveRecord: 1.2ms)


Started GET "/folders/1" for 127.0.0.1 at 2015-10-07 15:12:49 -0700
Processing by FoldersController#show as HTML
  Parameters: {"id"=>"1"}
  User Load (0.3ms)  SELECT  "users".* FROM "users" WHERE "users"."is_admin" = ? LIMIT 1  [["is_admin", "t"]]
  User Load (0.2ms)  SELECT  "users".* FROM "users" WHERE "users"."id" = ? LIMIT 1  [["id", 1]]
  Folder Load (0.4ms)  SELECT  "folders".* FROM "folders" WHERE "folders"."id" = ? LIMIT 1  [["id", 1]]
  Permission Load (0.5ms)  SELECT "permissions".* FROM "permissions" WHERE "permissions"."folder_id" = ? AND "permissions"."group_id" IN (SELECT "groups"."id" FROM "groups" INNER JOIN "groups_users" ON "groups"."id" = "groups_users"."group_id" WHERE "groups_users"."user_id" = ?)  [["folder_id", 1], ["user_id", 1]]
  Group Load (0.3ms)  SELECT  "groups".* FROM "groups" INNER JOIN "groups_users" ON "groups"."id" = "groups_users"."group_id" WHERE "groups_users"."user_id" = ? AND "groups"."name" = ?  ORDER BY "groups"."id" ASC LIMIT 1  [["user_id", 1], ["name", "Admins"]]
  Folder Load (0.2ms)  SELECT "folders".* FROM "folders" WHERE "folders"."parent_id" = ?  ORDER BY name  [["parent_id", 1]]
  UserFile Load (0.2ms)  SELECT "user_files".* FROM "user_files" WHERE "user_files"."folder_id" = ?  ORDER BY "user_files"."attachment_file_name" ASC  [["folder_id", 1]]
  CACHE (0.0ms)  SELECT  "groups".* FROM "groups" INNER JOIN "groups_users" ON "groups"."id" = "groups_users"."group_id" WHERE "groups_users"."user_id" = ? AND "groups"."name" = ?  ORDER BY "groups"."id" ASC LIMIT 1  [["user_id", 1], ["name", "Admins"]]
  Permission Load (0.2ms)  SELECT "permissions".* FROM "permissions" WHERE "permissions"."folder_id" = ?  [["folder_id", 1]]
  Group Load (0.2ms)  SELECT  "groups".* FROM "groups" WHERE "groups"."id" = ? LIMIT 1  [["id", 1]]
  Rendered permissions/_form.html.erb (17.2ms)
  Rendered clipboard/_clipboard_empty.en.html.erb (0.5ms)
  Rendered clipboard/_show.html.erb (7.0ms)
  Rendered folders/show.html.erb within layouts/application (106.6ms)
  Rendered shared/_header.html.erb (2.3ms)
  CACHE (0.0ms)  SELECT  "groups".* FROM "groups" INNER JOIN "groups_users" ON "groups"."id" = "groups_users"."group_id" WHERE "groups_users"."user_id" = ? AND "groups"."name" = ?  ORDER BY "groups"."id" ASC LIMIT 1  [["user_id", 1], ["name", "Admins"]]
  Rendered shared/_menu.html.erb (1.4ms)
  Rendered shared/_footer.html.erb (0.0ms)
Completed 200 OK in 167ms (Views: 159.3ms | ActiveRecord: 2.6ms)


>>>>>>>>>>>>>>>>>>>>>>
click "create folder"

tarted GET "/folders/1/folders/new" for 127.0.0.1 at 2015-10-07 15:13:13 -0700
Processing by FoldersController#new as HTML
  Parameters: {"folder_id"=>"1"}
  User Load (0.3ms)  SELECT  "users".* FROM "users" WHERE "users"."is_admin" = ? LIMIT 1  [["is_admin", "t"]]
  User Load (0.2ms)  SELECT  "users".* FROM "users" WHERE "users"."id" = ? LIMIT 1  [["id", 1]]
  Folder Load (0.1ms)  SELECT  "folders".* FROM "folders" WHERE "folders"."id" = ? LIMIT 1  [["id", 1]]
  Permission Load (0.2ms)  SELECT "permissions".* FROM "permissions" WHERE "permissions"."folder_id" = ? AND "permissions"."group_id" IN (SELECT "groups"."id" FROM "groups" INNER JOIN "groups_users" ON "groups"."id" = "groups_users"."group_id" WHERE "groups_users"."user_id" = ?)  [["folder_id", 1], ["user_id", 1]]
  Rendered folders/_form.html.erb (2.5ms)
  Rendered folders/new.html.erb within layouts/application (7.4ms)
  Rendered shared/_header.html.erb (3.6ms)
  Group Load (0.3ms)  SELECT  "groups".* FROM "groups" INNER JOIN "groups_users" ON "groups"."id" = "groups_users"."group_id" WHERE "groups_users"."user_id" = ? AND "groups"."name" = ?  ORDER BY "groups"."id" ASC LIMIT 1  [["user_id", 1], ["name", "Admins"]]
  Rendered shared/_menu.html.erb (3.2ms)
  Rendered shared/_footer.html.erb (0.1ms)
Completed 200 OK in 97ms (Views: 86.3ms | ActiveRecord: 1.1ms)

>>>>>>>>>>>
after "create folder", click save

Started POST "/folders/1/folders" for 127.0.0.1 at 2015-10-07 15:13:38 -0700
Processing by FoldersController#create as HTML
  Parameters: {"utf8"=>"✓", "authenticity_token"=>"nvvgojzFxbEGCdRlOsdAioMJzcGvW4uMVvbBIPnYHClPSL0HOSV6hvxe0xhdgeIio1ZCgT3RS0TjpjIMZ1//Pw==", "folder"=>{"name"=>"my_first_folder"}, "commit"=>"Save", "folder_id"=>"1"}
  User Load (0.3ms)  SELECT  "users".* FROM "users" WHERE "users"."is_admin" = ? LIMIT 1  [["is_admin", "t"]]
  User Load (0.2ms)  SELECT  "users".* FROM "users" WHERE "users"."id" = ? LIMIT 1  [["id", 1]]
  Folder Load (0.1ms)  SELECT  "folders".* FROM "folders" WHERE "folders"."id" = ? LIMIT 1  [["id", 1]]
  Permission Load (0.2ms)  SELECT "permissions".* FROM "permissions" WHERE "permissions"."folder_id" = ? AND "permissions"."group_id" IN (SELECT "groups"."id" FROM "groups" INNER JOIN "groups_users" ON "groups"."id" = "groups_users"."group_id" WHERE "groups_users"."user_id" = ?)  [["folder_id", 1], ["user_id", 1]]
   (0.1ms)  begin transaction
  Folder Exists (0.3ms)  SELECT  1 AS one FROM "folders" WHERE ("folders"."name" = 'my_first_folder' AND "folders"."parent_id" = 1) LIMIT 1
  SQL (0.3ms)  INSERT INTO "folders" ("name", "parent_id", "created_at", "updated_at") VALUES (?, ?, ?, ?)  [["name", "my_first_folder"], ["parent_id", 1], ["created_at", "2015-10-07 22:13:38.116183"], ["updated_at", "2015-10-07 22:13:38.116183"]]
  Permission Load (0.1ms)  SELECT "permissions".* FROM "permissions" WHERE "permissions"."folder_id" = ?  [["folder_id", 1]]
  Group Load (0.1ms)  SELECT  "groups".* FROM "groups" WHERE "groups"."id" = ? LIMIT 1  [["id", 1]]
  SQL (0.1ms)  INSERT INTO "permissions" ("group_id", "folder_id", "can_create", "can_read", "can_update", "can_delete") VALUES (?, ?, ?, ?, ?, ?)  [["group_id", 1], ["folder_id", 2], ["can_create", "t"], ["can_read", "t"], ["can_update", "t"], ["can_delete", "t"]]
   (1.1ms)  commit transaction
Redirected to http://localhost:3000/folders/1
Completed 302 Found in 21ms (ActiveRecord: 3.0ms)


Started GET "/folders/1" for 127.0.0.1 at 2015-10-07 15:13:38 -0700
Processing by FoldersController#show as HTML
  Parameters: {"id"=>"1"}
  User Load (0.2ms)  SELECT  "users".* FROM "users" WHERE "users"."is_admin" = ? LIMIT 1  [["is_admin", "t"]]
  User Load (0.1ms)  SELECT  "users".* FROM "users" WHERE "users"."id" = ? LIMIT 1  [["id", 1]]
  Folder Load (0.2ms)  SELECT  "folders".* FROM "folders" WHERE "folders"."id" = ? LIMIT 1  [["id", 1]]
  Permission Load (0.2ms)  SELECT "permissions".* FROM "permissions" WHERE "permissions"."folder_id" = ? AND "permissions"."group_id" IN (SELECT "groups"."id" FROM "groups" INNER JOIN "groups_users" ON "groups"."id" = "groups_users"."group_id" WHERE "groups_users"."user_id" = ?)  [["folder_id", 1], ["user_id", 1]]
  Group Load (0.2ms)  SELECT  "groups".* FROM "groups" INNER JOIN "groups_users" ON "groups"."id" = "groups_users"."group_id" WHERE "groups_users"."user_id" = ? AND "groups"."name" = ?  ORDER BY "groups"."id" ASC LIMIT 1  [["user_id", 1], ["name", "Admins"]]
  Folder Load (0.1ms)  SELECT "folders".* FROM "folders" WHERE "folders"."parent_id" = ?  ORDER BY name  [["parent_id", 1]]
  Permission Load (0.2ms)  SELECT "permissions".* FROM "permissions" WHERE "permissions"."folder_id" = ? AND "permissions"."group_id" IN (SELECT "groups"."id" FROM "groups" INNER JOIN "groups_users" ON "groups"."id" = "groups_users"."group_id" WHERE "groups_users"."user_id" = ?)  [["folder_id", 2], ["user_id", 1]]
  CACHE (0.0ms)  SELECT "permissions".* FROM "permissions" WHERE "permissions"."folder_id" = ? AND "permissions"."group_id" IN (SELECT "groups"."id" FROM "groups" INNER JOIN "groups_users" ON "groups"."id" = "groups_users"."group_id" WHERE "groups_users"."user_id" = ?)  [["folder_id", 2], ["user_id", 1]]
  CACHE (0.0ms)  SELECT "permissions".* FROM "permissions" WHERE "permissions"."folder_id" = ? AND "permissions"."group_id" IN (SELECT "groups"."id" FROM "groups" INNER JOIN "groups_users" ON "groups"."id" = "groups_users"."group_id" WHERE "groups_users"."user_id" = ?)  [["folder_id", 2], ["user_id", 1]]
  UserFile Load (0.1ms)  SELECT "user_files".* FROM "user_files" WHERE "user_files"."folder_id" = ?  ORDER BY "user_files"."attachment_file_name" ASC  [["folder_id", 1]]
  CACHE (0.0ms)  SELECT  "groups".* FROM "groups" INNER JOIN "groups_users" ON "groups"."id" = "groups_users"."group_id" WHERE "groups_users"."user_id" = ? AND "groups"."name" = ?  ORDER BY "groups"."id" ASC LIMIT 1  [["user_id", 1], ["name", "Admins"]]
  Permission Load (0.1ms)  SELECT "permissions".* FROM "permissions" WHERE "permissions"."folder_id" = ?  [["folder_id", 1]]
  Group Load (0.1ms)  SELECT  "groups".* FROM "groups" WHERE "groups"."id" = ? LIMIT 1  [["id", 1]]
  Rendered permissions/_form.html.erb (5.8ms)
  Rendered clipboard/_clipboard_empty.en.html.erb (0.1ms)
  Rendered clipboard/_show.html.erb (3.6ms)
  Rendered folders/show.html.erb within layouts/application (104.3ms)
  Rendered shared/_header.html.erb (2.2ms)
  CACHE (0.0ms)  SELECT  "groups".* FROM "groups" INNER JOIN "groups_users" ON "groups"."id" = "groups_users"."group_id" WHERE "groups_users"."user_id" = ? AND "groups"."name" = ?  ORDER BY "groups"."id" ASC LIMIT 1  [["user_id", 1], ["name", "Admins"]]
  Rendered shared/_menu.html.erb (1.2ms)
  Rendered shared/_footer.html.erb (0.0ms)
Completed 200 OK in 156ms (Views

>>>>>>>>>>>>>>
click "update files"

Started GET "/folders/1/files/new" for 127.0.0.1 at 2015-10-07 15:14:07 -0700
Processing by FilesController#new as HTML
  Parameters: {"folder_id"=>"1"}
  User Load (0.3ms)  SELECT  "users".* FROM "users" WHERE "users"."is_admin" = ? LIMIT 1  [["is_admin", "t"]]
  User Load (0.2ms)  SELECT  "users".* FROM "users" WHERE "users"."id" = ? LIMIT 1  [["id", 1]]
  Folder Load (0.1ms)  SELECT  "folders".* FROM "folders" WHERE "folders"."id" = ? LIMIT 1  [["id", 1]]
  Permission Load (0.3ms)  SELECT "permissions".* FROM "permissions" WHERE "permissions"."folder_id" = ? AND "permissions"."group_id" IN (SELECT "groups"."id" FROM "groups" INNER JOIN "groups_users" ON "groups"."id" = "groups_users"."group_id" WHERE "groups_users"."user_id" = ?)  [["folder_id", 1], ["user_id", 1]]
  Rendered files/new.html.erb within layouts/application (41.9ms)
  Rendered shared/_header.html.erb (2.4ms)
  Group Load (0.2ms)  SELECT  "groups".* FROM "groups" INNER JOIN "groups_users" ON "groups"."id" = "groups_users"."group_id" WHERE "groups_users"."user_id" = ? AND "groups"."name" = ?  ORDER BY "groups"."id" ASC LIMIT 1  [["user_id", 1], ["name", "Admins"]]
  Rendered shared/_menu.html.erb (1.8ms)
  Rendered shared/_footer.html.erb (0.0ms)
Completed 200 OK in 129ms (Views: 107.7ms | ActiveRecord: 1.3ms)


>>>>>>>>>>>>>
upload a file

Started GET "/file_exists?name=classic-cartoon-vector19.jpg&folder=1" for 127.0.0.1 at 2015-10-07 15:14:26 -0700
Processing by FilesController#exists as JSON
  Parameters: {"name"=>"classic-cartoon-vector19.jpg", "folder"=>"1"}
  User Load (0.3ms)  SELECT  "users".* FROM "users" WHERE "users"."is_admin" = ? LIMIT 1  [["is_admin", "t"]]
  User Load (0.2ms)  SELECT  "users".* FROM "users" WHERE "users"."id" = ? LIMIT 1  [["id", 1]]
  UserFile Exists (0.3ms)  SELECT  1 AS one FROM "user_files" WHERE ("user_files"."attachment_file_name" = 'classic-cartoon-vector19.jpg' AND "user_files"."folder_id" = 1) LIMIT 1
Completed 200 OK in 11ms (Views: 0.4ms | ActiveRecord: 0.8ms)


Started GET "/assets/spinner-0afc1563956ab122015ba991810226d1f4d464d797ac056a854d785908e4d407.gif" for 127.0.0.1 at 2015-10-07 15:14:26 -0700


Started GET "/assets/failed-62746655a4c534ab1061717fcbfe4165996d426df79cdaaae10171b575d3e55e.png" for 127.0.0.1 at 2015-10-07 15:14:26 -0700


Started GET "/assets/tick-f77e46a4231a6b941cf6e71f96fc23c846f201fae6a7084e84f920c967fba99c.png" for 127.0.0.1 at 2015-10-07 15:14:26 -0700


Started POST "/folders/1/files" for 127.0.0.1 at 2015-10-07 15:14:26 -0700
Processing by FilesController#create as JS
  Parameters: {"utf8"=>"✓", "authenticity_token"=>"66xyMtMHkNdkxCVUd1jpSvLM+K9q4uU/JYsWTd+RIoI6Hy+X1ucv4J6TIikQHkvi0pN37/hoJfeQ2+VhQRbBlA==", "target_folder_id"=>"1", "user_file"=>{"attachment"=>#<ActionDispatch::Http::UploadedFile:0x007fd85a053478 @tempfile=#<Tempfile:/tmp/RackMultipart20151007-103416-1uy0orz.jpg>, @original_filename="classic-cartoon-vector19.jpg", @content_type="image/jpeg", @headers="Content-Disposition: form-data; name=\"user_file[attachment]\"; filename=\"classic-cartoon-vector19.jpg\"\r\nContent-Type: image/jpeg\r\n">}, "folder_id"=>"1"}
  User Load (0.2ms)  SELECT  "users".* FROM "users" WHERE "users"."is_admin" = ? LIMIT 1  [["is_admin", "t"]]
  User Load (0.1ms)  SELECT  "users".* FROM "users" WHERE "users"."id" = ? LIMIT 1  [["id", 1]]
  Folder Load (0.1ms)  SELECT  "folders".* FROM "folders" WHERE "folders"."id" = ? LIMIT 1  [["id", 1]]
  Permission Load (0.2ms)  SELECT "permissions".* FROM "permissions" WHERE "permissions"."folder_id" = ? AND "permissions"."group_id" IN (SELECT "groups"."id" FROM "groups" INNER JOIN "groups_users" ON "groups"."id" = "groups_users"."group_id" WHERE "groups_users"."user_id" = ?)  [["folder_id", 1], ["user_id", 1]]
   (0.1ms)  begin transaction
  UserFile Exists (0.2ms)  SELECT  1 AS one FROM "user_files" WHERE ("user_files"."attachment_file_name" = 'classic-cartoon-vector19.jpg' AND "user_files"."folder_id" = 1) LIMIT 1
  SQL (0.3ms)  INSERT INTO "user_files" ("attachment_file_name", "attachment_content_type", "attachment_file_size", "attachment_updated_at", "folder_id", "created_at", "updated_at") VALUES (?, ?, ?, ?, ?, ?, ?)  [["attachment_file_name", "classic-cartoon-vector19.jpg"], ["attachment_content_type", "image/jpeg"], ["attachment_file_size", 20068], ["attachment_updated_at", "2015-10-07 22:14:26.826167"], ["folder_id", 1], ["created_at", "2015-10-07 22:14:26.830278"], ["updated_at", "2015-10-07 22:14:26.830278"]]
   (1.7ms)  commit transaction
  Rendered text template (0.0ms)
Completed 200 OK in 29ms (Views: 2.1ms | ActiveRecord: 3.1ms)


Started GET "/folders/1" for 127.0.0.1 at 2015-10-07 15:14:26 -0700
Processing by FoldersController#show as HTML
  Parameters: {"id"=>"1"}
  User Load (0.1ms)  SELECT  "users".* FROM "users" WHERE "users"."is_admin" = ? LIMIT 1  [["is_admin", "t"]]
  User Load (0.1ms)  SELECT  "users".* FROM "users" WHERE "users"."id" = ? LIMIT 1  [["id", 1]]
  Folder Load (0.1ms)  SELECT  "folders".* FROM "folders" WHERE "folders"."id" = ? LIMIT 1  [["id", 1]]
  Permission Load (0.2ms)  SELECT "permissions".* FROM "permissions" WHERE "permissions"."folder_id" = ? AND "permissions"."group_id" IN (SELECT "groups"."id" FROM "groups" INNER JOIN "groups_users" ON "groups"."id" = "groups_users"."group_id" WHERE "groups_users"."user_id" = ?)  [["folder_id", 1], ["user_id", 1]]
  Group Load (0.1ms)  SELECT  "groups".* FROM "groups" INNER JOIN "groups_users" ON "groups"."id" = "groups_users"."group_id" WHERE "groups_users"."user_id" = ? AND "groups"."name" = ?  ORDER BY "groups"."id" ASC LIMIT 1  [["user_id", 1], ["name", "Admins"]]
  Folder Load (0.1ms)  SELECT "folders".* FROM "folders" WHERE "folders"."parent_id" = ?  ORDER BY name  [["parent_id", 1]]
  Permission Load (0.1ms)  SELECT "permissions".* FROM "permissions" WHERE "permissions"."folder_id" = ? AND "permissions"."group_id" IN (SELECT "groups"."id" FROM "groups" INNER JOIN "groups_users" ON "groups"."id" = "groups_users"."group_id" WHERE "groups_users"."user_id" = ?)  [["folder_id", 2], ["user_id", 1]]
  CACHE (0.0ms)  SELECT "permissions".* FROM "permissions" WHERE "permissions"."folder_id" = ? AND "permissions"."group_id" IN (SELECT "groups"."id" FROM "groups" INNER JOIN "groups_users" ON "groups"."id" = "groups_users"."group_id" WHERE "groups_users"."user_id" = ?)  [["folder_id", 2], ["user_id", 1]]
  CACHE (0.0ms)  SELECT "permissions".* FROM "permissions" WHERE "permissions"."folder_id" = ? AND "permissions"."group_id" IN (SELECT "groups"."id" FROM "groups" INNER JOIN "groups_users" ON "groups"."id" = "groups_users"."group_id" WHERE "groups_users"."user_id" = ?)  [["folder_id", 2], ["user_id", 1]]
  UserFile Load (0.1ms)  SELECT "user_files".* FROM "user_files" WHERE "user_files"."folder_id" = ?  ORDER BY "user_files"."attachment_file_name" ASC  [["folder_id", 1]]
  CACHE (0.0ms)  SELECT "permissions".* FROM "permissions" WHERE "permissions"."folder_id" = ? AND "permissions"."group_id" IN (SELECT "groups"."id" FROM "groups" INNER JOIN "groups_users" ON "groups"."id" = "groups_users"."group_id" WHERE "groups_users"."user_id" = ?)  [["folder_id", 1], ["user_id", 1]]
  Folder Load (0.2ms)  SELECT  "folders".* FROM "folders" WHERE "folders"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.1ms)  SELECT "permissions".* FROM "permissions" WHERE "permissions"."folder_id" = ? AND "permissions"."group_id" IN (SELECT "groups"."id" FROM "groups" INNER JOIN "groups_users" ON "groups"."id" = "groups_users"."group_id" WHERE "groups_users"."user_id" = ?)  [["folder_id", 1], ["user_id", 1]]
  CACHE (0.0ms)  SELECT "permissions".* FROM "permissions" WHERE "permissions"."folder_id" = ? AND "permissions"."group_id" IN (SELECT "groups"."id" FROM "groups" INNER JOIN "groups_users" ON "groups"."id" = "groups_users"."group_id" WHERE "groups_users"."user_id" = ?)  [["folder_id", 1], ["user_id", 1]]
  CACHE (0.0ms)  SELECT  "groups".* FROM "groups" INNER JOIN "groups_users" ON "groups"."id" = "groups_users"."group_id" WHERE "groups_users"."user_id" = ? AND "groups"."name" = ?  ORDER BY "groups"."id" ASC LIMIT 1  [["user_id", 1], ["name", "Admins"]]
  Permission Load (0.1ms)  SELECT "permissions".* FROM "permissions" WHERE "permissions"."folder_id" = ?  [["folder_id", 1]]
  Group Load (0.1ms)  SELECT  "groups".* FROM "groups" WHERE "groups"."id" = ? LIMIT 1  [["id", 1]]
  Rendered permissions/_form.html.erb (6.6ms)
  Rendered clipboard/_clipboard_empty.en.html.erb (0.1ms)
  Rendered clipboard/_show.html.erb (4.2ms)
  Rendered folders/show.html.erb within layouts/application (134.5ms)
  Rendered shared/_header.html.erb (2.5ms)
  CACHE (0.0ms)  SELECT  "groups".* FROM "groups" INNER JOIN "groups_users" ON "groups"."id" = "groups_users"."group_id" WHERE "groups_users"."user_id" = ? AND "groups"."name" = ?  ORDER BY "groups"."id" ASC LIMIT 1  [["user_id", 1], ["name", "Admins"]]
  Rendered shared/_menu.html.erb (1.4ms)
  Rendered shared/_footer.html.erb (0.0ms)
Completed 200 OK in 199ms (Views: 194.7ms | ActiveRecord: 1.7ms)

>>>>>>>>>>>>>>>>>>>>>
click "share files"

Started GET "/share_links" for 127.0.0.1 at 2015-10-07 15:15:00 -0700
Processing by ShareLinksController#index as HTML
  User Load (0.3ms)  SELECT  "users".* FROM "users" WHERE "users"."is_admin" = ? LIMIT 1  [["is_admin", "t"]]
  User Load (0.2ms)  SELECT  "users".* FROM "users" WHERE "users"."id" = ? LIMIT 1  [["id", 1]]
  Group Load (0.3ms)  SELECT  "groups".* FROM "groups" INNER JOIN "groups_users" ON "groups"."id" = "groups_users"."group_id" WHERE "groups_users"."user_id" = ? AND "groups"."name" = ?  ORDER BY "groups"."id" ASC LIMIT 1  [["user_id", 1], ["name", "Admins"]]
  ShareLink Load (0.4ms)  SELECT "share_links".* FROM "share_links" WHERE (link_expires_at >= '2015-10-07 22:15:00.319361')  ORDER BY "share_links"."link_expires_at" ASC
  Rendered share_links/index.html.erb within layouts/application (4.1ms)
  Rendered shared/_header.html.erb (3.4ms)
  CACHE (0.0ms)  SELECT  "groups".* FROM "groups" INNER JOIN "groups_users" ON "groups"."id" = "groups_users"."group_id" WHERE "groups_users"."user_id" = ? AND "groups"."name" = ?  ORDER BY "groups"."id" ASC LIMIT 1  [["user_id", 1], ["name", "Admins"]]
  Rendered shared/_menu.html.erb (1.8ms)
  Rendered shared/_footer.html.erb (0.2ms)
Completed 200 OK in 88ms (Views: 74.3ms | ActiveRecord: 1.3ms)

>>>>>>>>>>>>>>>>>>>>
select "groups"

Started GET "/groups" for 127.0.0.1 at 2015-10-07 15:16:18 -0700
Processing by GroupsController#index as HTML
  User Load (0.3ms)  SELECT  "users".* FROM "users" WHERE "users"."is_admin" = ? LIMIT 1  [["is_admin", "t"]]
  User Load (0.2ms)  SELECT  "users".* FROM "users" WHERE "users"."id" = ? LIMIT 1  [["id", 1]]
  Group Load (0.4ms)  SELECT  "groups".* FROM "groups" INNER JOIN "groups_users" ON "groups"."id" = "groups_users"."group_id" WHERE "groups_users"."user_id" = ? AND "groups"."name" = ?  ORDER BY "groups"."id" ASC LIMIT 1  [["user_id", 1], ["name", "Admins"]]
  Group Load (0.5ms)  SELECT "groups".* FROM "groups"  ORDER BY "groups"."name" ASC
  Rendered groups/index.html.erb within layouts/application (12.4ms)
  Rendered shared/_header.html.erb (3.4ms)
  CACHE (0.0ms)  SELECT  "groups".* FROM "groups" INNER JOIN "groups_users" ON "groups"."id" = "groups_users"."group_id" WHERE "groups_users"."user_id" = ? AND "groups"."name" = ?  ORDER BY "groups"."id" ASC LIMIT 1  [["user_id", 1], ["name", "Admins"]]
  Rendered shared/_menu.html.erb (2.3ms)
  Rendered shared/_footer.html.erb (0.0ms)
Completed 200 OK in 100ms (Views: 92.7ms | ActiveRecord: 1.4ms)

>>>>>>>>>>>>>>>>>

select "create new group"

tarted GET "/groups/new" for 127.0.0.1 at 2015-10-07 15:16:39 -0700
Processing by GroupsController#new as HTML
  User Load (0.3ms)  SELECT  "users".* FROM "users" WHERE "users"."is_admin" = ? LIMIT 1  [["is_admin", "t"]]
  User Load (0.2ms)  SELECT  "users".* FROM "users" WHERE "users"."id" = ? LIMIT 1  [["id", 1]]
  Group Load (0.2ms)  SELECT  "groups".* FROM "groups" INNER JOIN "groups_users" ON "groups"."id" = "groups_users"."group_id" WHERE "groups_users"."user_id" = ? AND "groups"."name" = ?  ORDER BY "groups"."id" ASC LIMIT 1  [["user_id", 1], ["name", "Admins"]]
  Rendered groups/_form.html.erb (4.5ms)
  Rendered groups/new.html.erb within layouts/application (6.7ms)
  Rendered shared/_header.html.erb (2.9ms)
  CACHE (0.0ms)  SELECT  "groups".* FROM "groups" INNER JOIN "groups_users" ON "groups"."id" = "groups_users"."group_id" WHERE "groups_users"."user_id" = ? AND "groups"."name" = ?  ORDER BY "groups"."id" ASC LIMIT 1  [["user_id", 1], ["name", "Admins"]]
  Rendered shared/_menu.html.erb (1.7ms)
  Rendered shared/_footer.html.erb (0.1ms)
Completed 200 OK in 82ms (Views: 75.1ms | ActiveRecord: 0.7ms)


>>>>>>>>>>>>>>>>
create new group

Started POST "/groups" for 127.0.0.1 at 2015-10-07 15:16:59 -0700
Processing by GroupsController#create as HTML
  Parameters: {"utf8"=>"✓", "authenticity_token"=>"Ohfh7TSMcaMiN0TUMvxhAYsSXHBNuc4R4JpIBjyFOWjrpLxIMWzOlNhgQ6lVusOpq03TMN8zDtlVyrsqogLafg==", "group"=>{"name"=>"my_new_group"}, "commit"=>"Save"}
  User Load (0.3ms)  SELECT  "users".* FROM "users" WHERE "users"."is_admin" = ? LIMIT 1  [["is_admin", "t"]]
  User Load (0.2ms)  SELECT  "users".* FROM "users" WHERE "users"."id" = ? LIMIT 1  [["id", 1]]
  Group Load (0.2ms)  SELECT  "groups".* FROM "groups" INNER JOIN "groups_users" ON "groups"."id" = "groups_users"."group_id" WHERE "groups_users"."user_id" = ? AND "groups"."name" = ?  ORDER BY "groups"."id" ASC LIMIT 1  [["user_id", 1], ["name", "Admins"]]
   (0.2ms)  begin transaction
  Group Exists (0.3ms)  SELECT  1 AS one FROM "groups" WHERE "groups"."name" = 'my_new_group' LIMIT 1
  SQL (0.3ms)  INSERT INTO "groups" ("name", "created_at", "updated_at") VALUES (?, ?, ?)  [["name", "my_new_group"], ["created_at", "2015-10-07 22:16:59.428666"], ["updated_at", "2015-10-07 22:16:59.428666"]]
  Folder Load (0.2ms)  SELECT  "folders".* FROM "folders"  ORDER BY "folders"."id" ASC LIMIT 1000
  SQL (0.1ms)  INSERT INTO "permissions" ("group_id", "folder_id", "can_create", "can_read", "can_update", "can_delete") VALUES (?, ?, ?, ?, ?, ?)  [["group_id", 2], ["folder_id", 1], ["can_create", "f"], ["can_read", "t"], ["can_update", "f"], ["can_delete", "f"]]
  Folder Load (0.1ms)  SELECT  "folders".* FROM "folders" WHERE "folders"."id" = ? LIMIT 1  [["id", 1]]
  SQL (0.1ms)  INSERT INTO "permissions" ("group_id", "folder_id", "can_create", "can_read", "can_update", "can_delete") VALUES (?, ?, ?, ?, ?, ?)  [["group_id", 2], ["folder_id", 2], ["can_create", "f"], ["can_read", "f"], ["can_update", "f"], ["can_delete", "f"]]
   (1.3ms)  commit transaction
Redirected to http://localhost:3000/groups
Completed 302 Found in 22ms (ActiveRecord: 3.2ms)


Started GET "/groups" for 127.0.0.1 at 2015-10-07 15:16:59 -0700
Processing by GroupsController#index as HTML
  User Load (0.2ms)  SELECT  "users".* FROM "users" WHERE "users"."is_admin" = ? LIMIT 1  [["is_admin", "t"]]
  User Load (0.1ms)  SELECT  "users".* FROM "users" WHERE "users"."id" = ? LIMIT 1  [["id", 1]]
  Group Load (0.2ms)  SELECT  "groups".* FROM "groups" INNER JOIN "groups_users" ON "groups"."id" = "groups_users"."group_id" WHERE "groups_users"."user_id" = ? AND "groups"."name" = ?  ORDER BY "groups"."id" ASC LIMIT 1  [["user_id", 1], ["name", "Admins"]]
  Group Load (0.2ms)  SELECT "groups".* FROM "groups"  ORDER BY "groups"."name" ASC
  Rendered groups/index.html.erb within layouts/application (35.1ms)
  Rendered shared/_header.html.erb (3.3ms)
  CACHE (0.0ms)  SELECT  "groups".* FROM "groups" INNER JOIN "groups_users" ON "groups"."id" = "groups_users"."group_id" WHERE "groups_users"."user_id" = ? AND "groups"."name" = ?  ORDER BY "groups"."id" ASC LIMIT 1  [["user_id", 1], ["name", "Admins"]]
  Rendered shared/_menu.html.erb (2.1ms)
  Rendered shared/_footer.html.erb (0.0ms)
Completed 200 OK in 116ms (Views: 110.7ms | ActiveRecord: 0.8ms)

>>>>>>>>>>>>>
create new user

Started GET "/users/new" for 127.0.0.1 at 2015-10-07 15:17:23 -0700
Processing by UsersController#new as HTML
  User Load (0.3ms)  SELECT  "users".* FROM "users" WHERE "users"."is_admin" = ? LIMIT 1  [["is_admin", "t"]]
  User Load (0.2ms)  SELECT  "users".* FROM "users" WHERE "users"."id" = ? LIMIT 1  [["id", 1]]
  Group Load (0.2ms)  SELECT  "groups".* FROM "groups" INNER JOIN "groups_users" ON "groups"."id" = "groups_users"."group_id" WHERE "groups_users"."user_id" = ? AND "groups"."name" = ?  ORDER BY "groups"."id" ASC LIMIT 1  [["user_id", 1], ["name", "Admins"]]
  CACHE (0.0ms)  SELECT  "groups".* FROM "groups" INNER JOIN "groups_users" ON "groups"."id" = "groups_users"."group_id" WHERE "groups_users"."user_id" = ? AND "groups"."name" = ?  ORDER BY "groups"."id" ASC LIMIT 1  [["user_id", 1], ["name", "Admins"]]
  Group Load (0.3ms)  SELECT "groups".* FROM "groups"
  Rendered users/_form.html.erb (14.8ms)
  Rendered users/new.html.erb within layouts/application (17.1ms)
  Rendered shared/_header.html.erb (3.8ms)
  CACHE (0.0ms)  SELECT  "groups".* FROM "groups" INNER JOIN "groups_users" ON "groups"."id" = "groups_users"."group_id" WHERE "groups_users"."user_id" = ? AND "groups"."name" = ?  ORDER BY "groups"."id" ASC LIMIT 1  [["user_id", 1], ["name", "Admins"]]
  Rendered shared/_menu.html.erb (2.8ms)
  Rendered shared/_footer.html.erb (0.1ms)
Completed 200 OK in 105ms (Views: 97.2ms | ActiveRecord: 1.1ms)

>>>>>>>>>>>>

create new user

Started POST "/users" for 127.0.0.1 at 2015-10-07 15:17:46 -0700
Processing by UsersController#create as HTML
  Parameters: {"utf8"=>"✓", "authenticity_token"=>"KtJ+snfqVfMP8mNXS1v0DzSaqOeEoQN8fd/OFK8gqED7YSMXcgrqxPWlZCosHVanFMUnpxYrw7TIjz04MadLVg==", "user"=>{"email"=>"new_user@example.com", "group_ids"=>["2", ""]}, "commit"=>"Save"}
  User Load (0.4ms)  SELECT  "users".* FROM "users" WHERE "users"."is_admin" = ? LIMIT 1  [["is_admin", "t"]]
  User Load (0.2ms)  SELECT  "users".* FROM "users" WHERE "users"."id" = ? LIMIT 1  [["id", 1]]
  Group Load (0.2ms)  SELECT  "groups".* FROM "groups" INNER JOIN "groups_users" ON "groups"."id" = "groups_users"."group_id" WHERE "groups_users"."user_id" = ? AND "groups"."name" = ?  ORDER BY "groups"."id" ASC LIMIT 1  [["user_id", 1], ["name", "Admins"]]
  CACHE (0.0ms)  SELECT  "groups".* FROM "groups" INNER JOIN "groups_users" ON "groups"."id" = "groups_users"."group_id" WHERE "groups_users"."user_id" = ? AND "groups"."name" = ?  ORDER BY "groups"."id" ASC LIMIT 1  [["user_id", 1], ["name", "Admins"]]
  Group Load (0.1ms)  SELECT  "groups".* FROM "groups" WHERE "groups"."id" = ? LIMIT 1  [["id", 2]]
   (0.2ms)  begin transaction
  Group Exists (0.3ms)  SELECT  1 AS one FROM "groups" WHERE ("groups"."name" = 'my_new_group' AND "groups"."id" != 2) LIMIT 1
  User Exists (0.1ms)  SELECT  1 AS one FROM "users" WHERE "users"."email" = 'new_user@example.com' LIMIT 1
  SQL (0.4ms)  INSERT INTO "users" ("email", "created_at", "updated_at", "signup_token", "signup_token_expires_at") VALUES (?, ?, ?, ?, ?)  [["email", "new_user@example.com"], ["created_at", "2015-10-07 22:17:47.015751"], ["updated_at", "2015-10-07 22:17:47.015751"], ["signup_token", "118eb4890f16b48288e1"], ["signup_token_expires_at", "2015-10-21 22:17:47.016156"]]
  SQL (0.2ms)  INSERT INTO "groups_users" ("group_id", "user_id") VALUES (?, ?)  [["group_id", 2], ["user_id", 2]]
   (1.3ms)  commit transaction
  Rendered user_mailer/signup_email.en.text.erb (4.6ms)


if ENV[‘RUBY_PRINT_DETAIL’]==1 then
