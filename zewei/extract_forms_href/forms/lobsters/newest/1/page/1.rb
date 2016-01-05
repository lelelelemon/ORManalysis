<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <title>Action Controller: Exception caught</title>
  <style>
    body {
      background-color: #FAFAFA;
      color: #333;
      margin: 0px;
    }

    body, p, ol, ul, td {
      font-family: helvetica, verdana, arial, sans-serif;
      font-size:   13px;
      line-height: 18px;
    }

    pre {
      font-size: 11px;
      white-space: pre-wrap;
    }

    pre.box {
      border: 1px solid #EEE;
      padding: 10px;
      margin: 0px;
      width: 958px;
    }

    header {
      color: #F0F0F0;
      background: #C52F24;
      padding: 0.5em 1.5em;
    }

    h1 {
      margin: 0.2em 0;
      line-height: 1.1em;
      font-size: 2em;
    }

    h2 {
      color: #C52F24;
      line-height: 25px;
    }

    .details {
      border: 1px solid #D0D0D0;
      border-radius: 4px;
      margin: 1em 0px;
      display: block;
      width: 978px;
    }

    .summary {
      padding: 8px 15px;
      border-bottom: 1px solid #D0D0D0;
      display: block;
    }

    .details pre {
      margin: 5px;
      border: none;
    }

    #container {
      box-sizing: border-box;
      width: 100%;
      padding: 0 1.5em;
    }

    .source * {
      margin: 0px;
      padding: 0px;
    }

    .source {
      border: 1px solid #D9D9D9;
      background: #ECECEC;
      width: 978px;
    }

    .source pre {
      padding: 10px 0px;
      border: none;
    }

    .source .data {
      font-size: 80%;
      overflow: auto;
      background-color: #FFF;
    }

    .info {
      padding: 0.5em;
    }

    .source .data .line_numbers {
      background-color: #ECECEC;
      color: #AAA;
      padding: 1em .5em;
      border-right: 1px solid #DDD;
      text-align: right;
    }

    .line {
      padding-left: 10px;
    }

    .line:hover {
      background-color: #F6F6F6;
    }

    .line.active {
      background-color: #FFCCCC;
    }

    a { color: #980905; }
    a:visited { color: #666; }
    a:hover { color: #C52F24; }

    
  </style>

  <script>
    var toggle = function(id) {
      var s = document.getElementById(id).style;
      s.display = s.display == 'none' ? 'block' : 'none';
      return false;
    }
    var show = function(id) {
      document.getElementById(id).style.display = 'block';
    }
    var hide = function(id) {
      document.getElementById(id).style.display = 'none';
    }
    var toggleTrace = function() {
      return toggle('blame_trace');
    }
    var toggleSessionDump = function() {
      return toggle('session_dump');
    }
    var toggleEnvDump = function() {
      return toggle('env_dump');
    }
  </script>
</head>
<body>

<header>
  <h1>
    ActiveRecord::RecordNotFound
      in HomeController#newest_by_user
  </h1>
</header>

<div id="container">
  <h2>ActiveRecord::RecordNotFound</h2>

  <div class="source">
<div class="info">
  Extracted source (around line <strong>#93</strong>):
</div>
<div class="data">
  <table cellpadding="0" cellspacing="0" class="lines">
      <tr>
        <td>
          <pre class="line_numbers">
<span>91</span>
<span>92</span>
<span>93</span>
<span>94</span>
<span>95</span>
<span>96</span>
          </pre>
        </td>
<td width="100%">
<pre>
<div class="line">
</div><div class="line">  def newest_by_user
</div><div class="line active">    by_user = User.where(:username =&gt; params[:user]).first!
</div><div class="line">
</div><div class="line">    @stories, @show_more = get_from_cache(by_user: by_user) {
</div><div class="line">      paginate stories.newest_by_user(by_user)
</div>
</pre>
</td>
    </tr>
  </table>
</div>
</div>

  
<p><code>Rails.root: /home/student/ORM/lobsters</code></p>

<div id="traces">
    <a href="#" onclick="hide(&#39;Framework-Trace&#39;);hide(&#39;Full-Trace&#39;);show(&#39;Application-Trace&#39;);; return false;">Application Trace</a> |
    <a href="#" onclick="hide(&#39;Application-Trace&#39;);hide(&#39;Full-Trace&#39;);show(&#39;Framework-Trace&#39;);; return false;">Framework Trace</a> |
    <a href="#" onclick="hide(&#39;Application-Trace&#39;);hide(&#39;Framework-Trace&#39;);show(&#39;Full-Trace&#39;);; return false;">Full Trace</a> 

    <div id="Application-Trace" style="display: block;">
      <pre><code>app/controllers/home_controller.rb:93:in `newest_by_user&#39;</code></pre>
    </div>
    <div id="Framework-Trace" style="display: none;">
      <pre><code>activerecord (4.1.12) lib/active_record/relation/finder_methods.rb:139:in `first!&#39;
actionpack (4.1.12) lib/action_controller/metal/implicit_render.rb:4:in `send_action&#39;
actionpack (4.1.12) lib/abstract_controller/base.rb:189:in `process_action&#39;
actionpack (4.1.12) lib/action_controller/metal/rendering.rb:10:in `process_action&#39;
actionpack (4.1.12) lib/abstract_controller/callbacks.rb:20:in `block in process_action&#39;
activesupport (4.1.12) lib/active_support/callbacks.rb:113:in `call&#39;
activesupport (4.1.12) lib/active_support/callbacks.rb:113:in `call&#39;
activesupport (4.1.12) lib/active_support/callbacks.rb:552:in `block (2 levels) in compile&#39;
activesupport (4.1.12) lib/active_support/callbacks.rb:502:in `call&#39;
activesupport (4.1.12) lib/active_support/callbacks.rb:502:in `call&#39;
activesupport (4.1.12) lib/active_support/callbacks.rb:86:in `run_callbacks&#39;
actionpack (4.1.12) lib/abstract_controller/callbacks.rb:19:in `process_action&#39;
actionpack (4.1.12) lib/action_controller/metal/rescue.rb:29:in `process_action&#39;
actionpack (4.1.12) lib/action_controller/metal/instrumentation.rb:32:in `block in process_action&#39;
activesupport (4.1.12) lib/active_support/notifications.rb:159:in `block in instrument&#39;
activesupport (4.1.12) lib/active_support/notifications/instrumenter.rb:20:in `instrument&#39;
activesupport (4.1.12) lib/active_support/notifications.rb:159:in `instrument&#39;
actionpack (4.1.12) lib/action_controller/metal/instrumentation.rb:30:in `process_action&#39;
actionpack (4.1.12) lib/action_controller/metal/params_wrapper.rb:250:in `process_action&#39;
activerecord (4.1.12) lib/active_record/railties/controller_runtime.rb:18:in `process_action&#39;
actionpack (4.1.12) lib/abstract_controller/base.rb:136:in `process&#39;
actionview (4.1.12) lib/action_view/rendering.rb:30:in `process&#39;
actionpack (4.1.12) lib/action_controller/metal.rb:196:in `dispatch&#39;
actionpack (4.1.12) lib/action_controller/metal/rack_delegation.rb:13:in `dispatch&#39;
actionpack (4.1.12) lib/action_controller/metal.rb:232:in `block in action&#39;
actionpack (4.1.12) lib/action_dispatch/routing/route_set.rb:82:in `call&#39;
actionpack (4.1.12) lib/action_dispatch/routing/route_set.rb:82:in `dispatch&#39;
actionpack (4.1.12) lib/action_dispatch/routing/route_set.rb:50:in `call&#39;
actionpack (4.1.12) lib/action_dispatch/journey/router.rb:73:in `block in call&#39;
actionpack (4.1.12) lib/action_dispatch/journey/router.rb:59:in `each&#39;
actionpack (4.1.12) lib/action_dispatch/journey/router.rb:59:in `call&#39;
actionpack (4.1.12) lib/action_dispatch/routing/route_set.rb:692:in `call&#39;
rack (1.5.5) lib/rack/etag.rb:23:in `call&#39;
rack (1.5.5) lib/rack/conditionalget.rb:25:in `call&#39;
rack (1.5.5) lib/rack/head.rb:11:in `call&#39;
actionpack (4.1.12) lib/action_dispatch/middleware/params_parser.rb:27:in `call&#39;
actionpack (4.1.12) lib/action_dispatch/middleware/flash.rb:254:in `call&#39;
rack (1.5.5) lib/rack/session/abstract/id.rb:225:in `context&#39;
rack (1.5.5) lib/rack/session/abstract/id.rb:220:in `call&#39;
actionpack (4.1.12) lib/action_dispatch/middleware/cookies.rb:562:in `call&#39;
activerecord (4.1.12) lib/active_record/query_cache.rb:36:in `call&#39;
activerecord (4.1.12) lib/active_record/connection_adapters/abstract/connection_pool.rb:621:in `call&#39;
activerecord (4.1.12) lib/active_record/migration.rb:380:in `call&#39;
actionpack (4.1.12) lib/action_dispatch/middleware/callbacks.rb:29:in `block in call&#39;
activesupport (4.1.12) lib/active_support/callbacks.rb:82:in `run_callbacks&#39;
actionpack (4.1.12) lib/action_dispatch/middleware/callbacks.rb:27:in `call&#39;
actionpack (4.1.12) lib/action_dispatch/middleware/reloader.rb:73:in `call&#39;
actionpack (4.1.12) lib/action_dispatch/middleware/remote_ip.rb:76:in `call&#39;
actionpack (4.1.12) lib/action_dispatch/middleware/debug_exceptions.rb:17:in `call&#39;
actionpack (4.1.12) lib/action_dispatch/middleware/show_exceptions.rb:30:in `call&#39;
railties (4.1.12) lib/rails/rack/logger.rb:38:in `call_app&#39;
railties (4.1.12) lib/rails/rack/logger.rb:20:in `block in call&#39;
activesupport (4.1.12) lib/active_support/tagged_logging.rb:68:in `block in tagged&#39;
activesupport (4.1.12) lib/active_support/tagged_logging.rb:26:in `tagged&#39;
activesupport (4.1.12) lib/active_support/tagged_logging.rb:68:in `tagged&#39;
railties (4.1.12) lib/rails/rack/logger.rb:20:in `call&#39;
actionpack (4.1.12) lib/action_dispatch/middleware/request_id.rb:21:in `call&#39;
rack (1.5.5) lib/rack/methodoverride.rb:21:in `call&#39;
rack (1.5.5) lib/rack/runtime.rb:17:in `call&#39;
activesupport (4.1.12) lib/active_support/cache/strategy/local_cache_middleware.rb:26:in `call&#39;
rack (1.5.5) lib/rack/lock.rb:17:in `call&#39;
actionpack (4.1.12) lib/action_dispatch/middleware/static.rb:84:in `call&#39;
rack (1.5.5) lib/rack/sendfile.rb:112:in `call&#39;
railties (4.1.12) lib/rails/engine.rb:514:in `call&#39;
railties (4.1.12) lib/rails/application.rb:144:in `call&#39;
rack-test (0.6.3) lib/rack/mock_session.rb:30:in `request&#39;
rack-test (0.6.3) lib/rack/test.rb:244:in `process_request&#39;
rack-test (0.6.3) lib/rack/test.rb:124:in `request&#39;
actionpack (4.1.12) lib/action_dispatch/testing/integration.rb:309:in `process&#39;
actionpack (4.1.12) lib/action_dispatch/testing/integration.rb:32:in `get&#39;
(irb):145:in `block in irb_binding&#39;
(irb):142:in `each&#39;
(irb):142:in `irb_binding&#39;
/home/student/.rvm/rubies/ruby-2.2.1/lib/ruby/2.2.0/irb/workspace.rb:86:in `eval&#39;
/home/student/.rvm/rubies/ruby-2.2.1/lib/ruby/2.2.0/irb/workspace.rb:86:in `evaluate&#39;
/home/student/.rvm/rubies/ruby-2.2.1/lib/ruby/2.2.0/irb/context.rb:379:in `evaluate&#39;
/home/student/.rvm/rubies/ruby-2.2.1/lib/ruby/2.2.0/irb.rb:489:in `block (2 levels) in eval_input&#39;
/home/student/.rvm/rubies/ruby-2.2.1/lib/ruby/2.2.0/irb.rb:623:in `signal_status&#39;
/home/student/.rvm/rubies/ruby-2.2.1/lib/ruby/2.2.0/irb.rb:486:in `block in eval_input&#39;
/home/student/.rvm/rubies/ruby-2.2.1/lib/ruby/2.2.0/irb/ruby-lex.rb:245:in `block (2 levels) in each_top_level_statement&#39;
/home/student/.rvm/rubies/ruby-2.2.1/lib/ruby/2.2.0/irb/ruby-lex.rb:231:in `loop&#39;
/home/student/.rvm/rubies/ruby-2.2.1/lib/ruby/2.2.0/irb/ruby-lex.rb:231:in `block in each_top_level_statement&#39;
/home/student/.rvm/rubies/ruby-2.2.1/lib/ruby/2.2.0/irb/ruby-lex.rb:230:in `catch&#39;
/home/student/.rvm/rubies/ruby-2.2.1/lib/ruby/2.2.0/irb/ruby-lex.rb:230:in `each_top_level_statement&#39;
/home/student/.rvm/rubies/ruby-2.2.1/lib/ruby/2.2.0/irb.rb:485:in `eval_input&#39;
/home/student/.rvm/rubies/ruby-2.2.1/lib/ruby/2.2.0/irb.rb:395:in `block in start&#39;
/home/student/.rvm/rubies/ruby-2.2.1/lib/ruby/2.2.0/irb.rb:394:in `catch&#39;
/home/student/.rvm/rubies/ruby-2.2.1/lib/ruby/2.2.0/irb.rb:394:in `start&#39;
railties (4.1.12) lib/rails/commands/console.rb:90:in `start&#39;
railties (4.1.12) lib/rails/commands/console.rb:9:in `start&#39;
railties (4.1.12) lib/rails/commands/commands_tasks.rb:69:in `console&#39;
railties (4.1.12) lib/rails/commands/commands_tasks.rb:40:in `run_command!&#39;
railties (4.1.12) lib/rails/commands.rb:17:in `&lt;top (required)&gt;&#39;
bin/rails:4:in `require&#39;
bin/rails:4:in `&lt;main&gt;&#39;</code></pre>
    </div>
    <div id="Full-Trace" style="display: none;">
      <pre><code>activerecord (4.1.12) lib/active_record/relation/finder_methods.rb:139:in `first!&#39;
app/controllers/home_controller.rb:93:in `newest_by_user&#39;
actionpack (4.1.12) lib/action_controller/metal/implicit_render.rb:4:in `send_action&#39;
actionpack (4.1.12) lib/abstract_controller/base.rb:189:in `process_action&#39;
actionpack (4.1.12) lib/action_controller/metal/rendering.rb:10:in `process_action&#39;
actionpack (4.1.12) lib/abstract_controller/callbacks.rb:20:in `block in process_action&#39;
activesupport (4.1.12) lib/active_support/callbacks.rb:113:in `call&#39;
activesupport (4.1.12) lib/active_support/callbacks.rb:113:in `call&#39;
activesupport (4.1.12) lib/active_support/callbacks.rb:552:in `block (2 levels) in compile&#39;
activesupport (4.1.12) lib/active_support/callbacks.rb:502:in `call&#39;
activesupport (4.1.12) lib/active_support/callbacks.rb:502:in `call&#39;
activesupport (4.1.12) lib/active_support/callbacks.rb:86:in `run_callbacks&#39;
actionpack (4.1.12) lib/abstract_controller/callbacks.rb:19:in `process_action&#39;
actionpack (4.1.12) lib/action_controller/metal/rescue.rb:29:in `process_action&#39;
actionpack (4.1.12) lib/action_controller/metal/instrumentation.rb:32:in `block in process_action&#39;
activesupport (4.1.12) lib/active_support/notifications.rb:159:in `block in instrument&#39;
activesupport (4.1.12) lib/active_support/notifications/instrumenter.rb:20:in `instrument&#39;
activesupport (4.1.12) lib/active_support/notifications.rb:159:in `instrument&#39;
actionpack (4.1.12) lib/action_controller/metal/instrumentation.rb:30:in `process_action&#39;
actionpack (4.1.12) lib/action_controller/metal/params_wrapper.rb:250:in `process_action&#39;
activerecord (4.1.12) lib/active_record/railties/controller_runtime.rb:18:in `process_action&#39;
actionpack (4.1.12) lib/abstract_controller/base.rb:136:in `process&#39;
actionview (4.1.12) lib/action_view/rendering.rb:30:in `process&#39;
actionpack (4.1.12) lib/action_controller/metal.rb:196:in `dispatch&#39;
actionpack (4.1.12) lib/action_controller/metal/rack_delegation.rb:13:in `dispatch&#39;
actionpack (4.1.12) lib/action_controller/metal.rb:232:in `block in action&#39;
actionpack (4.1.12) lib/action_dispatch/routing/route_set.rb:82:in `call&#39;
actionpack (4.1.12) lib/action_dispatch/routing/route_set.rb:82:in `dispatch&#39;
actionpack (4.1.12) lib/action_dispatch/routing/route_set.rb:50:in `call&#39;
actionpack (4.1.12) lib/action_dispatch/journey/router.rb:73:in `block in call&#39;
actionpack (4.1.12) lib/action_dispatch/journey/router.rb:59:in `each&#39;
actionpack (4.1.12) lib/action_dispatch/journey/router.rb:59:in `call&#39;
actionpack (4.1.12) lib/action_dispatch/routing/route_set.rb:692:in `call&#39;
rack (1.5.5) lib/rack/etag.rb:23:in `call&#39;
rack (1.5.5) lib/rack/conditionalget.rb:25:in `call&#39;
rack (1.5.5) lib/rack/head.rb:11:in `call&#39;
actionpack (4.1.12) lib/action_dispatch/middleware/params_parser.rb:27:in `call&#39;
actionpack (4.1.12) lib/action_dispatch/middleware/flash.rb:254:in `call&#39;
rack (1.5.5) lib/rack/session/abstract/id.rb:225:in `context&#39;
rack (1.5.5) lib/rack/session/abstract/id.rb:220:in `call&#39;
actionpack (4.1.12) lib/action_dispatch/middleware/cookies.rb:562:in `call&#39;
activerecord (4.1.12) lib/active_record/query_cache.rb:36:in `call&#39;
activerecord (4.1.12) lib/active_record/connection_adapters/abstract/connection_pool.rb:621:in `call&#39;
activerecord (4.1.12) lib/active_record/migration.rb:380:in `call&#39;
actionpack (4.1.12) lib/action_dispatch/middleware/callbacks.rb:29:in `block in call&#39;
activesupport (4.1.12) lib/active_support/callbacks.rb:82:in `run_callbacks&#39;
actionpack (4.1.12) lib/action_dispatch/middleware/callbacks.rb:27:in `call&#39;
actionpack (4.1.12) lib/action_dispatch/middleware/reloader.rb:73:in `call&#39;
actionpack (4.1.12) lib/action_dispatch/middleware/remote_ip.rb:76:in `call&#39;
actionpack (4.1.12) lib/action_dispatch/middleware/debug_exceptions.rb:17:in `call&#39;
actionpack (4.1.12) lib/action_dispatch/middleware/show_exceptions.rb:30:in `call&#39;
railties (4.1.12) lib/rails/rack/logger.rb:38:in `call_app&#39;
railties (4.1.12) lib/rails/rack/logger.rb:20:in `block in call&#39;
activesupport (4.1.12) lib/active_support/tagged_logging.rb:68:in `block in tagged&#39;
activesupport (4.1.12) lib/active_support/tagged_logging.rb:26:in `tagged&#39;
activesupport (4.1.12) lib/active_support/tagged_logging.rb:68:in `tagged&#39;
railties (4.1.12) lib/rails/rack/logger.rb:20:in `call&#39;
actionpack (4.1.12) lib/action_dispatch/middleware/request_id.rb:21:in `call&#39;
rack (1.5.5) lib/rack/methodoverride.rb:21:in `call&#39;
rack (1.5.5) lib/rack/runtime.rb:17:in `call&#39;
activesupport (4.1.12) lib/active_support/cache/strategy/local_cache_middleware.rb:26:in `call&#39;
rack (1.5.5) lib/rack/lock.rb:17:in `call&#39;
actionpack (4.1.12) lib/action_dispatch/middleware/static.rb:84:in `call&#39;
rack (1.5.5) lib/rack/sendfile.rb:112:in `call&#39;
railties (4.1.12) lib/rails/engine.rb:514:in `call&#39;
railties (4.1.12) lib/rails/application.rb:144:in `call&#39;
rack-test (0.6.3) lib/rack/mock_session.rb:30:in `request&#39;
rack-test (0.6.3) lib/rack/test.rb:244:in `process_request&#39;
rack-test (0.6.3) lib/rack/test.rb:124:in `request&#39;
actionpack (4.1.12) lib/action_dispatch/testing/integration.rb:309:in `process&#39;
actionpack (4.1.12) lib/action_dispatch/testing/integration.rb:32:in `get&#39;
(irb):145:in `block in irb_binding&#39;
(irb):142:in `each&#39;
(irb):142:in `irb_binding&#39;
/home/student/.rvm/rubies/ruby-2.2.1/lib/ruby/2.2.0/irb/workspace.rb:86:in `eval&#39;
/home/student/.rvm/rubies/ruby-2.2.1/lib/ruby/2.2.0/irb/workspace.rb:86:in `evaluate&#39;
/home/student/.rvm/rubies/ruby-2.2.1/lib/ruby/2.2.0/irb/context.rb:379:in `evaluate&#39;
/home/student/.rvm/rubies/ruby-2.2.1/lib/ruby/2.2.0/irb.rb:489:in `block (2 levels) in eval_input&#39;
/home/student/.rvm/rubies/ruby-2.2.1/lib/ruby/2.2.0/irb.rb:623:in `signal_status&#39;
/home/student/.rvm/rubies/ruby-2.2.1/lib/ruby/2.2.0/irb.rb:486:in `block in eval_input&#39;
/home/student/.rvm/rubies/ruby-2.2.1/lib/ruby/2.2.0/irb/ruby-lex.rb:245:in `block (2 levels) in each_top_level_statement&#39;
/home/student/.rvm/rubies/ruby-2.2.1/lib/ruby/2.2.0/irb/ruby-lex.rb:231:in `loop&#39;
/home/student/.rvm/rubies/ruby-2.2.1/lib/ruby/2.2.0/irb/ruby-lex.rb:231:in `block in each_top_level_statement&#39;
/home/student/.rvm/rubies/ruby-2.2.1/lib/ruby/2.2.0/irb/ruby-lex.rb:230:in `catch&#39;
/home/student/.rvm/rubies/ruby-2.2.1/lib/ruby/2.2.0/irb/ruby-lex.rb:230:in `each_top_level_statement&#39;
/home/student/.rvm/rubies/ruby-2.2.1/lib/ruby/2.2.0/irb.rb:485:in `eval_input&#39;
/home/student/.rvm/rubies/ruby-2.2.1/lib/ruby/2.2.0/irb.rb:395:in `block in start&#39;
/home/student/.rvm/rubies/ruby-2.2.1/lib/ruby/2.2.0/irb.rb:394:in `catch&#39;
/home/student/.rvm/rubies/ruby-2.2.1/lib/ruby/2.2.0/irb.rb:394:in `start&#39;
railties (4.1.12) lib/rails/commands/console.rb:90:in `start&#39;
railties (4.1.12) lib/rails/commands/console.rb:9:in `start&#39;
railties (4.1.12) lib/rails/commands/commands_tasks.rb:69:in `console&#39;
railties (4.1.12) lib/rails/commands/commands_tasks.rb:40:in `run_command!&#39;
railties (4.1.12) lib/rails/commands.rb:17:in `&lt;top (required)&gt;&#39;
bin/rails:4:in `require&#39;
bin/rails:4:in `&lt;main&gt;&#39;</code></pre>
    </div>
</div>

  

<h2 style="margin-top: 30px">Request</h2>
<p><b>Parameters</b>:</p> <pre>{&quot;format&quot;=&gt;&quot;html&quot;,
 &quot;user&quot;=&gt;&quot;1&quot;,
 &quot;page&quot;=&gt;&quot;1&quot;}</pre>

<div class="details">
  <div class="summary"><a href="#" onclick="return toggleSessionDump()">Toggle session dump</a></div>
  <div id="session_dump" style="display:none"><pre>session_id: &quot;da6e0190970afce980574def7c8e17d7&quot;
u: &quot;yMvDgquEClagp0qkFWmweNDKPFMLfRYlrUmNEDKS9vYY9ks7SltCng7dvAiw&quot;</pre></div>
</div>

<div class="details">
  <div class="summary"><a href="#" onclick="return toggleEnvDump()">Toggle env dump</a></div>
  <div id="env_dump" style="display:none"><pre>HTTP_ACCEPT: &quot;text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5&quot;
REMOTE_ADDR: &quot;127.0.0.1&quot;
SERVER_NAME: &quot;www.example.com&quot;</pre></div>
</div>

<h2 style="margin-top: 30px">Response</h2>
<p><b>Headers</b>:</p> <pre>None</pre>

</div>


</body>
</html>
