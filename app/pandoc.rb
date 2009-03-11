def pandoc m, h
  FileUtils.mkdir_p(File.dirname(h))
  File.open(h,'w') { |out|
    out.puts %Q{
<html>
<head>
  <link type="text/css" rel="stylesheet" href="assets/style.css">
  <link type="text/css" rel="stylesheet" href="assets/syntaxhighlighter_2.0.296/styles/shCore.css" /> 
	<link type="text/css" rel="stylesheet" href="assets/syntaxhighlighter_2.0.296/styles/shThemeDefault.css" /> 
	<script type="text/javascript" src="assets/jquery-1.3.2.js"></script>
	<script type="text/javascript" src="assets/syntaxhighlighter_2.0.296/scripts/shCore.js"></script>
	<script type="text/javascript" src="assets/syntaxhighlighter_2.0.296/scripts/shBrushJava.js"></script>
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
    run("pandoc #{m}", "Generating #{h}") { |line|
      out.puts line
      print "."
    }
    out.puts %Q{
</body>
</html>
    }
  }
end