def pandoc file
  File.open("#{file}.html",'w') { |out|
    out.puts %Q{
<html>
<head>
  <link type="text/css" rel="stylesheet" href="lib/style.css">
  <link type="text/css" rel="stylesheet" href="lib/syntaxhighlighter_2.0.296/styles/shCore.css" /> 
	<link type="text/css" rel="stylesheet" href="lib/syntaxhighlighter_2.0.296/styles/shThemeDefault.css" /> 
	<script type="text/javascript" src="lib/jquery-1.3.2.js"></script>
	<script type="text/javascript" src="lib/syntaxhighlighter_2.0.296/scripts/shCore.js"></script>
	<script type="text/javascript" src="lib/syntaxhighlighter_2.0.296/scripts/shBrushJava.js"></script>
	<script type="text/javascript">
		$(document).ready(function(){
		  $("code").addClass("brush: java")
		  SyntaxHighlighter.config.tagName = "code";
			SyntaxHighlighter.all();
    });
	</script> 
</head>
<body>
    }
    lines = []
    run("pandoc markdown-example/#{file}.markdown", "Generating #{file}.html") { |line|
      out.puts line
      print "."
    }
    out.puts %Q{
</body>
</html>
    }
  }
end