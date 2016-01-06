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

      #route_table {
    margin: 0 auto 0;
    border-collapse: collapse;
  }

  #route_table td {
    padding: 0 30px;
  }

  #route_table tr.bottom th {
    padding-bottom: 10px;
    line-height: 15px;
  }

  #route_table .matched_paths {
    background-color: LightGoldenRodYellow;
  }

  #route_table .matched_paths {
    border-bottom: solid 3px SlateGrey;
  }

  #path_search {
    width: 80%;
    font-size: inherit;
  }

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
  <h1>Routing Error</h1>
</header>
<div id="container">
  <h2>No route matches [GET] &quot;/upvoted(.format)&quot;</h2>

  
<p><code>Rails.root: /home/student/ORM/lobsters</code></p>

<div id="traces">
    <a href="#" onclick="hide(&#39;Framework-Trace&#39;);hide(&#39;Full-Trace&#39;);show(&#39;Application-Trace&#39;);; return false;">Application Trace</a> |
    <a href="#" onclick="hide(&#39;Application-Trace&#39;);hide(&#39;Full-Trace&#39;);show(&#39;Framework-Trace&#39;);; return false;">Framework Trace</a> |
    <a href="#" onclick="hide(&#39;Application-Trace&#39;);hide(&#39;Framework-Trace&#39;);show(&#39;Full-Trace&#39;);; return false;">Full Trace</a> 

    <div id="Application-Trace" style="display: block;">
      <pre><code></code></pre>
    </div>
    <div id="Framework-Trace" style="display: none;">
      <pre><code>actionpack (4.1.12) lib/action_dispatch/middleware/debug_exceptions.rb:21:in `call&#39;
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
      <pre><code>actionpack (4.1.12) lib/action_dispatch/middleware/debug_exceptions.rb:21:in `call&#39;
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


    <h2>
      Routes
    </h2>

    <p>
      Routes match in priority from top to bottom
    </p>

    
<table id='route_table' class='route_table'>
  <thead>
    <tr>
      <th>Helper</th>
      <th>HTTP Verb</th>
      <th>Path</th>
      <th>Controller#Action</th>
    </tr>
    <tr class='bottom'>
      <th>
        <a data-route-helper="_path" href="#" title="Returns a relative path (without the http or domain)">Path</a> /
        <a data-route-helper="_url" href="#" title="Returns an absolute url (with the http and domain)">Url</a>
      </th>
      <th>
      </th>
      <th>
        <input id="path_search" name="path[]" placeholder="Path Match" type="search" />
      </th>
      <th>
      </th>
    </tr>
  </thead>
  <tbody class='matched_paths' id='matched_paths'>
  </tbody>
  <tbody>
    <tr class='route_row' data-helper='path'>
  <td data-route-name='root'>
      root<span class='helper'>_path</span>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/' data-regexp='^\/$'>
    /
  </td>
  <td data-route-reqs='home#index {:format=&gt;&quot;html&quot;, :protocol=&gt;&quot;http://&quot;}'>
    home#index {:format=&gt;&quot;html&quot;, :protocol=&gt;&quot;http://&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='rss'>
      rss<span class='helper'>_path</span>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/rss(.:format)' data-regexp='^\/rss(?:\.((rss)))?$'>
    /rss(.:format)
  </td>
  <td data-route-reqs='home#index {:format=&gt;&quot;rss&quot;}'>
    home#index {:format=&gt;&quot;rss&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='hottest'>
      hottest<span class='helper'>_path</span>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/hottest(.:format)' data-regexp='^\/hottest(?:\.((json)))?$'>
    /hottest(.:format)
  </td>
  <td data-route-reqs='home#index {:format=&gt;&quot;json&quot;}'>
    home#index {:format=&gt;&quot;json&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name=''>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/page/:page(.:format)' data-regexp='^\/page\/([^\/.?]+)(?:\.((html)))?$'>
    /page/:page(.:format)
  </td>
  <td data-route-reqs='home#index {:format=&gt;&quot;html&quot;}'>
    home#index {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='newest'>
      newest<span class='helper'>_path</span>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/newest(.:format)' data-regexp='^\/newest(?:\.((html|json|rss)))?$'>
    /newest(.:format)
  </td>
  <td data-route-reqs='home#newest {:format=&gt;nil}'>
    home#newest {:format=&gt;nil}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name=''>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/newest/page/:page(.:format)' data-regexp='^\/newest\/page\/([^\/.?]+)(?:\.((html)))?$'>
    /newest/page/:page(.:format)
  </td>
  <td data-route-reqs='home#newest {:format=&gt;&quot;html&quot;}'>
    home#newest {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name=''>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/newest/:user(.:format)' data-regexp='^\/newest\/([^\/.?]+)(?:\.((html)))?$'>
    /newest/:user(.:format)
  </td>
  <td data-route-reqs='home#newest_by_user {:format=&gt;&quot;html&quot;}'>
    home#newest_by_user {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name=''>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/newest/:user/page/:page(.:format)' data-regexp='^\/newest\/([^\/.?]+)\/page\/([^\/.?]+)(?:\.((html)))?$'>
    /newest/:user/page/:page(.:format)
  </td>
  <td data-route-reqs='home#newest_by_user {:format=&gt;&quot;html&quot;}'>
    home#newest_by_user {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='recent'>
      recent<span class='helper'>_path</span>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/recent(.:format)' data-regexp='^\/recent(?:\.((html)))?$'>
    /recent(.:format)
  </td>
  <td data-route-reqs='home#recent {:format=&gt;&quot;html&quot;}'>
    home#recent {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name=''>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/recent/page/:page(.:format)' data-regexp='^\/recent\/page\/([^\/.?]+)(?:\.((html)))?$'>
    /recent/page/:page(.:format)
  </td>
  <td data-route-reqs='home#recent {:format=&gt;&quot;html&quot;}'>
    home#recent {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='hidden'>
      hidden<span class='helper'>_path</span>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/hidden(.:format)' data-regexp='^\/hidden(?:\.((html)))?$'>
    /hidden(.:format)
  </td>
  <td data-route-reqs='home#hidden {:format=&gt;&quot;html&quot;}'>
    home#hidden {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name=''>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/hidden/page/:page(.:format)' data-regexp='^\/hidden\/page\/([^\/.?]+)(?:\.((html)))?$'>
    /hidden/page/:page(.:format)
  </td>
  <td data-route-reqs='home#hidden {:format=&gt;&quot;html&quot;}'>
    home#hidden {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name=''>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/upvoted(.format)(.:format)' data-regexp='^\/upvoted(?:\.format)?(?:\.((html)))?$'>
    /upvoted(.format)(.:format)
  </td>
  <td data-route-reqs='home#upvoted {:format=&gt;&quot;html&quot;}'>
    home#upvoted {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name=''>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/upvoted/page/:page(.:format)' data-regexp='^\/upvoted\/page\/([^\/.?]+)(?:\.((html)))?$'>
    /upvoted/page/:page(.:format)
  </td>
  <td data-route-reqs='home#upvoted {:format=&gt;&quot;html&quot;}'>
    home#upvoted {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='top'>
      top<span class='helper'>_path</span>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/top(.:format)' data-regexp='^\/top(?:\.((html)))?$'>
    /top(.:format)
  </td>
  <td data-route-reqs='home#top {:format=&gt;&quot;html&quot;}'>
    home#top {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name=''>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/top/page/:page(.:format)' data-regexp='^\/top\/page\/([^\/.?]+)(?:\.((html)))?$'>
    /top/page/:page(.:format)
  </td>
  <td data-route-reqs='home#top {:format=&gt;&quot;html&quot;}'>
    home#top {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name=''>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/top/:length(.:format)' data-regexp='^\/top\/([^\/.?]+)(?:\.((html)))?$'>
    /top/:length(.:format)
  </td>
  <td data-route-reqs='home#top {:format=&gt;&quot;html&quot;}'>
    home#top {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name=''>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/top/:length/page/:page(.:format)' data-regexp='^\/top\/([^\/.?]+)\/page\/([^\/.?]+)(?:\.((html)))?$'>
    /top/:length/page/:page(.:format)
  </td>
  <td data-route-reqs='home#top {:format=&gt;&quot;html&quot;}'>
    home#top {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='threads'>
      threads<span class='helper'>_path</span>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/threads(.:format)' data-regexp='^\/threads(?:\.((html)))?$'>
    /threads(.:format)
  </td>
  <td data-route-reqs='comments#threads {:format=&gt;&quot;html&quot;}'>
    comments#threads {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name=''>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/threads/:user(.:format)' data-regexp='^\/threads\/([^\/.?]+)(?:\.((html)))?$'>
    /threads/:user(.:format)
  </td>
  <td data-route-reqs='comments#threads {:format=&gt;&quot;html&quot;}'>
    comments#threads {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='login'>
      login<span class='helper'>_path</span>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/login(.:format)' data-regexp='^\/login(?:\.((html)))?$'>
    /login(.:format)
  </td>
  <td data-route-reqs='login#index {:format=&gt;&quot;html&quot;}'>
    login#index {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name=''>
  </td>
  <td data-route-verb='POST'>
    POST
  </td>
  <td data-route-path='/login(.:format)' data-regexp='^\/login(?:\.((html)))?$'>
    /login(.:format)
  </td>
  <td data-route-reqs='login#login {:format=&gt;&quot;html&quot;}'>
    login#login {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='logout'>
      logout<span class='helper'>_path</span>
  </td>
  <td data-route-verb='POST'>
    POST
  </td>
  <td data-route-path='/logout(.:format)' data-regexp='^\/logout(?:\.((html)))?$'>
    /logout(.:format)
  </td>
  <td data-route-reqs='login#logout {:format=&gt;&quot;html&quot;}'>
    login#logout {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='signup'>
      signup<span class='helper'>_path</span>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/signup(.:format)' data-regexp='^\/signup(?:\.((html)))?$'>
    /signup(.:format)
  </td>
  <td data-route-reqs='signup#index {:format=&gt;&quot;html&quot;}'>
    signup#index {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name=''>
  </td>
  <td data-route-verb='POST'>
    POST
  </td>
  <td data-route-path='/signup(.:format)' data-regexp='^\/signup(?:\.((html)))?$'>
    /signup(.:format)
  </td>
  <td data-route-reqs='signup#signup {:format=&gt;&quot;html&quot;}'>
    signup#signup {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='signup_invite'>
      signup_invite<span class='helper'>_path</span>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/signup/invite(.:format)' data-regexp='^\/signup\/invite(?:\.((html)))?$'>
    /signup/invite(.:format)
  </td>
  <td data-route-reqs='signup#invite {:format=&gt;&quot;html&quot;}'>
    signup#invite {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='forgot_password'>
      forgot_password<span class='helper'>_path</span>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/login/forgot_password(.:format)' data-regexp='^\/login\/forgot_password(?:\.((html)))?$'>
    /login/forgot_password(.:format)
  </td>
  <td data-route-reqs='login#forgot_password {:format=&gt;&quot;html&quot;}'>
    login#forgot_password {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='reset_password'>
      reset_password<span class='helper'>_path</span>
  </td>
  <td data-route-verb='POST'>
    POST
  </td>
  <td data-route-path='/login/reset_password(.:format)' data-regexp='^\/login\/reset_password(?:\.((html)))?$'>
    /login/reset_password(.:format)
  </td>
  <td data-route-reqs='login#reset_password {:format=&gt;&quot;html&quot;}'>
    login#reset_password {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='set_new_password'>
      set_new_password<span class='helper'>_path</span>
  </td>
  <td data-route-verb='GET|POST'>
    GET|POST
  </td>
  <td data-route-path='/login/set_new_password(.:format)' data-regexp='^\/login\/set_new_password(?:\.((html)))?$'>
    /login/set_new_password(.:format)
  </td>
  <td data-route-reqs='login#set_new_password {:format=&gt;&quot;html&quot;}'>
    login#set_new_password {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='tag'>
      tag<span class='helper'>_path</span>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/t/:tag(.:format)' data-regexp='^\/t\/([^\/.?]+)(?:\.((html|rss|json)))?$'>
    /t/:tag(.:format)
  </td>
  <td data-route-reqs='home#tagged {:format=&gt;nil}'>
    home#tagged {:format=&gt;nil}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name=''>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/t/:tag/page/:page(.:format)' data-regexp='^\/t\/([^\/.?]+)\/page\/([^\/.?]+)(?:\.((html)))?$'>
    /t/:tag/page/:page(.:format)
  </td>
  <td data-route-reqs='home#tagged {:format=&gt;&quot;html&quot;}'>
    home#tagged {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='search'>
      search<span class='helper'>_path</span>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/search(.:format)' data-regexp='^\/search(?:\.((html)))?$'>
    /search(.:format)
  </td>
  <td data-route-reqs='search#index {:format=&gt;&quot;html&quot;}'>
    search#index {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name=''>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/search/:q(.:format)' data-regexp='^\/search\/([^\/.?]+)(?:\.((html)))?$'>
    /search/:q(.:format)
  </td>
  <td data-route-reqs='search#index {:format=&gt;&quot;html&quot;}'>
    search#index {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='story_upvote'>
      story_upvote<span class='helper'>_path</span>
  </td>
  <td data-route-verb='POST'>
    POST
  </td>
  <td data-route-path='/stories/:story_id/upvote(.:format)' data-regexp='^\/stories\/([^\/.?]+)\/upvote(?:\.((html)))?$'>
    /stories/:story_id/upvote(.:format)
  </td>
  <td data-route-reqs='stories#upvote {:format=&gt;&quot;html&quot;}'>
    stories#upvote {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='story_downvote'>
      story_downvote<span class='helper'>_path</span>
  </td>
  <td data-route-verb='POST'>
    POST
  </td>
  <td data-route-path='/stories/:story_id/downvote(.:format)' data-regexp='^\/stories\/([^\/.?]+)\/downvote(?:\.((html)))?$'>
    /stories/:story_id/downvote(.:format)
  </td>
  <td data-route-reqs='stories#downvote {:format=&gt;&quot;html&quot;}'>
    stories#downvote {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='story_unvote'>
      story_unvote<span class='helper'>_path</span>
  </td>
  <td data-route-verb='POST'>
    POST
  </td>
  <td data-route-path='/stories/:story_id/unvote(.:format)' data-regexp='^\/stories\/([^\/.?]+)\/unvote(?:\.((html)))?$'>
    /stories/:story_id/unvote(.:format)
  </td>
  <td data-route-reqs='stories#unvote {:format=&gt;&quot;html&quot;}'>
    stories#unvote {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='story_undelete'>
      story_undelete<span class='helper'>_path</span>
  </td>
  <td data-route-verb='POST'>
    POST
  </td>
  <td data-route-path='/stories/:story_id/undelete(.:format)' data-regexp='^\/stories\/([^\/.?]+)\/undelete(?:\.((html)))?$'>
    /stories/:story_id/undelete(.:format)
  </td>
  <td data-route-reqs='stories#undelete {:format=&gt;&quot;html&quot;}'>
    stories#undelete {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='story_hide'>
      story_hide<span class='helper'>_path</span>
  </td>
  <td data-route-verb='POST'>
    POST
  </td>
  <td data-route-path='/stories/:story_id/hide(.:format)' data-regexp='^\/stories\/([^\/.?]+)\/hide(?:\.((html)))?$'>
    /stories/:story_id/hide(.:format)
  </td>
  <td data-route-reqs='stories#hide {:format=&gt;&quot;html&quot;}'>
    stories#hide {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='story_unhide'>
      story_unhide<span class='helper'>_path</span>
  </td>
  <td data-route-verb='POST'>
    POST
  </td>
  <td data-route-path='/stories/:story_id/unhide(.:format)' data-regexp='^\/stories\/([^\/.?]+)\/unhide(?:\.((html)))?$'>
    /stories/:story_id/unhide(.:format)
  </td>
  <td data-route-reqs='stories#unhide {:format=&gt;&quot;html&quot;}'>
    stories#unhide {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='story_suggest'>
      story_suggest<span class='helper'>_path</span>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/stories/:story_id/suggest(.:format)' data-regexp='^\/stories\/([^\/.?]+)\/suggest(?:\.((html)))?$'>
    /stories/:story_id/suggest(.:format)
  </td>
  <td data-route-reqs='stories#suggest {:format=&gt;&quot;html&quot;}'>
    stories#suggest {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name=''>
  </td>
  <td data-route-verb='POST'>
    POST
  </td>
  <td data-route-path='/stories/:story_id/suggest(.:format)' data-regexp='^\/stories\/([^\/.?]+)\/suggest(?:\.((html)))?$'>
    /stories/:story_id/suggest(.:format)
  </td>
  <td data-route-reqs='stories#submit_suggestions {:format=&gt;&quot;html&quot;}'>
    stories#submit_suggestions {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='stories'>
      stories<span class='helper'>_path</span>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/stories(.:format)' data-regexp='^\/stories(?:\.((html)))?$'>
    /stories(.:format)
  </td>
  <td data-route-reqs='stories#index {:format=&gt;&quot;html&quot;}'>
    stories#index {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name=''>
  </td>
  <td data-route-verb='POST'>
    POST
  </td>
  <td data-route-path='/stories(.:format)' data-regexp='^\/stories(?:\.((html)))?$'>
    /stories(.:format)
  </td>
  <td data-route-reqs='stories#create {:format=&gt;&quot;html&quot;}'>
    stories#create {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='new_story'>
      new_story<span class='helper'>_path</span>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/stories/new(.:format)' data-regexp='^\/stories\/new(?:\.((html)))?$'>
    /stories/new(.:format)
  </td>
  <td data-route-reqs='stories#new {:format=&gt;&quot;html&quot;}'>
    stories#new {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='edit_story'>
      edit_story<span class='helper'>_path</span>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/stories/:id/edit(.:format)' data-regexp='^\/stories\/([^\/.?]+)\/edit(?:\.((html)))?$'>
    /stories/:id/edit(.:format)
  </td>
  <td data-route-reqs='stories#edit {:format=&gt;&quot;html&quot;}'>
    stories#edit {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='story'>
      story<span class='helper'>_path</span>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/stories/:id(.:format)' data-regexp='^\/stories\/([^\/.?]+)(?:\.((html)))?$'>
    /stories/:id(.:format)
  </td>
  <td data-route-reqs='stories#show {:format=&gt;&quot;html&quot;}'>
    stories#show {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name=''>
  </td>
  <td data-route-verb='PATCH'>
    PATCH
  </td>
  <td data-route-path='/stories/:id(.:format)' data-regexp='^\/stories\/([^\/.?]+)(?:\.((html)))?$'>
    /stories/:id(.:format)
  </td>
  <td data-route-reqs='stories#update {:format=&gt;&quot;html&quot;}'>
    stories#update {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name=''>
  </td>
  <td data-route-verb='PUT'>
    PUT
  </td>
  <td data-route-path='/stories/:id(.:format)' data-regexp='^\/stories\/([^\/.?]+)(?:\.((html)))?$'>
    /stories/:id(.:format)
  </td>
  <td data-route-reqs='stories#update {:format=&gt;&quot;html&quot;}'>
    stories#update {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name=''>
  </td>
  <td data-route-verb='DELETE'>
    DELETE
  </td>
  <td data-route-path='/stories/:id(.:format)' data-regexp='^\/stories\/([^\/.?]+)(?:\.((html)))?$'>
    /stories/:id(.:format)
  </td>
  <td data-route-reqs='stories#destroy {:format=&gt;&quot;html&quot;}'>
    stories#destroy {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='stories_fetch_url_attributes'>
      stories_fetch_url_attributes<span class='helper'>_path</span>
  </td>
  <td data-route-verb='POST'>
    POST
  </td>
  <td data-route-path='/stories/fetch_url_attributes(.:format)' data-regexp='^\/stories\/fetch_url_attributes(?:\.((json)))?$'>
    /stories/fetch_url_attributes(.:format)
  </td>
  <td data-route-reqs='stories#fetch_url_attributes {:format=&gt;&quot;json&quot;}'>
    stories#fetch_url_attributes {:format=&gt;&quot;json&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='stories_preview'>
      stories_preview<span class='helper'>_path</span>
  </td>
  <td data-route-verb='POST'>
    POST
  </td>
  <td data-route-path='/stories/preview(.:format)' data-regexp='^\/stories\/preview(?:\.((html)))?$'>
    /stories/preview(.:format)
  </td>
  <td data-route-reqs='stories#preview {:format=&gt;&quot;html&quot;}'>
    stories#preview {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='reply_comment'>
      reply_comment<span class='helper'>_path</span>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/comments/:id/reply(.:format)' data-regexp='^\/comments\/([^\/.?]+)\/reply(?:\.((html)))?$'>
    /comments/:id/reply(.:format)
  </td>
  <td data-route-reqs='comments#reply {:format=&gt;&quot;html&quot;}'>
    comments#reply {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='upvote_comment'>
      upvote_comment<span class='helper'>_path</span>
  </td>
  <td data-route-verb='POST'>
    POST
  </td>
  <td data-route-path='/comments/:id/upvote(.:format)' data-regexp='^\/comments\/([^\/.?]+)\/upvote(?:\.((html)))?$'>
    /comments/:id/upvote(.:format)
  </td>
  <td data-route-reqs='comments#upvote {:format=&gt;&quot;html&quot;}'>
    comments#upvote {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='downvote_comment'>
      downvote_comment<span class='helper'>_path</span>
  </td>
  <td data-route-verb='POST'>
    POST
  </td>
  <td data-route-path='/comments/:id/downvote(.:format)' data-regexp='^\/comments\/([^\/.?]+)\/downvote(?:\.((html)))?$'>
    /comments/:id/downvote(.:format)
  </td>
  <td data-route-reqs='comments#downvote {:format=&gt;&quot;html&quot;}'>
    comments#downvote {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='unvote_comment'>
      unvote_comment<span class='helper'>_path</span>
  </td>
  <td data-route-verb='POST'>
    POST
  </td>
  <td data-route-path='/comments/:id/unvote(.:format)' data-regexp='^\/comments\/([^\/.?]+)\/unvote(?:\.((html)))?$'>
    /comments/:id/unvote(.:format)
  </td>
  <td data-route-reqs='comments#unvote {:format=&gt;&quot;html&quot;}'>
    comments#unvote {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='delete_comment'>
      delete_comment<span class='helper'>_path</span>
  </td>
  <td data-route-verb='POST'>
    POST
  </td>
  <td data-route-path='/comments/:id/delete(.:format)' data-regexp='^\/comments\/([^\/.?]+)\/delete(?:\.((html)))?$'>
    /comments/:id/delete(.:format)
  </td>
  <td data-route-reqs='comments#delete {:format=&gt;&quot;html&quot;}'>
    comments#delete {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='undelete_comment'>
      undelete_comment<span class='helper'>_path</span>
  </td>
  <td data-route-verb='POST'>
    POST
  </td>
  <td data-route-path='/comments/:id/undelete(.:format)' data-regexp='^\/comments\/([^\/.?]+)\/undelete(?:\.((html)))?$'>
    /comments/:id/undelete(.:format)
  </td>
  <td data-route-reqs='comments#undelete {:format=&gt;&quot;html&quot;}'>
    comments#undelete {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='comments'>
      comments<span class='helper'>_path</span>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/comments(.:format)' data-regexp='^\/comments(?:\.((html)))?$'>
    /comments(.:format)
  </td>
  <td data-route-reqs='comments#index {:format=&gt;&quot;html&quot;}'>
    comments#index {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name=''>
  </td>
  <td data-route-verb='POST'>
    POST
  </td>
  <td data-route-path='/comments(.:format)' data-regexp='^\/comments(?:\.((html)))?$'>
    /comments(.:format)
  </td>
  <td data-route-reqs='comments#create {:format=&gt;&quot;html&quot;}'>
    comments#create {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='new_comment'>
      new_comment<span class='helper'>_path</span>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/comments/new(.:format)' data-regexp='^\/comments\/new(?:\.((html)))?$'>
    /comments/new(.:format)
  </td>
  <td data-route-reqs='comments#new {:format=&gt;&quot;html&quot;}'>
    comments#new {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='edit_comment'>
      edit_comment<span class='helper'>_path</span>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/comments/:id/edit(.:format)' data-regexp='^\/comments\/([^\/.?]+)\/edit(?:\.((html)))?$'>
    /comments/:id/edit(.:format)
  </td>
  <td data-route-reqs='comments#edit {:format=&gt;&quot;html&quot;}'>
    comments#edit {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='comment'>
      comment<span class='helper'>_path</span>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/comments/:id(.:format)' data-regexp='^\/comments\/([^\/.?]+)(?:\.((html)))?$'>
    /comments/:id(.:format)
  </td>
  <td data-route-reqs='comments#show {:format=&gt;&quot;html&quot;}'>
    comments#show {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name=''>
  </td>
  <td data-route-verb='PATCH'>
    PATCH
  </td>
  <td data-route-path='/comments/:id(.:format)' data-regexp='^\/comments\/([^\/.?]+)(?:\.((html)))?$'>
    /comments/:id(.:format)
  </td>
  <td data-route-reqs='comments#update {:format=&gt;&quot;html&quot;}'>
    comments#update {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name=''>
  </td>
  <td data-route-verb='PUT'>
    PUT
  </td>
  <td data-route-path='/comments/:id(.:format)' data-regexp='^\/comments\/([^\/.?]+)(?:\.((html)))?$'>
    /comments/:id(.:format)
  </td>
  <td data-route-reqs='comments#update {:format=&gt;&quot;html&quot;}'>
    comments#update {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name=''>
  </td>
  <td data-route-verb='DELETE'>
    DELETE
  </td>
  <td data-route-path='/comments/:id(.:format)' data-regexp='^\/comments\/([^\/.?]+)(?:\.((html)))?$'>
    /comments/:id(.:format)
  </td>
  <td data-route-reqs='comments#destroy {:format=&gt;&quot;html&quot;}'>
    comments#destroy {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name=''>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/comments/page/:page(.:format)' data-regexp='^\/comments\/page\/([^\/.?]+)(?:\.((html)))?$'>
    /comments/page/:page(.:format)
  </td>
  <td data-route-reqs='comments#index {:format=&gt;&quot;html&quot;}'>
    comments#index {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name=''>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/comments(.:format)' data-regexp='^\/comments(?:\.((html|rss)))?$'>
    /comments(.:format)
  </td>
  <td data-route-reqs='comments#index {:format=&gt;nil}'>
    comments#index {:format=&gt;nil}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='messages_sent'>
      messages_sent<span class='helper'>_path</span>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/messages/sent(.:format)' data-regexp='^\/messages\/sent(?:\.((html)))?$'>
    /messages/sent(.:format)
  </td>
  <td data-route-reqs='messages#sent {:format=&gt;&quot;html&quot;}'>
    messages#sent {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='batch_delete_messages'>
      batch_delete_messages<span class='helper'>_path</span>
  </td>
  <td data-route-verb='POST'>
    POST
  </td>
  <td data-route-path='/messages/batch_delete(.:format)' data-regexp='^\/messages\/batch_delete(?:\.((html)))?$'>
    /messages/batch_delete(.:format)
  </td>
  <td data-route-reqs='messages#batch_delete {:format=&gt;&quot;html&quot;}'>
    messages#batch_delete {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='message_keep_as_new'>
      message_keep_as_new<span class='helper'>_path</span>
  </td>
  <td data-route-verb='POST'>
    POST
  </td>
  <td data-route-path='/messages/:message_id/keep_as_new(.:format)' data-regexp='^\/messages\/([^\/.?]+)\/keep_as_new(?:\.((html)))?$'>
    /messages/:message_id/keep_as_new(.:format)
  </td>
  <td data-route-reqs='messages#keep_as_new {:format=&gt;&quot;html&quot;}'>
    messages#keep_as_new {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='messages'>
      messages<span class='helper'>_path</span>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/messages(.:format)' data-regexp='^\/messages(?:\.((html)))?$'>
    /messages(.:format)
  </td>
  <td data-route-reqs='messages#index {:format=&gt;&quot;html&quot;}'>
    messages#index {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name=''>
  </td>
  <td data-route-verb='POST'>
    POST
  </td>
  <td data-route-path='/messages(.:format)' data-regexp='^\/messages(?:\.((html)))?$'>
    /messages(.:format)
  </td>
  <td data-route-reqs='messages#create {:format=&gt;&quot;html&quot;}'>
    messages#create {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='new_message'>
      new_message<span class='helper'>_path</span>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/messages/new(.:format)' data-regexp='^\/messages\/new(?:\.((html)))?$'>
    /messages/new(.:format)
  </td>
  <td data-route-reqs='messages#new {:format=&gt;&quot;html&quot;}'>
    messages#new {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='edit_message'>
      edit_message<span class='helper'>_path</span>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/messages/:id/edit(.:format)' data-regexp='^\/messages\/([^\/.?]+)\/edit(?:\.((html)))?$'>
    /messages/:id/edit(.:format)
  </td>
  <td data-route-reqs='messages#edit {:format=&gt;&quot;html&quot;}'>
    messages#edit {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='message'>
      message<span class='helper'>_path</span>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/messages/:id(.:format)' data-regexp='^\/messages\/([^\/.?]+)(?:\.((html)))?$'>
    /messages/:id(.:format)
  </td>
  <td data-route-reqs='messages#show {:format=&gt;&quot;html&quot;}'>
    messages#show {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name=''>
  </td>
  <td data-route-verb='PATCH'>
    PATCH
  </td>
  <td data-route-path='/messages/:id(.:format)' data-regexp='^\/messages\/([^\/.?]+)(?:\.((html)))?$'>
    /messages/:id(.:format)
  </td>
  <td data-route-reqs='messages#update {:format=&gt;&quot;html&quot;}'>
    messages#update {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name=''>
  </td>
  <td data-route-verb='PUT'>
    PUT
  </td>
  <td data-route-path='/messages/:id(.:format)' data-regexp='^\/messages\/([^\/.?]+)(?:\.((html)))?$'>
    /messages/:id(.:format)
  </td>
  <td data-route-reqs='messages#update {:format=&gt;&quot;html&quot;}'>
    messages#update {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name=''>
  </td>
  <td data-route-verb='DELETE'>
    DELETE
  </td>
  <td data-route-path='/messages/:id(.:format)' data-regexp='^\/messages\/([^\/.?]+)(?:\.((html)))?$'>
    /messages/:id(.:format)
  </td>
  <td data-route-reqs='messages#destroy {:format=&gt;&quot;html&quot;}'>
    messages#destroy {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name=''>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/s/:id/:title/comments/:comment_short_id(.:format)' data-regexp='^\/s\/([^\/.?]+)\/([^\/.?]+)\/comments\/([^\/.?]+)(?:\.((html)))?$'>
    /s/:id/:title/comments/:comment_short_id(.:format)
  </td>
  <td data-route-reqs='stories#show {:format=&gt;&quot;html&quot;}'>
    stories#show {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name=''>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/s/:id(/:title)(.:format)' data-regexp='^\/s\/([^\/.?]+)(?:\/([^\/.?]+))?(?:\.((html|json)))?$'>
    /s/:id(/:title)(.:format)
  </td>
  <td data-route-reqs='stories#show {:format=&gt;nil}'>
    stories#show {:format=&gt;nil}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name=''>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/c/:id(.:format)' data-regexp='^\/c\/([^\/.?]+)(?:\.((html)))?$'>
    /c/:id(.:format)
  </td>
  <td data-route-reqs='comments#redirect_from_short_id {:format=&gt;&quot;html&quot;}'>
    comments#redirect_from_short_id {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name=''>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/c/:id.json(.:format)' data-regexp='^\/c\/([^\/.?]+)\.json(?:\.((json)))?$'>
    /c/:id.json(.:format)
  </td>
  <td data-route-reqs='comments#show_short_id {:format=&gt;&quot;json&quot;}'>
    comments#show_short_id {:format=&gt;&quot;json&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='u'>
      u<span class='helper'>_path</span>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/u(.:format)' data-regexp='^\/u(?:\.((html)))?$'>
    /u(.:format)
  </td>
  <td data-route-reqs='users#tree {:format=&gt;&quot;html&quot;}'>
    users#tree {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='user'>
      user<span class='helper'>_path</span>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/u/:username(.:format)' data-regexp='^\/u\/([^\/.?]+)(?:\.((html|json)))?$'>
    /u/:username(.:format)
  </td>
  <td data-route-reqs='users#show {:format=&gt;nil}'>
    users#show {:format=&gt;nil}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='user_ban'>
      user_ban<span class='helper'>_path</span>
  </td>
  <td data-route-verb='POST'>
    POST
  </td>
  <td data-route-path='/users/:username/ban(.:format)' data-regexp='^\/users\/([^\/.?]+)\/ban(?:\.((html)))?$'>
    /users/:username/ban(.:format)
  </td>
  <td data-route-reqs='users#ban {:format=&gt;&quot;html&quot;}'>
    users#ban {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='user_unban'>
      user_unban<span class='helper'>_path</span>
  </td>
  <td data-route-verb='POST'>
    POST
  </td>
  <td data-route-path='/users/:username/unban(.:format)' data-regexp='^\/users\/([^\/.?]+)\/unban(?:\.((html)))?$'>
    /users/:username/unban(.:format)
  </td>
  <td data-route-reqs='users#unban {:format=&gt;&quot;html&quot;}'>
    users#unban {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='settings'>
      settings<span class='helper'>_path</span>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/settings(.:format)' data-regexp='^\/settings(?:\.((html)))?$'>
    /settings(.:format)
  </td>
  <td data-route-reqs='settings#index {:format=&gt;&quot;html&quot;}'>
    settings#index {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name=''>
  </td>
  <td data-route-verb='POST'>
    POST
  </td>
  <td data-route-path='/settings(.:format)' data-regexp='^\/settings(?:\.((html)))?$'>
    /settings(.:format)
  </td>
  <td data-route-reqs='settings#update {:format=&gt;&quot;html&quot;}'>
    settings#update {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='settings_pushover'>
      settings_pushover<span class='helper'>_path</span>
  </td>
  <td data-route-verb='POST'>
    POST
  </td>
  <td data-route-path='/settings/pushover(.:format)' data-regexp='^\/settings\/pushover(?:\.((html)))?$'>
    /settings/pushover(.:format)
  </td>
  <td data-route-reqs='settings#pushover {:format=&gt;&quot;html&quot;}'>
    settings#pushover {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='settings_pushover_callback'>
      settings_pushover_callback<span class='helper'>_path</span>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/settings/pushover_callback(.:format)' data-regexp='^\/settings\/pushover_callback(?:\.((html)))?$'>
    /settings/pushover_callback(.:format)
  </td>
  <td data-route-reqs='settings#pushover_callback {:format=&gt;&quot;html&quot;}'>
    settings#pushover_callback {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='delete_account'>
      delete_account<span class='helper'>_path</span>
  </td>
  <td data-route-verb='POST'>
    POST
  </td>
  <td data-route-path='/settings/delete_account(.:format)' data-regexp='^\/settings\/delete_account(?:\.((html)))?$'>
    /settings/delete_account(.:format)
  </td>
  <td data-route-reqs='settings#delete_account {:format=&gt;&quot;html&quot;}'>
    settings#delete_account {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='filters'>
      filters<span class='helper'>_path</span>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/filters(.:format)' data-regexp='^\/filters(?:\.((html)))?$'>
    /filters(.:format)
  </td>
  <td data-route-reqs='filters#index {:format=&gt;&quot;html&quot;}'>
    filters#index {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name=''>
  </td>
  <td data-route-verb='POST'>
    POST
  </td>
  <td data-route-path='/filters(.:format)' data-regexp='^\/filters(?:\.((html)))?$'>
    /filters(.:format)
  </td>
  <td data-route-reqs='filters#update {:format=&gt;&quot;html&quot;}'>
    filters#update {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='tags'>
      tags<span class='helper'>_path</span>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/tags(.:format)' data-regexp='^\/tags(?:\.((html)))?$'>
    /tags(.:format)
  </td>
  <td data-route-reqs='tags#index {:format=&gt;&quot;html&quot;}'>
    tags#index {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name=''>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/tags.json(.:format)' data-regexp='^\/tags\.json(?:\.((json)))?$'>
    /tags.json(.:format)
  </td>
  <td data-route-reqs='tags#index {:format=&gt;&quot;json&quot;}'>
    tags#index {:format=&gt;&quot;json&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='invitations'>
      invitations<span class='helper'>_path</span>
  </td>
  <td data-route-verb='POST'>
    POST
  </td>
  <td data-route-path='/invitations(.:format)' data-regexp='^\/invitations(?:\.((html)))?$'>
    /invitations(.:format)
  </td>
  <td data-route-reqs='invitations#create {:format=&gt;&quot;html&quot;}'>
    invitations#create {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name=''>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/invitations(.:format)' data-regexp='^\/invitations(?:\.((html)))?$'>
    /invitations(.:format)
  </td>
  <td data-route-reqs='invitations#index {:format=&gt;&quot;html&quot;}'>
    invitations#index {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='invitations_request'>
      invitations_request<span class='helper'>_path</span>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/invitations/request(.:format)' data-regexp='^\/invitations\/request(?:\.((html)))?$'>
    /invitations/request(.:format)
  </td>
  <td data-route-reqs='invitations#build {:format=&gt;&quot;html&quot;}'>
    invitations#build {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='create_invitation_by_request'>
      create_invitation_by_request<span class='helper'>_path</span>
  </td>
  <td data-route-verb='POST'>
    POST
  </td>
  <td data-route-path='/invitations/create_by_request(.:format)' data-regexp='^\/invitations\/create_by_request(?:\.((html)))?$'>
    /invitations/create_by_request(.:format)
  </td>
  <td data-route-reqs='invitations#create_by_request {:format=&gt;&quot;html&quot;}'>
    invitations#create_by_request {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name=''>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/invitations/confirm/:code(.:format)' data-regexp='^\/invitations\/confirm\/([^\/.?]+)(?:\.((html)))?$'>
    /invitations/confirm/:code(.:format)
  </td>
  <td data-route-reqs='invitations#confirm_email {:format=&gt;&quot;html&quot;}'>
    invitations#confirm_email {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='send_invitation_for_request'>
      send_invitation_for_request<span class='helper'>_path</span>
  </td>
  <td data-route-verb='POST'>
    POST
  </td>
  <td data-route-path='/invitations/send_for_request(.:format)' data-regexp='^\/invitations\/send_for_request(?:\.((html)))?$'>
    /invitations/send_for_request(.:format)
  </td>
  <td data-route-reqs='invitations#send_for_request {:format=&gt;&quot;html&quot;}'>
    invitations#send_for_request {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name=''>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/invitations/:invitation_code(.:format)' data-regexp='^\/invitations\/([^\/.?]+)(?:\.((html)))?$'>
    /invitations/:invitation_code(.:format)
  </td>
  <td data-route-reqs='signup#invited {:format=&gt;&quot;html&quot;}'>
    signup#invited {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='delete_invitation_request'>
      delete_invitation_request<span class='helper'>_path</span>
  </td>
  <td data-route-verb='POST'>
    POST
  </td>
  <td data-route-path='/invitations/delete_request(.:format)' data-regexp='^\/invitations\/delete_request(?:\.((html)))?$'>
    /invitations/delete_request(.:format)
  </td>
  <td data-route-reqs='invitations#delete_request {:format=&gt;&quot;html&quot;}'>
    invitations#delete_request {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='moderations'>
      moderations<span class='helper'>_path</span>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/moderations(.:format)' data-regexp='^\/moderations(?:\.((html)))?$'>
    /moderations(.:format)
  </td>
  <td data-route-reqs='moderations#index {:format=&gt;&quot;html&quot;}'>
    moderations#index {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name=''>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/moderations/page/:page(.:format)' data-regexp='^\/moderations\/page\/([^\/.?]+)(?:\.((html)))?$'>
    /moderations/page/:page(.:format)
  </td>
  <td data-route-reqs='moderations#index {:format=&gt;&quot;html&quot;}'>
    moderations#index {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='privacy'>
      privacy<span class='helper'>_path</span>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/privacy(.:format)' data-regexp='^\/privacy(?:\.((html)))?$'>
    /privacy(.:format)
  </td>
  <td data-route-reqs='home#privacy {:format=&gt;&quot;html&quot;}'>
    home#privacy {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='about'>
      about<span class='helper'>_path</span>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/about(.:format)' data-regexp='^\/about(?:\.((html)))?$'>
    /about(.:format)
  </td>
  <td data-route-reqs='home#about {:format=&gt;&quot;html&quot;}'>
    home#about {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='chat'>
      chat<span class='helper'>_path</span>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/chat(.:format)' data-regexp='^\/chat(?:\.((html)))?$'>
    /chat(.:format)
  </td>
  <td data-route-reqs='home#chat {:format=&gt;&quot;html&quot;}'>
    home#chat {:format=&gt;&quot;html&quot;}
  </td>
</tr>
<tr class='route_row' data-helper='path'>
  <td data-route-name='bbs'>
      bbs<span class='helper'>_path</span>
  </td>
  <td data-route-verb='GET'>
    GET
  </td>
  <td data-route-path='/bbs(.:format)' data-regexp='^\/bbs(?:\.((html)))?$'>
    /bbs(.:format)
  </td>
  <td data-route-reqs='bbs#index {:format=&gt;&quot;html&quot;}'>
    bbs#index {:format=&gt;&quot;html&quot;}
  </td>
</tr>

  </tbody>
</table>

<script type='text/javascript'>
  function each(elems, func) {
    if (!elems instanceof Array) { elems = [elems]; }
    for (var i = 0, len = elems.length; i < len; i++) {
      func(elems[i]);
    }
  }

  function setValOn(elems, val) {
    each(elems, function(elem) {
      elem.innerHTML = val;
    });
  }

  function onClick(elems, func) {
    each(elems, function(elem) {
      elem.onclick = func;
    });
  }

  // Enables functionality to toggle between `_path` and `_url` helper suffixes
  function setupRouteToggleHelperLinks() {
    var toggleLinks = document.querySelectorAll('#route_table [data-route-helper]');
    onClick(toggleLinks, function(){
      var helperTxt   = this.getAttribute("data-route-helper"),
          helperElems = document.querySelectorAll('[data-route-name] span.helper');
      setValOn(helperElems, helperTxt);
    });
  }

  // takes an array of elements with a data-regexp attribute and
  // passes their parent <tr> into the callback function
  // if the regexp matches a given path
  function eachElemsForPath(elems, path, func) {
    each(elems, function(e){
      var reg = e.getAttribute("data-regexp");
      if (path.match(RegExp(reg))) {
        func(e.parentNode.cloneNode(true));
      }
    })
  }

  // Ensure path always starts with a slash "/" and remove params or fragments
  function sanitizePath(path) {
    var path = path.charAt(0) == '/' ? path : "/" + path;
    return path.replace(/\#.*|\?.*/, '');
  }

  // Enables path search functionality
  function setupMatchPaths() {
    var regexpElems     = document.querySelectorAll('#route_table [data-regexp]'),
        pathElem        = document.querySelector('#path_search'),
        selectedSection = document.querySelector('#matched_paths'),
        noMatchText     = '<tr><th colspan="4">None</th></tr>';


    // Remove matches if no path is present
    pathElem.onblur = function(e) {
      if (pathElem.value === "") selectedSection.innerHTML = "";
    }

    // On key press perform a search for matching paths
    pathElem.onkeyup = function(e){
      var path        = sanitizePath(pathElem.value),
          defaultText = '<tr><th colspan="4">Paths Matching (' + escape(path) + '):</th></tr>';

      // Clear out results section
      selectedSection.innerHTML= defaultText;

      // Display matches if they exist
      eachElemsForPath(regexpElems, path, function(e){
        selectedSection.appendChild(e);
      });

      // If no match present, tell the user
      if (selectedSection.innerHTML === defaultText) {
        selectedSection.innerHTML = selectedSection.innerHTML + noMatchText;
      }
    }
  }

  setupMatchPaths();
  setupRouteToggleHelperLinks();
</script>

</div>


</body>
</html>