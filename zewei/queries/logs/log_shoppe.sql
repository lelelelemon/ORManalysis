>>>>>>>>>>>>>>>>>>>>>>>
load localhost:3000

ActiveRecord::SchemaMigration Load (0.3ms)  SELECT "schema_migrations".* FROM "schema_migrations"
Processing by PagesController#home as HTML
  Shoppe::Product Load (0.3ms)  SELECT "shoppe_products".* FROM "shoppe_products" WHERE "shoppe_products"."active" = ? AND "shoppe_products"."featured" = ? AND "shoppe_products"."parent_id" IS NULL  [["active", "t"], ["featured", "t"]]
  Shoppe::ProductCategorization Load (0.2ms)  SELECT "shoppe_product_categorizations".* FROM "shoppe_product_categorizations" WHERE "shoppe_product_categorizations"."product_id" IN (1, 4, 5, 8, 11)
  Shoppe::ProductCategory Load (0.2ms)  SELECT "shoppe_product_categories".* FROM "shoppe_product_categories" WHERE "shoppe_product_categories"."id" IN (1, 2)
  Shoppe::Product Load (0.2ms)  SELECT "shoppe_products".* FROM "shoppe_products" WHERE "shoppe_products"."parent_id" IN (1, 4, 5, 8, 11)
  Shoppe::Attachment Load (0.4ms)  SELECT  "shoppe_attachments".* FROM "shoppe_attachments" WHERE "shoppe_attachments"."parent_id" = ? AND "shoppe_attachments"."parent_type" = ? AND "shoppe_attachments"."role" = ?  ORDER BY "shoppe_attachments"."id" ASC LIMIT 1  [["parent_id", 1], ["parent_type", "Shoppe::Product"], ["role", "default_image"]]
  CACHE (0.0ms)  SELECT  "shoppe_attachments".* FROM "shoppe_attachments" WHERE "shoppe_attachments"."parent_id" = ? AND "shoppe_attachments"."parent_type" = ? AND "shoppe_attachments"."role" = ?  ORDER BY "shoppe_attachments"."id" ASC LIMIT 1  [["parent_id", 1], ["parent_type", "Shoppe::Product"], ["role", "default_image"]]
  Shoppe::Product::Translation Load (0.2ms)  SELECT "shoppe_product_translations".* FROM "shoppe_product_translations" WHERE "shoppe_product_translations"."shoppe_product_id" = ?  [["shoppe_product_id", 1]]
  Shoppe::ProductCategory::Translation Load (0.3ms)  SELECT "shoppe_product_category_translations".* FROM "shoppe_product_category_translations" WHERE "shoppe_product_category_translations"."shoppe_product_category_id" = ?  [["shoppe_product_category_id", 1]]
  Shoppe::Setting Load (0.1ms)  SELECT "shoppe_settings".* FROM "shoppe_settings"
  Shoppe::Attachment Load (0.2ms)  SELECT  "shoppe_attachments".* FROM "shoppe_attachments" WHERE "shoppe_attachments"."parent_id" = ? AND "shoppe_attachments"."parent_type" = ? AND "shoppe_attachments"."role" = ?  ORDER BY "shoppe_attachments"."id" ASC LIMIT 1  [["parent_id", 4], ["parent_type", "Shoppe::Product"], ["role", "default_image"]]
  CACHE (0.0ms)  SELECT  "shoppe_attachments".* FROM "shoppe_attachments" WHERE "shoppe_attachments"."parent_id" = ? AND "shoppe_attachments"."parent_type" = ? AND "shoppe_attachments"."role" = ?  ORDER BY "shoppe_attachments"."id" ASC LIMIT 1  [["parent_id", 4], ["parent_type", "Shoppe::Product"], ["role", "default_image"]]
  Shoppe::Product::Translation Load (0.1ms)  SELECT "shoppe_product_translations".* FROM "shoppe_product_translations" WHERE "shoppe_product_translations"."shoppe_product_id" = ?  [["shoppe_product_id", 4]]
  Shoppe::Attachment Load (0.1ms)  SELECT  "shoppe_attachments".* FROM "shoppe_attachments" WHERE "shoppe_attachments"."parent_id" = ? AND "shoppe_attachments"."parent_type" = ? AND "shoppe_attachments"."role" = ?  ORDER BY "shoppe_attachments"."id" ASC LIMIT 1  [["parent_id", 5], ["parent_type", "Shoppe::Product"], ["role", "default_image"]]
  CACHE (0.0ms)  SELECT  "shoppe_attachments".* FROM "shoppe_attachments" WHERE "shoppe_attachments"."parent_id" = ? AND "shoppe_attachments"."parent_type" = ? AND "shoppe_attachments"."role" = ?  ORDER BY "shoppe_attachments"."id" ASC LIMIT 1  [["parent_id", 5], ["parent_type", "Shoppe::Product"], ["role", "default_image"]]
  Shoppe::Product::Translation Load (0.1ms)  SELECT "shoppe_product_translations".* FROM "shoppe_product_translations" WHERE "shoppe_product_translations"."shoppe_product_id" = ?  [["shoppe_product_id", 5]]
  Shoppe::Product Load (0.2ms)  SELECT  "shoppe_products".* FROM "shoppe_products" WHERE "shoppe_products"."id" = ? LIMIT 1  [["id", 5]]
  Shoppe::Attachment Load (0.1ms)  SELECT  "shoppe_attachments".* FROM "shoppe_attachments" WHERE "shoppe_attachments"."parent_id" = ? AND "shoppe_attachments"."parent_type" = ? AND "shoppe_attachments"."role" = ?  ORDER BY "shoppe_attachments"."id" ASC LIMIT 1  [["parent_id", 8], ["parent_type", "Shoppe::Product"], ["role", "default_image"]]
  CACHE (0.0ms)  SELECT  "shoppe_attachments".* FROM "shoppe_attachments" WHERE "shoppe_attachments"."parent_id" = ? AND "shoppe_attachments"."parent_type" = ? AND "shoppe_attachments"."role" = ?  ORDER BY "shoppe_attachments"."id" ASC LIMIT 1  [["parent_id", 8], ["parent_type", "Shoppe::Product"], ["role", "default_image"]]
  Shoppe::Product::Translation Load (0.1ms)  SELECT "shoppe_product_translations".* FROM "shoppe_product_translations" WHERE "shoppe_product_translations"."shoppe_product_id" = ?  [["shoppe_product_id", 8]]
  Shoppe::ProductCategory::Translation Load (0.1ms)  SELECT "shoppe_product_category_translations".* FROM "shoppe_product_category_translations" WHERE "shoppe_product_category_translations"."shoppe_product_category_id" = ?  [["shoppe_product_category_id", 2]]
  Shoppe::Attachment Load (0.1ms)  SELECT  "shoppe_attachments".* FROM "shoppe_attachments" WHERE "shoppe_attachments"."parent_id" = ? AND "shoppe_attachments"."parent_type" = ? AND "shoppe_attachments"."role" = ?  ORDER BY "shoppe_attachments"."id" ASC LIMIT 1  [["parent_id", 11], ["parent_type", "Shoppe::Product"], ["role", "default_image"]]
  CACHE (0.0ms)  SELECT  "shoppe_attachments".* FROM "shoppe_attachments" WHERE "shoppe_attachments"."parent_id" = ? AND "shoppe_attachments"."parent_type" = ? AND "shoppe_attachments"."role" = ?  ORDER BY "shoppe_attachments"."id" ASC LIMIT 1  [["parent_id", 11], ["parent_type", "Shoppe::Product"], ["role", "default_image"]]
  Shoppe::Product::Translation Load (0.1ms)  SELECT "shoppe_product_translations".* FROM "shoppe_product_translations" WHERE "shoppe_product_translations"."shoppe_product_id" = ?  [["shoppe_product_id", 11]]
  Rendered shared/_product_list.html.haml (789.8ms)
  Rendered pages/home.html.haml within layouts/application (796.3ms)
  SQL (0.6ms)  SELECT "shoppe_product_categories"."id" AS t0_r0, "shoppe_product_categories"."name" AS t0_r1, "shoppe_product_categories"."permalink" AS t0_r2, "shoppe_product_categories"."description" AS t0_r3, "shoppe_product_categories"."created_at" AS t0_r4, "shoppe_product_categories"."updated_at" AS t0_r5, "shoppe_product_categories"."parent_id" AS t0_r6, "shoppe_product_categories"."lft" AS t0_r7, "shoppe_product_categories"."rgt" AS t0_r8, "shoppe_product_categories"."depth" AS t0_r9, "shoppe_product_categories"."ancestral_permalink" AS t0_r10, "shoppe_product_categories"."permalink_includes_ancestors" AS t0_r11, "shoppe_product_category_translations"."id" AS t1_r0, "shoppe_product_category_translations"."shoppe_product_category_id" AS t1_r1, "shoppe_product_category_translations"."locale" AS t1_r2, "shoppe_product_category_translations"."created_at" AS t1_r3, "shoppe_product_category_translations"."updated_at" AS t1_r4, "shoppe_product_category_translations"."name" AS t1_r5, "shoppe_product_category_translations"."permalink" AS t1_r6, "shoppe_product_category_translations"."description" AS t1_r7 FROM "shoppe_product_categories" LEFT OUTER JOIN "shoppe_product_category_translations" ON "shoppe_product_category_translations"."shoppe_product_category_id" = "shoppe_product_categories"."id"  ORDER BY shoppe_product_category_translations.name
  Rendered shared/_basket.html.haml (3.3ms)
  Rendered shared/_reasons.html.haml (2.2ms)
Completed 200 OK in 1664ms (Views: 1608.0ms | ActiveRecord: 6.4ms)



>>>>>>>>>>>>>>>>>>>
click "browse our whole catalog" in main page

Started GET "/products" for 127.0.0.1 at 2015-10-06 15:29:37 -0700
Processing by ProductsController#categories as HTML
  SQL (1.3ms)  SELECT "shoppe_product_categories"."id" AS t0_r0, "shoppe_product_categories"."name" AS t0_r1, "shoppe_product_categories"."permalink" AS t0_r2, "shoppe_product_categories"."description" AS t0_r3, "shoppe_product_categories"."created_at" AS t0_r4, "shoppe_product_categories"."updated_at" AS t0_r5, "shoppe_product_categories"."parent_id" AS t0_r6, "shoppe_product_categories"."lft" AS t0_r7, "shoppe_product_categories"."rgt" AS t0_r8, "shoppe_product_categories"."depth" AS t0_r9, "shoppe_product_categories"."ancestral_permalink" AS t0_r10, "shoppe_product_categories"."permalink_includes_ancestors" AS t0_r11, "shoppe_product_category_translations"."id" AS t1_r0, "shoppe_product_category_translations"."shoppe_product_category_id" AS t1_r1, "shoppe_product_category_translations"."locale" AS t1_r2, "shoppe_product_category_translations"."created_at" AS t1_r3, "shoppe_product_category_translations"."updated_at" AS t1_r4, "shoppe_product_category_translations"."name" AS t1_r5, "shoppe_product_category_translations"."permalink" AS t1_r6, "shoppe_product_category_translations"."description" AS t1_r7 FROM "shoppe_product_categories" LEFT OUTER JOIN "shoppe_product_category_translations" ON "shoppe_product_category_translations"."shoppe_product_category_id" = "shoppe_product_categories"."id"  ORDER BY shoppe_product_category_translations.name
  Shoppe::Attachment Load (0.2ms)  SELECT  "shoppe_attachments".* FROM "shoppe_attachments" WHERE "shoppe_attachments"."parent_id" = ? AND "shoppe_attachments"."parent_type" = ? AND "shoppe_attachments"."role" = ?  ORDER BY "shoppe_attachments"."id" ASC LIMIT 1  [["parent_id", 3], ["parent_type", "Shoppe::ProductCategory"], ["role", "image"]]
  Shoppe::Attachment Load (0.1ms)  SELECT  "shoppe_attachments".* FROM "shoppe_attachments" WHERE "shoppe_attachments"."parent_id" = ? AND "shoppe_attachments"."parent_type" = ? AND "shoppe_attachments"."role" = ?  ORDER BY "shoppe_attachments"."id" ASC LIMIT 1  [["parent_id", 2], ["parent_type", "Shoppe::ProductCategory"], ["role", "image"]]
  Shoppe::Attachment Load (0.1ms)  SELECT  "shoppe_attachments".* FROM "shoppe_attachments" WHERE "shoppe_attachments"."parent_id" = ? AND "shoppe_attachments"."parent_type" = ? AND "shoppe_attachments"."role" = ?  ORDER BY "shoppe_attachments"."id" ASC LIMIT 1  [["parent_id", 1], ["parent_type", "Shoppe::ProductCategory"], ["role", "image"]]
  Rendered products/categories.html.haml within layouts/application (26.4ms)
  Shoppe::Setting Load (0.4ms)  SELECT "shoppe_settings".* FROM "shoppe_settings"
  CACHE (0.0ms)  SELECT "shoppe_product_categories"."id" AS t0_r0, "shoppe_product_categories"."name" AS t0_r1, "shoppe_product_categories"."permalink" AS t0_r2, "shoppe_product_categories"."description" AS t0_r3, "shoppe_product_categories"."created_at" AS t0_r4, "shoppe_product_categories"."updated_at" AS t0_r5, "shoppe_product_categories"."parent_id" AS t0_r6, "shoppe_product_categories"."lft" AS t0_r7, "shoppe_product_categories"."rgt" AS t0_r8, "shoppe_product_categories"."depth" AS t0_r9, "shoppe_product_categories"."ancestral_permalink" AS t0_r10, "shoppe_product_categories"."permalink_includes_ancestors" AS t0_r11, "shoppe_product_category_translations"."id" AS t1_r0, "shoppe_product_category_translations"."shoppe_product_category_id" AS t1_r1, "shoppe_product_category_translations"."locale" AS t1_r2, "shoppe_product_category_translations"."created_at" AS t1_r3, "shoppe_product_category_translations"."updated_at" AS t1_r4, "shoppe_product_category_translations"."name" AS t1_r5, "shoppe_product_category_translations"."permalink" AS t1_r6, "shoppe_product_category_translations"."description" AS t1_r7 FROM "shoppe_product_categories" LEFT OUTER JOIN "shoppe_product_category_translations" ON "shoppe_product_category_translations"."shoppe_product_category_id" = "shoppe_product_categories"."id"  ORDER BY shoppe_product_category_translations.name
  Rendered shared/_basket.html.haml (0.2ms)
  Rendered shared/_reasons.html.haml (0.1ms)
Completed 200 OK in 95ms (Views: 90.1ms | ActiveRecord: 2.1ms)


>>>>>>>>>>>>>>>>>>>>

click "network equipment"
/product/network-eqipment

Started GET "/products/network-eqipment" for 127.0.0.1 at 2015-10-06 15:30:15 -0700
Processing by ProductsController#index as HTML
  Parameters: {"category_id"=>"network-eqipment"}
  Shoppe::ProductCategory Load (1.0ms)  SELECT  "shoppe_product_categories".* FROM "shoppe_product_categories" INNER JOIN "shoppe_product_category_translations" ON "shoppe_product_category_translations"."shoppe_product_category_id" = "shoppe_product_categories"."id" WHERE "shoppe_product_category_translations"."permalink" = 'network-eqipment' AND "shoppe_product_category_translations"."locale" = ?  ORDER BY "shoppe_product_categories"."id" ASC LIMIT 1  [["locale", "en"]]
  Shoppe::ProductCategory::Translation Load (0.4ms)  SELECT "shoppe_product_category_translations".* FROM "shoppe_product_category_translations" WHERE "shoppe_product_category_translations"."shoppe_product_category_id" IN (3)
   (0.3ms)  SELECT COUNT(*) FROM "shoppe_products" INNER JOIN "shoppe_product_categorizations" ON "shoppe_products"."id" = "shoppe_product_categorizations"."product_id" WHERE "shoppe_product_categorizations"."product_category_id" = ? AND "shoppe_products"."parent_id" IS NULL AND "shoppe_products"."active" = ?  [["product_category_id", 3], ["active", "t"]]
  Rendered products/index.html.haml within layouts/application (8.9ms)
  Shoppe::Setting Load (0.3ms)  SELECT "shoppe_settings".* FROM "shoppe_settings"
  SQL (0.5ms)  SELECT "shoppe_product_categories"."id" AS t0_r0, "shoppe_product_categories"."name" AS t0_r1, "shoppe_product_categories"."permalink" AS t0_r2, "shoppe_product_categories"."description" AS t0_r3, "shoppe_product_categories"."created_at" AS t0_r4, "shoppe_product_categories"."updated_at" AS t0_r5, "shoppe_product_categories"."parent_id" AS t0_r6, "shoppe_product_categories"."lft" AS t0_r7, "shoppe_product_categories"."rgt" AS t0_r8, "shoppe_product_categories"."depth" AS t0_r9, "shoppe_product_categories"."ancestral_permalink" AS t0_r10, "shoppe_product_categories"."permalink_includes_ancestors" AS t0_r11, "shoppe_product_category_translations"."id" AS t1_r0, "shoppe_product_category_translations"."shoppe_product_category_id" AS t1_r1, "shoppe_product_category_translations"."locale" AS t1_r2, "shoppe_product_category_translations"."created_at" AS t1_r3, "shoppe_product_category_translations"."updated_at" AS t1_r4, "shoppe_product_category_translations"."name" AS t1_r5, "shoppe_product_category_translations"."permalink" AS t1_r6, "shoppe_product_category_translations"."description" AS t1_r7 FROM "shoppe_product_categories" LEFT OUTER JOIN "shoppe_product_category_translations" ON "shoppe_product_category_translations"."shoppe_product_category_id" = "shoppe_product_categories"."id"  ORDER BY shoppe_product_category_translations.name
  Rendered shared/_basket.html.haml (0.1ms)
  Rendered shared/_reasons.html.haml (0.1ms)
Completed 200 OK in 97ms (Views: 73.8ms | ActiveRecord: 2.6ms)



>>>>>>>>>>>>>>>>>>
click "play shoppe as admin"
shoppe/login

Processing by ProductsController#categories as HTML
  SQL (1.3ms)  SELECT "shoppe_product_categories"."id" AS t0_r0, "shoppe_product_categories"."name" AS t0_r1, "shoppe_product_categories"."permalink" AS t0_r2, "shoppe_product_categories"."description" AS t0_r3, "shoppe_product_categories"."created_at" AS t0_r4, "shoppe_product_categories"."updated_at" AS t0_r5, "shoppe_product_categories"."parent_id" AS t0_r6, "shoppe_product_categories"."lft" AS t0_r7, "shoppe_product_categories"."rgt" AS t0_r8, "shoppe_product_categories"."depth" AS t0_r9, "shoppe_product_categories"."ancestral_permalink" AS t0_r10, "shoppe_product_categories"."permalink_includes_ancestors" AS t0_r11, "shoppe_product_category_translations"."id" AS t1_r0, "shoppe_product_category_translations"."shoppe_product_category_id" AS t1_r1, "shoppe_product_category_translations"."locale" AS t1_r2, "shoppe_product_category_translations"."created_at" AS t1_r3, "shoppe_product_category_translations"."updated_at" AS t1_r4, "shoppe_product_category_translations"."name" AS t1_r5, "shoppe_product_category_translations"."permalink" AS t1_r6, "shoppe_product_category_translations"."description" AS t1_r7 FROM "shoppe_product_categories" LEFT OUTER JOIN "shoppe_product_category_translations" ON "shoppe_product_category_translations"."shoppe_product_category_id" = "shoppe_product_categories"."id"  ORDER BY shoppe_product_category_translations.name
  Shoppe::Attachment Load (0.2ms)  SELECT  "shoppe_attachments".* FROM "shoppe_attachments" WHERE "shoppe_attachments"."parent_id" = ? AND "shoppe_attachments"."parent_type" = ? AND "shoppe_attachments"."role" = ?  ORDER BY "shoppe_attachments"."id" ASC LIMIT 1  [["parent_id", 3], ["parent_type", "Shoppe::ProductCategory"], ["role", "image"]]
  Shoppe::Attachment Load (0.1ms)  SELECT  "shoppe_attachments".* FROM "shoppe_attachments" WHERE "shoppe_attachments"."parent_id" = ? AND "shoppe_attachments"."parent_type" = ? AND "shoppe_attachments"."role" = ?  ORDER BY "shoppe_attachments"."id" ASC LIMIT 1  [["parent_id", 2], ["parent_type", "Shoppe::ProductCategory"], ["role", "image"]]
  Shoppe::Attachment Load (0.1ms)  SELECT  "shoppe_attachments".* FROM "shoppe_attachments" WHERE "shoppe_attachments"."parent_id" = ? AND "shoppe_attachments"."parent_type" = ? AND "shoppe_attachments"."role" = ?  ORDER BY "shoppe_attachments"."id" ASC LIMIT 1  [["parent_id", 1], ["parent_type", "Shoppe::ProductCategory"], ["role", "image"]]
  Rendered products/categories.html.haml within layouts/application (26.4ms)
  Shoppe::Setting Load (0.4ms)  SELECT "shoppe_settings".* FROM "shoppe_settings"
  CACHE (0.0ms)  SELECT "shoppe_product_categories"."id" AS t0_r0, "shoppe_product_categories"."name" AS t0_r1, "shoppe_product_categories"."permalink" AS t0_r2, "shoppe_product_categories"."description" AS t0_r3, "shoppe_product_categories"."created_at" AS t0_r4, "shoppe_product_categories"."updated_at" AS t0_r5, "shoppe_product_categories"."parent_id" AS t0_r6, "shoppe_product_categories"."lft" AS t0_r7, "shoppe_product_categories"."rgt" AS t0_r8, "shoppe_product_categories"."depth" AS t0_r9, "shoppe_product_categories"."ancestral_permalink" AS t0_r10, "shoppe_product_categories"."permalink_includes_ancestors" AS t0_r11, "shoppe_product_category_translations"."id" AS t1_r0, "shoppe_product_category_translations"."shoppe_product_category_id" AS t1_r1, "shoppe_product_category_translations"."locale" AS t1_r2, "shoppe_product_category_translations"."created_at" AS t1_r3, "shoppe_product_category_translations"."updated_at" AS t1_r4, "shoppe_product_category_translations"."name" AS t1_r5, "shoppe_product_category_translations"."permalink" AS t1_r6, "shoppe_product_category_translations"."description" AS t1_r7 FROM "shoppe_product_categories" LEFT OUTER JOIN "shoppe_product_category_translations" ON "shoppe_product_category_translations"."shoppe_product_category_id" = "shoppe_product_categories"."id"  ORDER BY shoppe_product_category_translations.name
  Rendered shared/_basket.html.haml (0.2ms)
  Rendered shared/_reasons.html.haml (0.1ms)
Completed 200 OK in 95ms (Views: 90.1ms | ActiveRecord: 2.1ms)


Started GET "/products/network-eqipment" for 127.0.0.1 at 2015-10-06 15:30:15 -0700
Processing by ProductsController#index as HTML
  Parameters: {"category_id"=>"network-eqipment"}
  Shoppe::ProductCategory Load (1.0ms)  SELECT  "shoppe_product_categories".* FROM "shoppe_product_categories" INNER JOIN "shoppe_product_category_translations" ON "shoppe_product_category_translations"."shoppe_product_category_id" = "shoppe_product_categories"."id" WHERE "shoppe_product_category_translations"."permalink" = 'network-eqipment' AND "shoppe_product_category_translations"."locale" = ?  ORDER BY "shoppe_product_categories"."id" ASC LIMIT 1  [["locale", "en"]]
  Shoppe::ProductCategory::Translation Load (0.4ms)  SELECT "shoppe_product_category_translations".* FROM "shoppe_product_category_translations" WHERE "shoppe_product_category_translations"."shoppe_product_category_id" IN (3)
   (0.3ms)  SELECT COUNT(*) FROM "shoppe_products" INNER JOIN "shoppe_product_categorizations" ON "shoppe_products"."id" = "shoppe_product_categorizations"."product_id" WHERE "shoppe_product_categorizations"."product_category_id" = ? AND "shoppe_products"."parent_id" IS NULL AND "shoppe_products"."active" = ?  [["product_category_id", 3], ["active", "t"]]
  Rendered products/index.html.haml within layouts/application (8.9ms)
  Shoppe::Setting Load (0.3ms)  SELECT "shoppe_settings".* FROM "shoppe_settings"
  SQL (0.5ms)  SELECT "shoppe_product_categories"."id" AS t0_r0, "shoppe_product_categories"."name" AS t0_r1, "shoppe_product_categories"."permalink" AS t0_r2, "shoppe_product_categories"."description" AS t0_r3, "shoppe_product_categories"."created_at" AS t0_r4, "shoppe_product_categories"."updated_at" AS t0_r5, "shoppe_product_categories"."parent_id" AS t0_r6, "shoppe_product_categories"."lft" AS t0_r7, "shoppe_product_categories"."rgt" AS t0_r8, "shoppe_product_categories"."depth" AS t0_r9, "shoppe_product_categories"."ancestral_permalink" AS t0_r10, "shoppe_product_categories"."permalink_includes_ancestors" AS t0_r11, "shoppe_product_category_translations"."id" AS t1_r0, "shoppe_product_category_translations"."shoppe_product_category_id" AS t1_r1, "shoppe_product_category_translations"."locale" AS t1_r2, "shoppe_product_category_translations"."created_at" AS t1_r3, "shoppe_product_category_translations"."updated_at" AS t1_r4, "shoppe_product_category_translations"."name" AS t1_r5, "shoppe_product_category_translations"."permalink" AS t1_r6, "shoppe_product_category_translations"."description" AS t1_r7 FROM "shoppe_product_categories" LEFT OUTER JOIN "shoppe_product_category_translations" ON "shoppe_product_category_translations"."shoppe_product_category_id" = "shoppe_product_categories"."id"  ORDER BY shoppe_product_category_translations.name
  Rendered shared/_basket.html.haml (0.1ms)
  Rendered shared/_reasons.html.haml (0.1ms)
Completed 200 OK in 97ms (Views: 73.8ms | ActiveRecord: 2.6ms)


>>>>>>>>>>>>>>>>>>>>>>>
login: admin@example.com
password: password

Started POST "/shoppe/login" for 127.0.0.1 at 2015-10-06 15:36:52 -0700
Processing by Shoppe::SessionsController#create as HTML
  Parameters: {"utf8"=>"✓", "authenticity_token"=>"Pzp6xzxH/Zg+OjV9TAo2TgPPRbvqKv/EZCkvddKaC5J6hv1MyJvzVakfapPbuMvACWz4wdHuVMcCnluGc76tQg==", "email_address"=>"admin@example.com", "password"=>"[FILTERED]", "commit"=>"Login"}
  Shoppe::User Load (0.6ms)  SELECT  "shoppe_users".* FROM "shoppe_users" WHERE "shoppe_users"."email_address" = ?  ORDER BY "shoppe_users"."id" ASC LIMIT 1  [["email_address", "admin@example.com"]]
Redirected to http://localhost:3000/shoppe/orders
Completed 302 Found in 126ms (ActiveRecord: 1.3ms)


Started GET "/shoppe/orders" for 127.0.0.1 at 2015-10-06 15:36:52 -0700
Processing by Shoppe::OrdersController#index as HTML
  Shoppe::User Load (0.8ms)  SELECT  "shoppe_users".* FROM "shoppe_users" WHERE "shoppe_users"."id" = ? LIMIT 1  [["id", 1]]
   (0.2ms)  SELECT COUNT(*) FROM "shoppe_orders" WHERE (received_at is not null)
  Rendered /usr/local/lib/ruby/gems/2.1.0/gems/shoppe-1.1.1/app/views/shoppe/orders/_search_form.html.haml (19.7ms)
   (0.2ms)  SELECT COUNT(count_column) FROM (SELECT  1 AS count_column FROM "shoppe_orders" WHERE (received_at is not null) LIMIT 25 OFFSET 0) subquery_for_count
  Rendered /usr/local/lib/ruby/gems/2.1.0/gems/shoppe-1.1.1/app/views/shoppe/orders/index.html.haml within layouts/shoppe/application (62.4ms)
  Shoppe::Setting Load (0.3ms)  SELECT "shoppe_settings".* FROM "shoppe_settings"
Completed 200 OK in 681ms (Views: 623.4ms | ActiveRecord: 2.0ms)

>>>>>>>>>>>>>
click "new order"

Started GET "/shoppe/orders/new" for 127.0.0.1 at 2015-10-06 15:37:31 -0700
Processing by Shoppe::OrdersController#new as HTML
  Shoppe::User Load (0.4ms)  SELECT  "shoppe_users".* FROM "shoppe_users" WHERE "shoppe_users"."id" = ? LIMIT 1  [["id", 1]]
  Shoppe::Customer Load (0.2ms)  SELECT "shoppe_customers".* FROM "shoppe_customers"  ORDER BY "shoppe_customers"."id" DESC
  Shoppe::Country Load (1.6ms)  SELECT "shoppe_countries".* FROM "shoppe_countries"  ORDER BY "shoppe_countries"."name" ASC
  CACHE (0.0ms)  SELECT "shoppe_countries".* FROM "shoppe_countries"  ORDER BY "shoppe_countries"."name" ASC
  Rendered /usr/local/lib/ruby/gems/2.1.0/gems/shoppe-1.1.1/app/views/shoppe/orders/_form.html.haml (96.6ms)
  SQL (0.5ms)  SELECT "shoppe_products"."id" AS t0_r0, "shoppe_products"."parent_id" AS t0_r1, "shoppe_products"."name" AS t0_r2, "shoppe_products"."sku" AS t0_r3, "shoppe_products"."permalink" AS t0_r4, "shoppe_products"."description" AS t0_r5, "shoppe_products"."short_description" AS t0_r6, "shoppe_products"."active" AS t0_r7, "shoppe_products"."weight" AS t0_r8, "shoppe_products"."price" AS t0_r9, "shoppe_products"."cost_price" AS t0_r10, "shoppe_products"."tax_rate_id" AS t0_r11, "shoppe_products"."created_at" AS t0_r12, "shoppe_products"."updated_at" AS t0_r13, "shoppe_products"."featured" AS t0_r14, "shoppe_products"."in_the_box" AS t0_r15, "shoppe_products"."stock_control" AS t0_r16, "shoppe_products"."default" AS t0_r17, "shoppe_product_translations"."id" AS t1_r0, "shoppe_product_translations"."shoppe_product_id" AS t1_r1, "shoppe_product_translations"."locale" AS t1_r2, "shoppe_product_translations"."created_at" AS t1_r3, "shoppe_product_translations"."updated_at" AS t1_r4, "shoppe_product_translations"."name" AS t1_r5, "shoppe_product_translations"."permalink" AS t1_r6, "shoppe_product_translations"."description" AS t1_r7, "shoppe_product_translations"."short_description" AS t1_r8 FROM "shoppe_products" LEFT OUTER JOIN "shoppe_product_translations" ON "shoppe_product_translations"."shoppe_product_id" = "shoppe_products"."id"  ORDER BY shoppe_product_translations.name
  Shoppe::Product Load (0.1ms)  SELECT  "shoppe_products".* FROM "shoppe_products" WHERE "shoppe_products"."id" = ? LIMIT 1  [["id", 5]]
  Shoppe::Product::Translation Load (0.1ms)  SELECT "shoppe_product_translations".* FROM "shoppe_product_translations" WHERE "shoppe_product_translations"."shoppe_product_id" = ?  [["shoppe_product_id", 5]]
  CACHE (0.0ms)  SELECT  "shoppe_products".* FROM "shoppe_products" WHERE "shoppe_products"."id" = ? LIMIT 1  [["id", 5]]
  CACHE (0.0ms)  SELECT "shoppe_product_translations".* FROM "shoppe_product_translations" WHERE "shoppe_product_translations"."shoppe_product_id" = ?  [["shoppe_product_id", 5]]
  Rendered /usr/local/lib/ruby/gems/2.1.0/gems/shoppe-1.1.1/app/views/shoppe/orders/_order_items_form.html.haml (32.7ms)
  Rendered /usr/local/lib/ruby/gems/2.1.0/gems/shoppe-1.1.1/app/views/shoppe/orders/new.html.haml within layouts/shoppe/application (142.8ms)
  Shoppe::Setting Load (0.1ms)  SELECT "shoppe_settings".* FROM "shoppe_settings"
Completed 200 OK in 316ms (Views: 197.3ms | ActiveRecord: 5.3ms)


>>>>>>>>>>>>>>>>>>>
click "Customers"

Started GET "/shoppe/customers" for 127.0.0.1 at 2015-10-06 15:39:57 -0700
Processing by Shoppe::CustomersController#index as HTML
  Shoppe::User Load (0.3ms)  SELECT  "shoppe_users".* FROM "shoppe_users" WHERE "shoppe_users"."id" = ? LIMIT 1  [["id", 1]]
  Rendered /usr/local/lib/ruby/gems/2.1.0/gems/shoppe-1.1.1/app/views/shoppe/customers/_search_form.html.haml (8.8ms)
   (0.3ms)  SELECT COUNT(count_column) FROM (SELECT  1 AS count_column FROM "shoppe_customers" LIMIT 25 OFFSET 0) subquery_for_count
   (0.1ms)  SELECT COUNT(*) FROM "shoppe_customers"
  Rendered /usr/local/lib/ruby/gems/2.1.0/gems/shoppe-1.1.1/app/views/shoppe/customers/index.html.haml within layouts/shoppe/application (33.4ms)
  Shoppe::Setting Load (0.1ms)  SELECT "shoppe_settings".* FROM "shoppe_settings"
Completed 200 OK in 116ms (Views: 108.3ms | ActiveRecord: 0.9ms)


>>>>>>>>>>>>>>>
customer:
add an item to basket

Started POST "/products/voip-phones/yealink-t20p/buy" for 127.0.0.1 at 2015-10-06 15:41:16 -0700
Processing by ProductsController#add_to_basket as HTML
  Parameters: {"utf8"=>"✓", "authenticity_token"=>"CdJbUTmz6xtmWee4KMk74M6GGkOY+aHCrSbWUj2YFyVMbtzazW/l1vF8uFa/e8ZuxCWnOaM9CsHLkaKhnLyx9Q==", "quantity"=>"1", "commit"=>"Add to basket", "category_id"=>"voip-phones", "product_id"=>"yealink-t20p"}
  Shoppe::ProductCategory Load (0.4ms)  SELECT  "shoppe_product_categories".* FROM "shoppe_product_categories" INNER JOIN "shoppe_product_category_translations" ON "shoppe_product_category_translations"."shoppe_product_category_id" = "shoppe_product_categories"."id" WHERE "shoppe_product_category_translations"."permalink" = 'voip-phones' AND "shoppe_product_category_translations"."locale" = ?  ORDER BY "shoppe_product_categories"."id" ASC LIMIT 1  [["locale", "en"]]
  Shoppe::ProductCategory::Translation Load (0.5ms)  SELECT "shoppe_product_category_translations".* FROM "shoppe_product_category_translations" WHERE "shoppe_product_category_translations"."shoppe_product_category_id" IN (1)
  Shoppe::Product Load (0.6ms)  SELECT  "shoppe_products".* FROM "shoppe_products" INNER JOIN "shoppe_product_translations" ON "shoppe_product_translations"."shoppe_product_id" = "shoppe_products"."id" INNER JOIN "shoppe_product_categorizations" ON "shoppe_products"."id" = "shoppe_product_categorizations"."product_id" WHERE "shoppe_product_categorizations"."product_category_id" = ? AND "shoppe_product_translations"."permalink" = 'yealink-t20p' AND "shoppe_product_translations"."locale" = ? AND "shoppe_products"."active" = ?  ORDER BY "shoppe_products"."id" ASC LIMIT 1  [["product_category_id", 1], ["locale", "en"], ["active", "t"]]
  Shoppe::Product::Translation Load (0.4ms)  SELECT "shoppe_product_translations".* FROM "shoppe_product_translations" WHERE "shoppe_product_translations"."shoppe_product_id" IN (1)
  Shoppe::Country Load (0.4ms)  SELECT  "shoppe_countries".* FROM "shoppe_countries" WHERE "shoppe_countries"."name" = ?  ORDER BY "shoppe_countries"."id" ASC LIMIT 1  [["name", "United Kingdom"]]
   (0.2ms)  begin transaction
  SQL (0.7ms)  INSERT INTO "shoppe_orders" ("ip_address", "billing_country_id", "status", "token", "created_at", "updated_at") VALUES (?, ?, ?, ?, ?, ?)  [["ip_address", "127.0.0.1"], ["billing_country_id", 77], ["status", "building"], ["token", "2cea1591-4669-49c2-b8fe-653682d86358"], ["created_at", "2015-10-06 22:41:16.392254"], ["updated_at", "2015-10-06 22:41:16.392254"]]
  Nifty::KeyValueStore::KeyValuePair Load (0.3ms)  SELECT "nifty_key_value_store".* FROM "nifty_key_value_store" WHERE "nifty_key_value_store"."parent_id" = ? AND "nifty_key_value_store"."parent_type" = ? AND "nifty_key_value_store"."group" = ?  [["parent_id", 1], ["parent_type", "Shoppe::Order"], ["group", "properties"]]
  CACHE (0.0ms)  SELECT "nifty_key_value_store".* FROM "nifty_key_value_store" WHERE "nifty_key_value_store"."parent_id" = ? AND "nifty_key_value_store"."parent_type" = ? AND "nifty_key_value_store"."group" = ?  [["parent_id", 1], ["parent_type", "Shoppe::Order"], ["group", :properties]]
   (1.9ms)  commit transaction
  Shoppe::Product Exists (0.3ms)  SELECT  1 AS one FROM "shoppe_products" WHERE "shoppe_products"."parent_id" = ? LIMIT 1  [["parent_id", 1]]
   (0.4ms)  begin transaction
  Shoppe::OrderItem Load (0.5ms)  SELECT  "shoppe_order_items".* FROM "shoppe_order_items" WHERE "shoppe_order_items"."order_id" = ? AND "shoppe_order_items"."ordered_item_id" = ? AND "shoppe_order_items"."ordered_item_type" = ?  ORDER BY "shoppe_order_items"."id" ASC LIMIT 1  [["order_id", 1], ["ordered_item_id", 1], ["ordered_item_type", "Shoppe::Product"]]
   (0.1ms)  SELECT SUM("shoppe_stock_level_adjustments"."adjustment") FROM "shoppe_stock_level_adjustments" WHERE "shoppe_stock_level_adjustments"."item_id" = ? AND "shoppe_stock_level_adjustments"."item_type" = ?  [["item_id", 1], ["item_type", "Shoppe::Product"]]
  Shoppe::Order Load (0.7ms)  SELECT  "shoppe_orders".* FROM "shoppe_orders" WHERE "shoppe_orders"."id" = ? LIMIT 1  [["id", 1]]
  SQL (0.5ms)  INSERT INTO "shoppe_order_items" ("order_id", "ordered_item_id", "ordered_item_type", "quantity", "created_at", "updated_at") VALUES (?, ?, ?, ?, ?, ?)  [["order_id", 1], ["ordered_item_id", 1], ["ordered_item_type", "Shoppe::Product"], ["quantity", 0], ["created_at", "2015-10-06 22:41:16.425661"], ["updated_at", "2015-10-06 22:41:16.425661"]]
  SQL (0.2ms)  UPDATE "shoppe_orders" SET "updated_at" = '2015-10-06 22:41:16.428942' WHERE "shoppe_orders"."id" = ?  [["id", 1]]
   (0.2ms)  SELECT SUM("shoppe_stock_level_adjustments"."adjustment") FROM "shoppe_stock_level_adjustments" WHERE "shoppe_stock_level_adjustments"."item_id" = ? AND "shoppe_stock_level_adjustments"."item_type" = ?  [["item_id", 1], ["item_type", "Shoppe::Product"]]
   (0.3ms)  SELECT SUM("shoppe_stock_level_adjustments"."adjustment") FROM "shoppe_stock_level_adjustments" WHERE "shoppe_stock_level_adjustments"."parent_id" = ? AND "shoppe_stock_level_adjustments"."parent_type" = ?  [["parent_id", 1], ["parent_type", "Shoppe::OrderItem"]]
  CACHE (0.0ms)  SELECT SUM("shoppe_stock_level_adjustments"."adjustment") FROM "shoppe_stock_level_adjustments" WHERE "shoppe_stock_level_adjustments"."item_id" = ? AND "shoppe_stock_level_adjustments"."item_type" = ?  [["item_id", 1], ["item_type", "Shoppe::Product"]]
  CACHE (0.0ms)  SELECT SUM("shoppe_stock_level_adjustments"."adjustment") FROM "shoppe_stock_level_adjustments" WHERE "shoppe_stock_level_adjustments"."parent_id" = ? AND "shoppe_stock_level_adjustments"."parent_type" = ?  [["parent_id", 1], ["parent_type", "Shoppe::OrderItem"]]
  SQL (0.4ms)  UPDATE "shoppe_order_items" SET "quantity" = ?, "updated_at" = ? WHERE "shoppe_order_items"."id" = ?  [["quantity", 1], ["updated_at", "2015-10-06 22:41:16.437080"], ["id", 1]]
  SQL (0.3ms)  UPDATE "shoppe_orders" SET "updated_at" = '2015-10-06 22:41:16.443092' WHERE "shoppe_orders"."id" = ?  [["id", 1]]
  Shoppe::OrderItem Load (0.3ms)  SELECT "shoppe_order_items".* FROM "shoppe_order_items" WHERE "shoppe_order_items"."order_id" = ?  [["order_id", 1]]
  Shoppe::Product Load (0.1ms)  SELECT  "shoppe_products".* FROM "shoppe_products" WHERE "shoppe_products"."id" = ? LIMIT 1  [["id", 1]]
  Shoppe::DeliveryServicePrice Load (0.4ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  Shoppe::DeliveryService Load (0.2ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  Shoppe::DeliveryService Load (0.1ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
   (0.8ms)  commit transaction
Redirected to http://localhost:3000/products/voip-phones/yealink-t20p
Completed 302 Found in 141ms (ActiveRecord: 12.5ms)


Started GET "/products/voip-phones/yealink-t20p" for 127.0.0.1 at 2015-10-06 15:41:16 -0700
Processing by ProductsController#show as HTML
  Parameters: {"category_id"=>"voip-phones", "product_id"=>"yealink-t20p"}
  Shoppe::ProductCategory Load (0.3ms)  SELECT  "shoppe_product_categories".* FROM "shoppe_product_categories" INNER JOIN "shoppe_product_category_translations" ON "shoppe_product_category_translations"."shoppe_product_category_id" = "shoppe_product_categories"."id" WHERE "shoppe_product_category_translations"."permalink" = 'voip-phones' AND "shoppe_product_category_translations"."locale" = ?  ORDER BY "shoppe_product_categories"."id" ASC LIMIT 1  [["locale", "en"]]
  Shoppe::ProductCategory::Translation Load (0.2ms)  SELECT "shoppe_product_category_translations".* FROM "shoppe_product_category_translations" WHERE "shoppe_product_category_translations"."shoppe_product_category_id" IN (1)
  Shoppe::Product Load (0.2ms)  SELECT  "shoppe_products".* FROM "shoppe_products" INNER JOIN "shoppe_product_translations" ON "shoppe_product_translations"."shoppe_product_id" = "shoppe_products"."id" INNER JOIN "shoppe_product_categorizations" ON "shoppe_products"."id" = "shoppe_product_categorizations"."product_id" WHERE "shoppe_product_categorizations"."product_category_id" = ? AND "shoppe_product_translations"."permalink" = 'yealink-t20p' AND "shoppe_product_translations"."locale" = ? AND "shoppe_products"."active" = ?  ORDER BY "shoppe_products"."id" ASC LIMIT 1  [["product_category_id", 1], ["locale", "en"], ["active", "t"]]
  Shoppe::Product::Translation Load (0.2ms)  SELECT "shoppe_product_translations".* FROM "shoppe_product_translations" WHERE "shoppe_product_translations"."shoppe_product_id" IN (1)
DEPRECATION WARNING: The use of Shoppe::ProductAttribute.public is deprecated. use Shoppe::ProductAttribute.publicly_accessible. (called from show at /home/congy/ruby_source/shoppe-example/app/controllers/products_controller.rb:25)
  Shoppe::ProductAttribute Load (0.2ms)  SELECT "shoppe_product_attributes".* FROM "shoppe_product_attributes" WHERE "shoppe_product_attributes"."product_id" = ? AND "shoppe_product_attributes"."public" = ?  ORDER BY "shoppe_product_attributes"."position" ASC  [["product_id", 1], ["public", "t"]]
  Shoppe::ProductCategory Load (0.1ms)  SELECT  "shoppe_product_categories".* FROM "shoppe_product_categories" INNER JOIN "shoppe_product_categorizations" ON "shoppe_product_categories"."id" = "shoppe_product_categorizations"."product_category_id" WHERE "shoppe_product_categorizations"."product_id" = ?  ORDER BY "shoppe_product_categories"."id" ASC LIMIT 1  [["product_id", 1]]
  Shoppe::ProductCategory::Translation Load (0.1ms)  SELECT "shoppe_product_category_translations".* FROM "shoppe_product_category_translations" WHERE "shoppe_product_category_translations"."shoppe_product_category_id" = ?  [["shoppe_product_category_id", 1]]
  Shoppe::Attachment Load (0.1ms)  SELECT  "shoppe_attachments".* FROM "shoppe_attachments" WHERE "shoppe_attachments"."parent_id" = ? AND "shoppe_attachments"."parent_type" = ? AND "shoppe_attachments"."role" = ?  ORDER BY "shoppe_attachments"."id" ASC LIMIT 1  [["parent_id", 1], ["parent_type", "Shoppe::Product"], ["role", "default_image"]]
  CACHE (0.0ms)  SELECT  "shoppe_attachments".* FROM "shoppe_attachments" WHERE "shoppe_attachments"."parent_id" = ? AND "shoppe_attachments"."parent_type" = ? AND "shoppe_attachments"."role" = ?  ORDER BY "shoppe_attachments"."id" ASC LIMIT 1  [["parent_id", 1], ["parent_type", "Shoppe::Product"], ["role", "default_image"]]
  Shoppe::Product Exists (0.1ms)  SELECT  1 AS one FROM "shoppe_products" WHERE "shoppe_products"."parent_id" = ? LIMIT 1  [["parent_id", 1]]
  Shoppe::Product Load (0.1ms)  SELECT "shoppe_products".* FROM "shoppe_products" WHERE "shoppe_products"."parent_id" = ?  [["parent_id", 1]]
  Shoppe::Setting Load (0.2ms)  SELECT "shoppe_settings".* FROM "shoppe_settings"
  CACHE (0.0ms)  SELECT  "shoppe_product_categories".* FROM "shoppe_product_categories" INNER JOIN "shoppe_product_categorizations" ON "shoppe_product_categories"."id" = "shoppe_product_categorizations"."product_category_id" WHERE "shoppe_product_categorizations"."product_id" = ?  ORDER BY "shoppe_product_categories"."id" ASC LIMIT 1  [["product_id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_product_category_translations".* FROM "shoppe_product_category_translations" WHERE "shoppe_product_category_translations"."shoppe_product_category_id" = ?  [["shoppe_product_category_id", 1]]
   (0.1ms)  SELECT SUM("shoppe_stock_level_adjustments"."adjustment") FROM "shoppe_stock_level_adjustments" WHERE "shoppe_stock_level_adjustments"."item_id" = ? AND "shoppe_stock_level_adjustments"."item_type" = ?  [["item_id", 1], ["item_type", "Shoppe::Product"]]
  CACHE (0.0ms)  SELECT SUM("shoppe_stock_level_adjustments"."adjustment") FROM "shoppe_stock_level_adjustments" WHERE "shoppe_stock_level_adjustments"."item_id" = ? AND "shoppe_stock_level_adjustments"."item_type" = ?  [["item_id", 1], ["item_type", "Shoppe::Product"]]
  CACHE (0.0ms)  SELECT SUM("shoppe_stock_level_adjustments"."adjustment") FROM "shoppe_stock_level_adjustments" WHERE "shoppe_stock_level_adjustments"."item_id" = ? AND "shoppe_stock_level_adjustments"."item_type" = ?  [["item_id", 1], ["item_type", "Shoppe::Product"]]
  CACHE (0.0ms)  SELECT SUM("shoppe_stock_level_adjustments"."adjustment") FROM "shoppe_stock_level_adjustments" WHERE "shoppe_stock_level_adjustments"."item_id" = ? AND "shoppe_stock_level_adjustments"."item_type" = ?  [["item_id", 1], ["item_type", "Shoppe::Product"]]
  Shoppe::Attachment Load (0.1ms)  SELECT  "shoppe_attachments".* FROM "shoppe_attachments" WHERE "shoppe_attachments"."parent_id" = ? AND "shoppe_attachments"."parent_type" = ? AND "shoppe_attachments"."role" = ?  ORDER BY "shoppe_attachments"."id" ASC LIMIT 1  [["parent_id", 1], ["parent_type", "Shoppe::Product"], ["role", "data_sheet"]]
  Rendered products/show.html.haml within layouts/application (22.4ms)
  SQL (0.3ms)  SELECT "shoppe_product_categories"."id" AS t0_r0, "shoppe_product_categories"."name" AS t0_r1, "shoppe_product_categories"."permalink" AS t0_r2, "shoppe_product_categories"."description" AS t0_r3, "shoppe_product_categories"."created_at" AS t0_r4, "shoppe_product_categories"."updated_at" AS t0_r5, "shoppe_product_categories"."parent_id" AS t0_r6, "shoppe_product_categories"."lft" AS t0_r7, "shoppe_product_categories"."rgt" AS t0_r8, "shoppe_product_categories"."depth" AS t0_r9, "shoppe_product_categories"."ancestral_permalink" AS t0_r10, "shoppe_product_categories"."permalink_includes_ancestors" AS t0_r11, "shoppe_product_category_translations"."id" AS t1_r0, "shoppe_product_category_translations"."shoppe_product_category_id" AS t1_r1, "shoppe_product_category_translations"."locale" AS t1_r2, "shoppe_product_category_translations"."created_at" AS t1_r3, "shoppe_product_category_translations"."updated_at" AS t1_r4, "shoppe_product_category_translations"."name" AS t1_r5, "shoppe_product_category_translations"."permalink" AS t1_r6, "shoppe_product_category_translations"."description" AS t1_r7 FROM "shoppe_product_categories" LEFT OUTER JOIN "shoppe_product_category_translations" ON "shoppe_product_category_translations"."shoppe_product_category_id" = "shoppe_product_categories"."id"  ORDER BY shoppe_product_category_translations.name
  Shoppe::Order Load (0.1ms)  SELECT  "shoppe_orders".* FROM "shoppe_orders" WHERE "shoppe_orders"."id" = ? LIMIT 1  [["id", 1]]
  Shoppe::OrderItem Load (0.2ms)  SELECT "shoppe_order_items".* FROM "shoppe_order_items" WHERE "shoppe_order_items"."order_id" IN (1)
  Shoppe::Product Load (0.2ms)  SELECT "shoppe_products".* FROM "shoppe_products" WHERE "shoppe_products"."id" IN (1)
  Shoppe::DeliveryServicePrice Load (0.2ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  Shoppe::DeliveryService Load (0.1ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  Shoppe::DeliveryService Load (0.1ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  Shoppe::DeliveryServicePrice Load (0.2ms)  SELECT  "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" WHERE "shoppe_delivery_service_prices"."delivery_service_id" = ? AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."id" ASC LIMIT 1  [["delivery_service_id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_products".* FROM "shoppe_products" WHERE "shoppe_products"."parent_id" = ?  [["parent_id", 1]]
  Rendered shared/_basket.html.haml (14.3ms)
  Rendered shared/_reasons.html.haml (0.1ms)
Completed 200 OK in 93ms (Views: 79.1ms | ActiveRecord: 3.5ms)

>>>>>>>>>>>>>>>>>>>
customer: view basket

Started GET "/basket" for 127.0.0.1 at 2015-10-06 15:42:02 -0700
Processing by OrdersController#show as HTML
  Shoppe::Order Load (0.4ms)  SELECT  "shoppe_orders".* FROM "shoppe_orders" WHERE "shoppe_orders"."id" = ? LIMIT 1  [["id", 1]]
  Shoppe::OrderItem Load (0.5ms)  SELECT "shoppe_order_items".* FROM "shoppe_order_items" WHERE "shoppe_order_items"."order_id" IN (1)
  Shoppe::Product Load (0.4ms)  SELECT "shoppe_products".* FROM "shoppe_products" WHERE "shoppe_products"."id" IN (1)
  Shoppe::Setting Load (0.2ms)  SELECT "shoppe_settings".* FROM "shoppe_settings"
  Shoppe::Product::Translation Load (0.1ms)  SELECT "shoppe_product_translations".* FROM "shoppe_product_translations" WHERE "shoppe_product_translations"."shoppe_product_id" = ?  [["shoppe_product_id", 1]]
  Shoppe::Product Load (0.1ms)  SELECT "shoppe_products".* FROM "shoppe_products" WHERE "shoppe_products"."parent_id" = ?  [["parent_id", 1]]
  Shoppe::TaxRate Load (0.2ms)  SELECT  "shoppe_tax_rates".* FROM "shoppe_tax_rates" WHERE "shoppe_tax_rates"."id" = ? LIMIT 1  [["id", 1]]
  Shoppe::DeliveryServicePrice Load (0.4ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  Shoppe::DeliveryService Load (0.1ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  Shoppe::DeliveryService Load (0.1ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  Shoppe::DeliveryServicePrice Load (0.1ms)  SELECT  "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" WHERE "shoppe_delivery_service_prices"."delivery_service_id" = ? AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."id" ASC LIMIT 1  [["delivery_service_id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" WHERE "shoppe_delivery_service_prices"."delivery_service_id" = ? AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."id" ASC LIMIT 1  [["delivery_service_id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" WHERE "shoppe_delivery_service_prices"."delivery_service_id" = ? AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."id" ASC LIMIT 1  [["delivery_service_id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" WHERE "shoppe_delivery_service_prices"."delivery_service_id" = ? AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."id" ASC LIMIT 1  [["delivery_service_id", 1]]
  CACHE (0.0ms)  SELECT  "shoppe_tax_rates".* FROM "shoppe_tax_rates" WHERE "shoppe_tax_rates"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" WHERE "shoppe_delivery_service_prices"."delivery_service_id" = ? AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."id" ASC LIMIT 1  [["delivery_service_id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" WHERE "shoppe_delivery_service_prices"."delivery_service_id" = ? AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."id" ASC LIMIT 1  [["delivery_service_id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" WHERE "shoppe_delivery_service_prices"."delivery_service_id" = ? AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."id" ASC LIMIT 1  [["delivery_service_id", 1]]
  CACHE (0.0ms)  SELECT  "shoppe_tax_rates".* FROM "shoppe_tax_rates" WHERE "shoppe_tax_rates"."id" = ? LIMIT 1  [["id", 1]]
  Rendered shared/_order_items.html.haml (106.8ms)
  Rendered orders/show.html.haml within layouts/application (111.4ms)
  SQL (0.3ms)  SELECT "shoppe_product_categories"."id" AS t0_r0, "shoppe_product_categories"."name" AS t0_r1, "shoppe_product_categories"."permalink" AS t0_r2, "shoppe_product_categories"."description" AS t0_r3, "shoppe_product_categories"."created_at" AS t0_r4, "shoppe_product_categories"."updated_at" AS t0_r5, "shoppe_product_categories"."parent_id" AS t0_r6, "shoppe_product_categories"."lft" AS t0_r7, "shoppe_product_categories"."rgt" AS t0_r8, "shoppe_product_categories"."depth" AS t0_r9, "shoppe_product_categories"."ancestral_permalink" AS t0_r10, "shoppe_product_categories"."permalink_includes_ancestors" AS t0_r11, "shoppe_product_category_translations"."id" AS t1_r0, "shoppe_product_category_translations"."shoppe_product_category_id" AS t1_r1, "shoppe_product_category_translations"."locale" AS t1_r2, "shoppe_product_category_translations"."created_at" AS t1_r3, "shoppe_product_category_translations"."updated_at" AS t1_r4, "shoppe_product_category_translations"."name" AS t1_r5, "shoppe_product_category_translations"."permalink" AS t1_r6, "shoppe_product_category_translations"."description" AS t1_r7 FROM "shoppe_product_categories" LEFT OUTER JOIN "shoppe_product_category_translations" ON "shoppe_product_category_translations"."shoppe_product_category_id" = "shoppe_product_categories"."id"  ORDER BY shoppe_product_category_translations.name
  CACHE (0.0ms)  SELECT  "shoppe_orders".* FROM "shoppe_orders" WHERE "shoppe_orders"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_order_items".* FROM "shoppe_order_items" WHERE "shoppe_order_items"."order_id" IN (1)
  CACHE (0.0ms)  SELECT "shoppe_products".* FROM "shoppe_products" WHERE "shoppe_products"."id" IN (1)
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" WHERE "shoppe_delivery_service_prices"."delivery_service_id" = ? AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."id" ASC LIMIT 1  [["delivery_service_id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_products".* FROM "shoppe_products" WHERE "shoppe_products"."parent_id" = ?  [["parent_id", 1]]
  Rendered shared/_basket.html.haml (9.9ms)
  Rendered shared/_reasons.html.haml (0.1ms)
Completed 200 OK in 194ms (Views: 179.4ms | ActiveRecord: 4.5ms)


>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
customer:
click checkout

Started GET "/checkout" for 127.0.0.1 at 2015-10-06 15:42:40 -0700
Processing by OrdersController#checkout as HTML
  Shoppe::Order Load (0.4ms)  SELECT  "shoppe_orders".* FROM "shoppe_orders" WHERE "shoppe_orders"."id" = ? LIMIT 1  [["id", 1]]
  Shoppe::OrderItem Load (1.0ms)  SELECT "shoppe_order_items".* FROM "shoppe_order_items" WHERE "shoppe_order_items"."order_id" IN (1)
  Shoppe::Product Load (0.7ms)  SELECT "shoppe_products".* FROM "shoppe_products" WHERE "shoppe_products"."id" IN (1)
  CACHE (0.0ms)  SELECT  "shoppe_orders".* FROM "shoppe_orders" WHERE "shoppe_orders"."id" = ? LIMIT 1  [["id", 1]]
  Rendered orders/_checkout_sidebar.html.haml (2.8ms)
  Shoppe::Setting Load (0.2ms)  SELECT "shoppe_settings".* FROM "shoppe_settings"
  Shoppe::OrderItem Load (0.2ms)  SELECT "shoppe_order_items".* FROM "shoppe_order_items" WHERE "shoppe_order_items"."order_id" = ?  [["order_id", 1]]
  Shoppe::Product Load (0.1ms)  SELECT  "shoppe_products".* FROM "shoppe_products" WHERE "shoppe_products"."id" = ? LIMIT 1  [["id", 1]]
  Shoppe::Product::Translation Load (0.1ms)  SELECT "shoppe_product_translations".* FROM "shoppe_product_translations" WHERE "shoppe_product_translations"."shoppe_product_id" = ?  [["shoppe_product_id", 1]]
  Shoppe::Product Load (0.1ms)  SELECT "shoppe_products".* FROM "shoppe_products" WHERE "shoppe_products"."parent_id" = ?  [["parent_id", 1]]
  Shoppe::TaxRate Load (0.1ms)  SELECT  "shoppe_tax_rates".* FROM "shoppe_tax_rates" WHERE "shoppe_tax_rates"."id" = ? LIMIT 1  [["id", 1]]
  Shoppe::DeliveryServicePrice Load (0.5ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  Shoppe::DeliveryService Load (0.1ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  Shoppe::DeliveryService Load (0.1ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  Shoppe::DeliveryServicePrice Load (0.1ms)  SELECT  "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" WHERE "shoppe_delivery_service_prices"."delivery_service_id" = ? AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."id" ASC LIMIT 1  [["delivery_service_id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.1ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" WHERE "shoppe_delivery_service_prices"."delivery_service_id" = ? AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."id" ASC LIMIT 1  [["delivery_service_id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" WHERE "shoppe_delivery_service_prices"."delivery_service_id" = ? AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."id" ASC LIMIT 1  [["delivery_service_id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" WHERE "shoppe_delivery_service_prices"."delivery_service_id" = ? AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."id" ASC LIMIT 1  [["delivery_service_id", 1]]
  CACHE (0.0ms)  SELECT  "shoppe_tax_rates".* FROM "shoppe_tax_rates" WHERE "shoppe_tax_rates"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.1ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" WHERE "shoppe_delivery_service_prices"."delivery_service_id" = ? AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."id" ASC LIMIT 1  [["delivery_service_id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" WHERE "shoppe_delivery_service_prices"."delivery_service_id" = ? AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."id" ASC LIMIT 1  [["delivery_service_id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" WHERE "shoppe_delivery_service_prices"."delivery_service_id" = ? AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."id" ASC LIMIT 1  [["delivery_service_id", 1]]
  CACHE (0.0ms)  SELECT  "shoppe_tax_rates".* FROM "shoppe_tax_rates" WHERE "shoppe_tax_rates"."id" = ? LIMIT 1  [["id", 1]]
  Rendered shared/_order_items.html.haml (79.5ms)
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  Shoppe::Country Load (2.0ms)  SELECT "shoppe_countries".* FROM "shoppe_countries"  ORDER BY "shoppe_countries"."name" ASC
  CACHE (0.0ms)  SELECT "shoppe_countries".* FROM "shoppe_countries"  ORDER BY "shoppe_countries"."name" ASC
  Rendered orders/checkout.html.haml within layouts/application (137.0ms)
  SQL (0.3ms)  SELECT "shoppe_product_categories"."id" AS t0_r0, "shoppe_product_categories"."name" AS t0_r1, "shoppe_product_categories"."permalink" AS t0_r2, "shoppe_product_categories"."description" AS t0_r3, "shoppe_product_categories"."created_at" AS t0_r4, "shoppe_product_categories"."updated_at" AS t0_r5, "shoppe_product_categories"."parent_id" AS t0_r6, "shoppe_product_categories"."lft" AS t0_r7, "shoppe_product_categories"."rgt" AS t0_r8, "shoppe_product_categories"."depth" AS t0_r9, "shoppe_product_categories"."ancestral_permalink" AS t0_r10, "shoppe_product_categories"."permalink_includes_ancestors" AS t0_r11, "shoppe_product_category_translations"."id" AS t1_r0, "shoppe_product_category_translations"."shoppe_product_category_id" AS t1_r1, "shoppe_product_category_translations"."locale" AS t1_r2, "shoppe_product_category_translations"."created_at" AS t1_r3, "shoppe_product_category_translations"."updated_at" AS t1_r4, "shoppe_product_category_translations"."name" AS t1_r5, "shoppe_product_category_translations"."permalink" AS t1_r6, "shoppe_product_category_translations"."description" AS t1_r7 FROM "shoppe_product_categories" LEFT OUTER JOIN "shoppe_product_category_translations" ON "shoppe_product_category_translations"."shoppe_product_category_id" = "shoppe_product_categories"."id"  ORDER BY shoppe_product_category_translations.name
Completed 200 OK in 197ms (Views: 170.8ms | ActiveRecord: 7.2ms)


>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
customer:
continue payment


Started PATCH "/checkout" for 127.0.0.1 at 2015-10-06 15:43:14 -0700
Processing by OrdersController#checkout as HTML
  Parameters: {"utf8"=>"✓", "authenticity_token"=>"mdI9WfRb0uNi9yTDNUpnLZ7HOoDZ8H1qPiRM2fMp71/cbrrSAIfcLvXSey2i+JqjlGSH+uI01mlYkzgqUg1Jjw==", "order"=>{"first_name"=>"Maritza", "last_name"=>"Rath", "company"=>"Stiedemann, Kuvalis and Treutel", "email_address"=>"ludwig@rutherford.biz", "phone_number"=>"016977 8317", "billing_address1"=>"7913 McKenzie Bypass", "billing_address3"=>"Pollichton", "billing_address4"=>"Netherlands Antilles", "billing_postcode"=>"WT06 2HJ", "billing_country_id"=>"77", "separate_delivery_address"=>"0", "delivery_name"=>"Maritza Rath (Stiedemann, Kuvalis and Treutel)", "delivery_address1"=>"7913 McKenzie Bypass", "delivery_address3"=>"Pollichton", "delivery_address4"=>"Netherlands Antilles", "delivery_postcode"=>"WT06 2HJ", "delivery_country_id"=>"3"}}
  Shoppe::Order Load (0.4ms)  SELECT  "shoppe_orders".* FROM "shoppe_orders" WHERE "shoppe_orders"."id" = ? LIMIT 1  [["id", 1]]
  Shoppe::OrderItem Load (0.6ms)  SELECT "shoppe_order_items".* FROM "shoppe_order_items" WHERE "shoppe_order_items"."order_id" IN (1)
  Shoppe::Product Load (0.5ms)  SELECT "shoppe_products".* FROM "shoppe_products" WHERE "shoppe_products"."id" IN (1)
  CACHE (0.0ms)  SELECT  "shoppe_orders".* FROM "shoppe_orders" WHERE "shoppe_orders"."id" = ? LIMIT 1  [["id", 1]]
   (0.1ms)  begin transaction
  Shoppe::Country Load (0.3ms)  SELECT  "shoppe_countries".* FROM "shoppe_countries" WHERE "shoppe_countries"."id" = ? LIMIT 1  [["id", 77]]
  Shoppe::OrderItem Load (0.1ms)  SELECT "shoppe_order_items".* FROM "shoppe_order_items" WHERE "shoppe_order_items"."order_id" = ?  [["order_id", 1]]
  Shoppe::Product Load (0.1ms)  SELECT  "shoppe_products".* FROM "shoppe_products" WHERE "shoppe_products"."id" = ? LIMIT 1  [["id", 1]]
  Shoppe::DeliveryServicePrice Load (0.4ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  Shoppe::DeliveryService Load (0.1ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  Shoppe::DeliveryService Load (0.1ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.1ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  SQL (0.5ms)  UPDATE "shoppe_orders" SET "first_name" = ?, "last_name" = ?, "company" = ?, "billing_address1" = ?, "billing_address3" = ?, "billing_address4" = ?, "billing_postcode" = ?, "email_address" = ?, "phone_number" = ?, "status" = ?, "updated_at" = ? WHERE "shoppe_orders"."id" = ?  [["first_name", "Maritza"], ["last_name", "Rath"], ["company", "Stiedemann, Kuvalis and Treutel"], ["billing_address1", "7913 McKenzie Bypass"], ["billing_address3", "Pollichton"], ["billing_address4", "Netherlands Antilles"], ["billing_postcode", "WT06 2HJ"], ["email_address", "ludwig@rutherford.biz"], ["phone_number", "016977 8317"], ["status", "confirming"], ["updated_at", "2015-10-06 22:43:14.801944"], ["id", 1]]
  Nifty::KeyValueStore::KeyValuePair Load (0.1ms)  SELECT "nifty_key_value_store".* FROM "nifty_key_value_store" WHERE "nifty_key_value_store"."parent_id" = ? AND "nifty_key_value_store"."parent_type" = ? AND "nifty_key_value_store"."group" = ?  [["parent_id", 1], ["parent_type", "Shoppe::Order"], ["group", "properties"]]
  CACHE (0.0ms)  SELECT "nifty_key_value_store".* FROM "nifty_key_value_store" WHERE "nifty_key_value_store"."parent_id" = ? AND "nifty_key_value_store"."parent_type" = ? AND "nifty_key_value_store"."group" = ?  [["parent_id", 1], ["parent_type", "Shoppe::Order"], ["group", :properties]]
   (1.3ms)  commit transaction
Redirected to http://localhost:3000/checkout/pay
Completed 302 Found in 52ms (ActiveRecord: 5.0ms)


Started GET "/assets/button-spinner-1af626c7a27da58434fcd1cf0ce19fb0.gif" for 127.0.0.1 at 2015-10-06 15:43:14 -0700


Started GET "/checkout/pay" for 127.0.0.1 at 2015-10-06 15:43:14 -0700
Processing by OrdersController#payment as HTML
  Shoppe::Order Load (0.3ms)  SELECT  "shoppe_orders".* FROM "shoppe_orders" WHERE "shoppe_orders"."id" = ? LIMIT 1  [["id", 1]]
  Shoppe::OrderItem Load (0.3ms)  SELECT "shoppe_order_items".* FROM "shoppe_order_items" WHERE "shoppe_order_items"."order_id" IN (1)
  Shoppe::Product Load (0.4ms)  SELECT "shoppe_products".* FROM "shoppe_products" WHERE "shoppe_products"."id" IN (1)
  CACHE (0.0ms)  SELECT  "shoppe_orders".* FROM "shoppe_orders" WHERE "shoppe_orders"."id" = ? LIMIT 1  [["id", 1]]
  Rendered orders/_checkout_sidebar.html.haml (0.5ms)
  Rendered orders/payment.html.haml within layouts/application (10.8ms)
  Shoppe::Setting Load (0.2ms)  SELECT "shoppe_settings".* FROM "shoppe_settings"
  SQL (0.4ms)  SELECT "shoppe_product_categories"."id" AS t0_r0, "shoppe_product_categories"."name" AS t0_r1, "shoppe_product_categories"."permalink" AS t0_r2, "shoppe_product_categories"."description" AS t0_r3, "shoppe_product_categories"."created_at" AS t0_r4, "shoppe_product_categories"."updated_at" AS t0_r5, "shoppe_product_categories"."parent_id" AS t0_r6, "shoppe_product_categories"."lft" AS t0_r7, "shoppe_product_categories"."rgt" AS t0_r8, "shoppe_product_categories"."depth" AS t0_r9, "shoppe_product_categories"."ancestral_permalink" AS t0_r10, "shoppe_product_categories"."permalink_includes_ancestors" AS t0_r11, "shoppe_product_category_translations"."id" AS t1_r0, "shoppe_product_category_translations"."shoppe_product_category_id" AS t1_r1, "shoppe_product_category_translations"."locale" AS t1_r2, "shoppe_product_category_translations"."created_at" AS t1_r3, "shoppe_product_category_translations"."updated_at" AS t1_r4, "shoppe_product_category_translations"."name" AS t1_r5, "shoppe_product_category_translations"."permalink" AS t1_r6, "shoppe_product_category_translations"."description" AS t1_r7 FROM "shoppe_product_categories" LEFT OUTER JOIN "shoppe_product_category_translations" ON "shoppe_product_category_translations"."shoppe_product_category_id" = "shoppe_product_categories"."id"  ORDER BY shoppe_product_category_translations.name
Completed 200 OK in 99ms (Views: 93.0ms | ActiveRecord: 1.5ms)


>>>>>>>>>>>>>>>>>>>>>>
customer:
enter card info and make payment

Started PATCH "/checkout/pay" for 127.0.0.1 at 2015-10-06 15:43:56 -0700
Processing by OrdersController#payment as HTML
  Parameters: {"utf8"=>"✓", "authenticity_token"=>"xTMbkgaN+n8Poseob3klaM4yq4++iqARwezKmSoNX62Aj5wZ8lH0spiHmEb4y9jmxJEW9YVOCxKnW75qiyn5fQ==", "commit"=>"Review your order"}
  Shoppe::Order Load (1.2ms)  SELECT  "shoppe_orders".* FROM "shoppe_orders" WHERE "shoppe_orders"."id" = ? LIMIT 1  [["id", 1]]
  Shoppe::OrderItem Load (1.5ms)  SELECT "shoppe_order_items".* FROM "shoppe_order_items" WHERE "shoppe_order_items"."order_id" IN (1)
  Shoppe::Product Load (1.3ms)  SELECT "shoppe_products".* FROM "shoppe_products" WHERE "shoppe_products"."id" IN (1)
  CACHE (0.0ms)  SELECT  "shoppe_orders".* FROM "shoppe_orders" WHERE "shoppe_orders"."id" = ? LIMIT 1  [["id", 1]]
Redirected to http://localhost:3000/checkout/confirm
Completed 302 Found in 46ms (ActiveRecord: 4.0ms)


Started GET "/checkout/confirm" for 127.0.0.1 at 2015-10-06 15:43:56 -0700
Processing by OrdersController#confirmation as HTML
  Shoppe::Order Load (0.2ms)  SELECT  "shoppe_orders".* FROM "shoppe_orders" WHERE "shoppe_orders"."id" = ? LIMIT 1  [["id", 1]]
  Shoppe::OrderItem Load (0.8ms)  SELECT "shoppe_order_items".* FROM "shoppe_order_items" WHERE "shoppe_order_items"."order_id" IN (1)
  Shoppe::Product Load (1.0ms)  SELECT "shoppe_products".* FROM "shoppe_products" WHERE "shoppe_products"."id" IN (1)
  Rendered orders/_checkout_sidebar.html.haml (1.1ms)
  Shoppe::Setting Load (0.3ms)  SELECT "shoppe_settings".* FROM "shoppe_settings"
  Shoppe::Product::Translation Load (0.2ms)  SELECT "shoppe_product_translations".* FROM "shoppe_product_translations" WHERE "shoppe_product_translations"."shoppe_product_id" = ?  [["shoppe_product_id", 1]]
  Shoppe::Product Load (0.1ms)  SELECT "shoppe_products".* FROM "shoppe_products" WHERE "shoppe_products"."parent_id" = ?  [["parent_id", 1]]
  Shoppe::TaxRate Load (0.1ms)  SELECT  "shoppe_tax_rates".* FROM "shoppe_tax_rates" WHERE "shoppe_tax_rates"."id" = ? LIMIT 1  [["id", 1]]
  Shoppe::DeliveryServicePrice Load (0.7ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  Shoppe::DeliveryService Load (0.1ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  Shoppe::DeliveryService Load (0.1ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  Shoppe::DeliveryServicePrice Load (0.1ms)  SELECT  "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" WHERE "shoppe_delivery_service_prices"."delivery_service_id" = ? AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."id" ASC LIMIT 1  [["delivery_service_id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" WHERE "shoppe_delivery_service_prices"."delivery_service_id" = ? AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."id" ASC LIMIT 1  [["delivery_service_id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" WHERE "shoppe_delivery_service_prices"."delivery_service_id" = ? AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."id" ASC LIMIT 1  [["delivery_service_id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" WHERE "shoppe_delivery_service_prices"."delivery_service_id" = ? AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."id" ASC LIMIT 1  [["delivery_service_id", 1]]
  CACHE (0.0ms)  SELECT  "shoppe_tax_rates".* FROM "shoppe_tax_rates" WHERE "shoppe_tax_rates"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" WHERE "shoppe_delivery_service_prices"."delivery_service_id" = ? AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."id" ASC LIMIT 1  [["delivery_service_id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" WHERE "shoppe_delivery_service_prices"."delivery_service_id" = ? AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."id" ASC LIMIT 1  [["delivery_service_id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" WHERE "shoppe_delivery_service_prices"."delivery_service_id" = ? AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."id" ASC LIMIT 1  [["delivery_service_id", 1]]
  CACHE (0.0ms)  SELECT  "shoppe_tax_rates".* FROM "shoppe_tax_rates" WHERE "shoppe_tax_rates"."id" = ? LIMIT 1  [["id", 1]]
  Rendered shared/_order_items.html.haml (83.0ms)
  Rendered orders/confirmation.html.haml within layouts/application (96.9ms)
  SQL (0.5ms)  SELECT "shoppe_product_categories"."id" AS t0_r0, "shoppe_product_categories"."name" AS t0_r1, "shoppe_product_categories"."permalink" AS t0_r2, "shoppe_product_categories"."description" AS t0_r3, "shoppe_product_categories"."created_at" AS t0_r4, "shoppe_product_categories"."updated_at" AS t0_r5, "shoppe_product_categories"."parent_id" AS t0_r6, "shoppe_product_categories"."lft" AS t0_r7, "shoppe_product_categories"."rgt" AS t0_r8, "shoppe_product_categories"."depth" AS t0_r9, "shoppe_product_categories"."ancestral_permalink" AS t0_r10, "shoppe_product_categories"."permalink_includes_ancestors" AS t0_r11, "shoppe_product_category_translations"."id" AS t1_r0, "shoppe_product_category_translations"."shoppe_product_category_id" AS t1_r1, "shoppe_product_category_translations"."locale" AS t1_r2, "shoppe_product_category_translations"."created_at" AS t1_r3, "shoppe_product_category_translations"."updated_at" AS t1_r4, "shoppe_product_category_translations"."name" AS t1_r5, "shoppe_product_category_translations"."permalink" AS t1_r6, "shoppe_product_category_translations"."description" AS t1_r7 FROM "shoppe_product_categories" LEFT OUTER JOIN "shoppe_product_category_translations" ON "shoppe_product_category_translations"."shoppe_product_category_id" = "shoppe_product_categories"."id"  ORDER BY shoppe_product_category_translations.name
Completed 200 OK in 157ms (Views: 146.2ms | ActiveRecord: 4.9ms)


>>>>>>>>>>>>>>>>>>>>>>>>
customer:
click place order

Started PATCH "/checkout/confirm" for 127.0.0.1 at 2015-10-06 15:44:25 -0700
Processing by OrdersController#confirmation as HTML
  Parameters: {"utf8"=>"✓", "authenticity_token"=>"/tm58111QriSWyICkGJDAigH4MNY/8Xye4VGl0Psn4S7ZT54qalMdQV+fewH0L6MIqRduWM7bvEdMjJk4sg5VA=="}
  Shoppe::Order Load (0.4ms)  SELECT  "shoppe_orders".* FROM "shoppe_orders" WHERE "shoppe_orders"."id" = ? LIMIT 1  [["id", 1]]
  Shoppe::OrderItem Load (0.6ms)  SELECT "shoppe_order_items".* FROM "shoppe_order_items" WHERE "shoppe_order_items"."order_id" IN (1)
  Shoppe::Product Load (0.5ms)  SELECT "shoppe_products".* FROM "shoppe_products" WHERE "shoppe_products"."id" IN (1)
   (0.2ms)  SELECT SUM("shoppe_stock_level_adjustments"."adjustment") FROM "shoppe_stock_level_adjustments" WHERE "shoppe_stock_level_adjustments"."item_id" = ? AND "shoppe_stock_level_adjustments"."item_type" = ?  [["item_id", 1], ["item_type", "Shoppe::Product"]]
   (0.2ms)  SELECT SUM("shoppe_stock_level_adjustments"."adjustment") FROM "shoppe_stock_level_adjustments" WHERE "shoppe_stock_level_adjustments"."parent_id" = ? AND "shoppe_stock_level_adjustments"."parent_type" = ?  [["parent_id", 1], ["parent_type", "Shoppe::OrderItem"]]
  Shoppe::DeliveryServicePrice Load (0.9ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  Shoppe::DeliveryService Load (0.1ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  Shoppe::DeliveryService Load (0.1ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  Shoppe::DeliveryServicePrice Load (0.1ms)  SELECT  "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" WHERE "shoppe_delivery_service_prices"."delivery_service_id" = ? AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."id" ASC LIMIT 1  [["delivery_service_id", 1]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" WHERE "shoppe_delivery_service_prices"."delivery_service_id" = ? AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."id" ASC LIMIT 1  [["delivery_service_id", 1]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" WHERE "shoppe_delivery_service_prices"."delivery_service_id" = ? AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."id" ASC LIMIT 1  [["delivery_service_id", 1]]
  Shoppe::TaxRate Load (0.1ms)  SELECT  "shoppe_tax_rates".* FROM "shoppe_tax_rates" WHERE "shoppe_tax_rates"."id" = ? LIMIT 1  [["id", 1]]
   (0.3ms)  begin transaction
  Shoppe::Country Load (0.1ms)  SELECT  "shoppe_countries".* FROM "shoppe_countries" WHERE "shoppe_countries"."id" = ? LIMIT 1  [["id", 77]]
  CACHE (0.0ms)  SELECT "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" INNER JOIN "shoppe_delivery_services" ON "shoppe_delivery_services"."id" = "shoppe_delivery_service_prices"."delivery_service_id" WHERE "shoppe_delivery_services"."active" = 't' AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."price" ASC
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 2]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_services".* FROM "shoppe_delivery_services" WHERE "shoppe_delivery_services"."id" = ? LIMIT 1  [["id", 1]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" WHERE "shoppe_delivery_service_prices"."delivery_service_id" = ? AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."id" ASC LIMIT 1  [["delivery_service_id", 1]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" WHERE "shoppe_delivery_service_prices"."delivery_service_id" = ? AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."id" ASC LIMIT 1  [["delivery_service_id", 1]]
  CACHE (0.0ms)  SELECT  "shoppe_delivery_service_prices".* FROM "shoppe_delivery_service_prices" WHERE "shoppe_delivery_service_prices"."delivery_service_id" = ? AND (min_weight <= 1.119 AND max_weight >= 1.119)  ORDER BY "shoppe_delivery_service_prices"."id" ASC LIMIT 1  [["delivery_service_id", 1]]
  CACHE (0.0ms)  SELECT  "shoppe_tax_rates".* FROM "shoppe_tax_rates" WHERE "shoppe_tax_rates"."id" = ? LIMIT 1  [["id", 1]]
  SQL (0.8ms)  UPDATE "shoppe_orders" SET "delivery_service_id" = ?, "status" = ?, "received_at" = ?, "delivery_price" = ?, "delivery_cost_price" = ?, "delivery_tax_rate" = ?, "updated_at" = ? WHERE "shoppe_orders"."id" = ?  [["delivery_service_id", 1], ["status", "received"], ["received_at", "2015-10-06 22:44:25.843953"], ["delivery_price", 8.0], ["delivery_cost_price", 7.5], ["delivery_tax_rate", 20.0], ["updated_at", "2015-10-06 22:44:25.859951"], ["id", 1]]
  Nifty::KeyValueStore::KeyValuePair Load (0.1ms)  SELECT "nifty_key_value_store".* FROM "nifty_key_value_store" WHERE "nifty_key_value_store"."parent_id" = ? AND "nifty_key_value_store"."parent_type" = ? AND "nifty_key_value_store"."group" = ?  [["parent_id", 1], ["parent_type", "Shoppe::Order"], ["group", "properties"]]
  CACHE (0.0ms)  SELECT "nifty_key_value_store".* FROM "nifty_key_value_store" WHERE "nifty_key_value_store"."parent_id" = ? AND "nifty_key_value_store"."parent_type" = ? AND "nifty_key_value_store"."group" = ?  [["parent_id", 1], ["parent_type", "Shoppe::Order"], ["group", :properties]]
   (1.0ms)  commit transaction
  Shoppe::Product Load (0.1ms)  SELECT "shoppe_products".* FROM "shoppe_products" WHERE "shoppe_products"."parent_id" = ?  [["parent_id", 1]]
  Shoppe::TaxRate Load (0.1ms)  SELECT  "shoppe_tax_rates".* FROM "shoppe_tax_rates" WHERE "shoppe_tax_rates"."id" = ? LIMIT 1  [["id", 1]]
   (0.1ms)  begin transaction
   (0.1ms)  SELECT SUM("shoppe_stock_level_adjustments"."adjustment") FROM "shoppe_stock_level_adjustments" WHERE "shoppe_stock_level_adjustments"."item_id" = ? AND "shoppe_stock_level_adjustments"."item_type" = ?  [["item_id", 1], ["item_type", "Shoppe::Product"]]
   (0.1ms)  SELECT SUM("shoppe_stock_level_adjustments"."adjustment") FROM "shoppe_stock_level_adjustments" WHERE "shoppe_stock_level_adjustments"."parent_id" = ? AND "shoppe_stock_level_adjustments"."parent_type" = ?  [["parent_id", 1], ["parent_type", "Shoppe::OrderItem"]]
  SQL (0.3ms)  UPDATE "shoppe_order_items" SET "weight" = ?, "unit_price" = ?, "unit_cost_price" = ?, "tax_rate" = ?, "updated_at" = ? WHERE "shoppe_order_items"."id" = ?  [["weight", 1.119], ["unit_price", 54.99], ["unit_cost_price", 44.99], ["tax_rate", 20.0], ["updated_at", "2015-10-06 22:44:25.873855"], ["id", 1]]
  SQL (0.2ms)  UPDATE "shoppe_orders" SET "updated_at" = '2015-10-06 22:44:25.876192' WHERE "shoppe_orders"."id" = ?  [["id", 1]]
   (0.6ms)  commit transaction
   (0.1ms)  SELECT SUM("shoppe_stock_level_adjustments"."adjustment") FROM "shoppe_stock_level_adjustments" WHERE "shoppe_stock_level_adjustments"."parent_id" = ? AND "shoppe_stock_level_adjustments"."parent_type" = ?  [["parent_id", 1], ["parent_type", "Shoppe::OrderItem"]]
  CACHE (0.0ms)  SELECT SUM("shoppe_stock_level_adjustments"."adjustment") FROM "shoppe_stock_level_adjustments" WHERE "shoppe_stock_level_adjustments"."parent_id" = ? AND "shoppe_stock_level_adjustments"."parent_type" = ?  [["parent_id", 1], ["parent_type", "Shoppe::OrderItem"]]
   (0.1ms)  begin transaction
  SQL (0.3ms)  INSERT INTO "shoppe_stock_level_adjustments" ("parent_id", "parent_type", "adjustment", "description", "item_id", "item_type", "created_at", "updated_at") VALUES (?, ?, ?, ?, ?, ?, ?, ?)  [["parent_id", 1], ["parent_type", "Shoppe::OrderItem"], ["adjustment", -1], ["description", "Order #000001"], ["item_id", 1], ["item_type", "Shoppe::Product"], ["created_at", "2015-10-06 22:44:25.892258"], ["updated_at", "2015-10-06 22:44:25.892258"]]
   (0.6ms)  commit transaction
  Shoppe::Setting Load (0.2ms)  SELECT "shoppe_settings".* FROM "shoppe_settings"
  Rendered /usr/local/lib/ruby/gems/2.1.0/gems/shoppe-1.1.1/app/views/shoppe/order_mailer/received.text.erb (1.0ms)

Shoppe::OrderMailer#received: processed outbound mail in 292.7ms

Sent mail to ludwig@rutherford.biz (6.9ms)
Date: Tue, 06 Oct 2015 15:44:26 -0700
From: "Widgets Inc." <sales@example.com>
To: ludwig@rutherford.biz
Message-ID: <56144eca36db9_133d13f8390fe132c3960@dragon.mail>
Subject: Order Confirmation
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 7bit
/*
Hello Maritza!

Re: Order #000001

We're pleased to let you know that we have received your order and one of our team will be accepting it shortly.

We will e-mail you again when your order has been accepted.

Many thanks,

Widgets Inc.
sales@example.com
*/
   (0.1ms)  begin transaction
  SQL (0.4ms)  INSERT INTO "shoppe_payments" ("method", "amount", "reference", "refundable", "order_id", "created_at", "updated_at") VALUES (?, ?, ?, ?, ?, ?, ?)  [["method", "Credit Card"], ["amount", 75.588], ["reference", "19075"], ["refundable", "t"], ["order_id", 1], ["created_at", "2015-10-06 22:44:26.246501"], ["updated_at", "2015-10-06 22:44:26.246501"]]
   (0.2ms)  SELECT SUM("shoppe_payments"."amount") FROM "shoppe_payments" WHERE "shoppe_payments"."order_id" = ?  [["order_id", 1]]
  SQL (0.1ms)  UPDATE "shoppe_orders" SET "amount_paid" = ?, "updated_at" = ? WHERE "shoppe_orders"."id" = ?  [["amount_paid", 75.588], ["updated_at", "2015-10-06 22:44:26.249495"], ["id", 1]]
  Nifty::KeyValueStore::KeyValuePair Load (0.0ms)  SELECT "nifty_key_value_store".* FROM "nifty_key_value_store" WHERE "nifty_key_value_store"."parent_id" = ? AND "nifty_key_value_store"."parent_type" = ? AND "nifty_key_value_store"."group" = ?  [["parent_id", 1], ["parent_type", "Shoppe::Order"], ["group", "properties"]]
  Nifty::KeyValueStore::KeyValuePair Load (0.0ms)  SELECT "nifty_key_value_store".* FROM "nifty_key_value_store" WHERE "nifty_key_value_store"."parent_id" = ? AND "nifty_key_value_store"."parent_type" = ? AND "nifty_key_value_store"."group" = ?  [["parent_id", 1], ["parent_type", "Shoppe::Payment"], ["group", "properties"]]
  CACHE (0.0ms)  SELECT "nifty_key_value_store".* FROM "nifty_key_value_store" WHERE "nifty_key_value_store"."parent_id" = ? AND "nifty_key_value_store"."parent_type" = ? AND "nifty_key_value_store"."group" = ?  [["parent_id", 1], ["parent_type", "Shoppe::Payment"], ["group", :properties]]
   (0.8ms)  commit transaction
Redirected to http://localhost:3000/
Completed 302 Found in 461ms (ActiveRecord: 10.7ms)


Started GET "/" for 127.0.0.1 at 2015-10-06 15:44:26 -0700
Processing by PagesController#home as HTML
  Shoppe::Product Load (0.1ms)  SELECT "shoppe_products".* FROM "shoppe_products" WHERE "shoppe_products"."active" = ? AND "shoppe_products"."featured" = ? AND "shoppe_products"."parent_id" IS NULL  [["active", "t"], ["featured", "t"]]
  Shoppe::ProductCategorization Load (0.2ms)  SELECT "shoppe_product_categorizations".* FROM "shoppe_product_categorizations" WHERE "shoppe_product_categorizations"."product_id" IN (1, 4, 5, 8, 11)
  Shoppe::ProductCategory Load (0.2ms)  SELECT "shoppe_product_categories".* FROM "shoppe_product_categories" WHERE "shoppe_product_categories"."id" IN (1, 2)
  Shoppe::Product Load (0.2ms)  SELECT "shoppe_products".* FROM "shoppe_products" WHERE "shoppe_products"."parent_id" IN (1, 4, 5, 8, 11)
  Shoppe::Attachment Load (0.1ms)  SELECT  "shoppe_attachments".* FROM "shoppe_attachments" WHERE "shoppe_attachments"."parent_id" = ? AND "shoppe_attachments"."parent_type" = ? AND "shoppe_attachments"."role" = ?  ORDER BY "shoppe_attachments"."id" ASC LIMIT 1  [["parent_id", 1], ["parent_type", "Shoppe::Product"], ["role", "default_image"]]
  CACHE (0.0ms)  SELECT  "shoppe_attachments".* FROM "shoppe_attachments" WHERE "shoppe_attachments"."parent_id" = ? AND "shoppe_attachments"."parent_type" = ? AND "shoppe_attachments"."role" = ?  ORDER BY "shoppe_attachments"."id" ASC LIMIT 1  [["parent_id", 1], ["parent_type", "Shoppe::Product"], ["role", "default_image"]]
  Shoppe::Product::Translation Load (0.1ms)  SELECT "shoppe_product_translations".* FROM "shoppe_product_translations" WHERE "shoppe_product_translations"."shoppe_product_id" = ?  [["shoppe_product_id", 1]]
  Shoppe::ProductCategory::Translation Load (0.1ms)  SELECT "shoppe_product_category_translations".* FROM "shoppe_product_category_translations" WHERE "shoppe_product_category_translations"."shoppe_product_category_id" = ?  [["shoppe_product_category_id", 1]]
  Shoppe::Setting Load (0.1ms)  SELECT "shoppe_settings".* FROM "shoppe_settings"
  Shoppe::Attachment Load (0.1ms)  SELECT  "shoppe_attachments".* FROM "shoppe_attachments" WHERE "shoppe_attachments"."parent_id" = ? AND "shoppe_attachments"."parent_type" = ? AND "shoppe_attachments"."role" = ?  ORDER BY "shoppe_attachments"."id" ASC LIMIT 1  [["parent_id", 4], ["parent_type", "Shoppe::Product"], ["role", "default_image"]]
  CACHE (0.0ms)  SELECT  "shoppe_attachments".* FROM "shoppe_attachments" WHERE "shoppe_attachments"."parent_id" = ? AND "shoppe_attachments"."parent_type" = ? AND "shoppe_attachments"."role" = ?  ORDER BY "shoppe_attachments"."id" ASC LIMIT 1  [["parent_id", 4], ["parent_type", "Shoppe::Product"], ["role", "default_image"]]
  Shoppe::Product::Translation Load (0.1ms)  SELECT "shoppe_product_translations".* FROM "shoppe_product_translations" WHERE "shoppe_product_translations"."shoppe_product_id" = ?  [["shoppe_product_id", 4]]
  Shoppe::Attachment Load (0.1ms)  SELECT  "shoppe_attachments".* FROM "shoppe_attachments" WHERE "shoppe_attachments"."parent_id" = ? AND "shoppe_attachments"."parent_type" = ? AND "shoppe_attachments"."role" = ?  ORDER BY "shoppe_attachments"."id" ASC LIMIT 1  [["parent_id", 5], ["parent_type", "Shoppe::Product"], ["role", "default_image"]]
  CACHE (0.0ms)  SELECT  "shoppe_attachments".* FROM "shoppe_attachments" WHERE "shoppe_attachments"."parent_id" = ? AND "shoppe_attachments"."parent_type" = ? AND "shoppe_attachments"."role" = ?  ORDER BY "shoppe_attachments"."id" ASC LIMIT 1  [["parent_id", 5], ["parent_type", "Shoppe::Product"], ["role", "default_image"]]
  Shoppe::Product::Translation Load (0.1ms)  SELECT "shoppe_product_translations".* FROM "shoppe_product_translations" WHERE "shoppe_product_translations"."shoppe_product_id" = ?  [["shoppe_product_id", 5]]
  Shoppe::Product Load (0.1ms)  SELECT  "shoppe_products".* FROM "shoppe_products" WHERE "shoppe_products"."id" = ? LIMIT 1  [["id", 5]]
  Shoppe::Attachment Load (0.1ms)  SELECT  "shoppe_attachments".* FROM "shoppe_attachments" WHERE "shoppe_attachments"."parent_id" = ? AND "shoppe_attachments"."parent_type" = ? AND "shoppe_attachments"."role" = ?  ORDER BY "shoppe_attachments"."id" ASC LIMIT 1  [["parent_id", 8], ["parent_type", "Shoppe::Product"], ["role", "default_image"]]
  CACHE (0.0ms)  SELECT  "shoppe_attachments".* FROM "shoppe_attachments" WHERE "shoppe_attachments"."parent_id" = ? AND "shoppe_attachments"."parent_type" = ? AND "shoppe_attachments"."role" = ?  ORDER BY "shoppe_attachments"."id" ASC LIMIT 1  [["parent_id", 8], ["parent_type", "Shoppe::Product"], ["role", "default_image"]]
  Shoppe::Product::Translation Load (0.1ms)  SELECT "shoppe_product_translations".* FROM "shoppe_product_translations" WHERE "shoppe_product_translations"."shoppe_product_id" = ?  [["shoppe_product_id", 8]]
  Shoppe::ProductCategory::Translation Load (0.1ms)  SELECT "shoppe_product_category_translations".* FROM "shoppe_product_category_translations" WHERE "shoppe_product_category_translations"."shoppe_product_category_id" = ?  [["shoppe_product_category_id", 2]]
  Shoppe::Attachment Load (0.1ms)  SELECT  "shoppe_attachments".* FROM "shoppe_attachments" WHERE "shoppe_attachments"."parent_id" = ? AND "shoppe_attachments"."parent_type" = ? AND "shoppe_attachments"."role" = ?  ORDER BY "shoppe_attachments"."id" ASC LIMIT 1  [["parent_id", 11], ["parent_type", "Shoppe::Product"], ["role", "default_image"]]
  CACHE (0.0ms)  SELECT  "shoppe_attachments".* FROM "shoppe_attachments" WHERE "shoppe_attachments"."parent_id" = ? AND "shoppe_attachments"."parent_type" = ? AND "shoppe_attachments"."role" = ?  ORDER BY "shoppe_attachments"."id" ASC LIMIT 1  [["parent_id", 11], ["parent_type", "Shoppe::Product"], ["role", "default_image"]]
  Shoppe::Product::Translation Load (0.1ms)  SELECT "shoppe_product_translations".* FROM "shoppe_product_translations" WHERE "shoppe_product_translations"."shoppe_product_id" = ?  [["shoppe_product_id", 11]]
  Rendered shared/_product_list.html.haml (34.9ms)
  Rendered pages/home.html.haml within layouts/application (35.9ms)
  SQL (0.3ms)  SELECT "shoppe_product_categories"."id" AS t0_r0, "shoppe_product_categories"."name" AS t0_r1, "shoppe_product_categories"."permalink" AS t0_r2, "shoppe_product_categories"."description" AS t0_r3, "shoppe_product_categories"."created_at" AS t0_r4, "shoppe_product_categories"."updated_at" AS t0_r5, "shoppe_product_categories"."parent_id" AS t0_r6, "shoppe_product_categories"."lft" AS t0_r7, "shoppe_product_categories"."rgt" AS t0_r8, "shoppe_product_categories"."depth" AS t0_r9, "shoppe_product_categories"."ancestral_permalink" AS t0_r10, "shoppe_product_categories"."permalink_includes_ancestors" AS t0_r11, "shoppe_product_category_translations"."id" AS t1_r0, "shoppe_product_category_translations"."shoppe_product_category_id" AS t1_r1, "shoppe_product_category_translations"."locale" AS t1_r2, "shoppe_product_category_translations"."created_at" AS t1_r3, "shoppe_product_category_translations"."updated_at" AS t1_r4, "shoppe_product_category_translations"."name" AS t1_r5, "shoppe_product_category_translations"."permalink" AS t1_r6, "shoppe_product_category_translations"."description" AS t1_r7 FROM "shoppe_product_categories" LEFT OUTER JOIN "shoppe_product_category_translations" ON "shoppe_product_category_translations"."shoppe_product_category_id" = "shoppe_product_categories"."id"  ORDER BY shoppe_product_category_translations.name
  Rendered shared/_basket.html.haml (0.1ms)
  Rendered shared/_reasons.html.haml (0.1ms)
Completed 200 OK in 72ms (Views: 69.4ms | ActiveRecord: 2.2ms)

