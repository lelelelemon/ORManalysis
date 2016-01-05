<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="content-type" content="text/html; charset=utf-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
  <link rel="apple-touch-icon" sizes="57x57" href="/apple-touch-icon.png" />
  <link rel="apple-touch-icon" sizes="114x114" href="/apple-touch-icon.png" />
  <link rel="apple-touch-icon" sizes="72x72" href="/apple-touch-icon-144.png" />
  <link rel="apple-touch-icon" sizes="144x144" href="/apple-touch-icon-144.png" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <meta name="robots" content="noarchive,noodp,noydir" />
  <meta name="referrer" content="always" />
  <meta name="theme-color" content="#AC130D" />
  <link rel="shortcut icon" href="/favicon.ico" />
  <title>Messages Sent | Example News</title>
  <link href="/assets/select2.self.css?body=1" media="all" rel="stylesheet" />
<link href="/assets/application.self.css?body=1" media="all" rel="stylesheet" />
<link href="/assets/mobile.self.css?body=1" media="all" rel="stylesheet" />
    <script src="/assets/jquery.self.js?body=1"></script>
<script src="/assets/jquery_ujs.self.js?body=1"></script>
<script src="/assets/autosize.self.js?body=1"></script>
<script src="/assets/jquery_class.self.js?body=1"></script>
<script src="/assets/select2.self.js?body=1"></script>
<script src="/assets/application.self.js?body=1"></script>
    <script>
      Lobsters.curUser = '1';
    </script>
  
</head>
<body>
  <div id="wrapper">
    <div id="header">
      <div id="headerleft">
        <a id="l_holder" style="background-color: #390000;" href="/"
        title="Example News (Current traffic: 1)"></a>





        <span class="headerlinks">
            <a href="/" >Home</a>
            <a href="/recent" >Recent</a>
            <a href="/comments" >Comments</a>
            <a href="/threads" >Your Threads</a>
            <a href="/stories/new" >Submit Story</a>
            <a href="/search" >Search</a>
        </span>
      </div>

      <div id="headerright">
        <span class="headerlinks">
        <a href="/filters" >Filters</a>
            <a href="/messages" class="cur_url">Messages</a>

          <a href="/settings" >test
            (0)</a>

          <a data-confirm="Are you sure you want to logout?" data-method="post" href="/logout" rel="nofollow">Logout</a>
        </span>
      </div>

      <div class="clear"></div>
    </div>

    <div id="inside">

      <script>
  $(document).ready(function() {
    $("#delete_all").click(function(e) {
      var table = $(e.target).closest("table");
      $("td input:checkbox", table).attr("checked", e.target.checked);
    });
  });
</script>

<div class="box wide">
  <div class="legend" style="float: right;">
      <a href="/messages">View Received</a>
  </div>
  <div class="legend">
    Private Messages
      Sent
  </div>

    <p>
    You do not have any sent private
      messages.
    </p>

  <br>

  <div class="legend">
    Compose Message
  </div>

  <form accept-charset="UTF-8" action="/messages" class="new_message" id="new_message" method="post"><div style="display:none"><input name="utf8" type="hidden" value="&#x2713;" /></div>
    

    <div class="boxline">
      <label class="required" for="message_recipient_username">To:</label>
      <input autocomplete="off" id="message_recipient_username" name="message[recipient_username]" size="20" type="text" />
    </div>

    <div class="boxline">
      <label class="required" for="message_subject">Subject:</label>
      <input autocomplete="off" id="message_subject" name="message[subject]" style="width: 500px;" type="text" />
    </div>

    <div class="boxline">
      <label class="required" for="message_body">Message:</label>
      <textarea autocomplete="off" id="message_body" name="message[body]" rows="5" style="width: 500px;">
</textarea>
    </div>

    <div class="boxline">
      <p></p>
      <input name="commit" type="submit" value="Send Message" />
    </div>
</form></div>


      <div id="footer">
        <a href="/moderations">Moderation Log</a>
        <a href="/chat">Chat</a>
        <a href="/privacy">Privacy</a>
        <a href="/about">About</a>
      </div>
      <div class="clear"></div>
    </div>
  </div>
</body>
</html>
