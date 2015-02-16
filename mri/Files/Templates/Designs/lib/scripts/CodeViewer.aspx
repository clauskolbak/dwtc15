<%@ Page Language="c#" %>

<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Text.RegularExpressions" %>

<script runat="server">
    string thisUrl = null;

    List<dynamic> snippets = new List<dynamic>();

    public void Page_Load()
    {
        thisUrl = Request.Url.LocalPath;
        try
        {
            var specs = System.Net.WebUtility.UrlDecode(Request.Url.Query.Trim('?')).Split(",".ToCharArray(), StringSplitOptions.RemoveEmptyEntries);
            foreach (var spec in specs)
            {
                var match = Regex.Match(spec, @"^(?<filename>[^\[]+)(?:\[(?<start>[0-9]*)(?:\.{2,}(?<end>[0-9]*))?\])?");
                if (match.Success)
                {
                    var filename = match.Groups["filename"].Value;
                    if (!filename.StartsWith("/Files/Templates/"))
                    {
                        continue;
                    }
                    var type = string.Empty;
                    int start, end;
                    int.TryParse(match.Groups["start"].Value, out start);
                    if (match.Groups["end"].Success)
                    {
                        int.TryParse(match.Groups["end"].Value, out end);
                    }
                    else { end = start; }
                    var extension = System.IO.Path.GetExtension(filename);
                    switch (extension)
                    {
                        case ".cshtml":
                        case ".html":
                            type = "html";
                            break;
                        case ".xml":
                        case ".xslt":
                            type = "xml";
                            break;
                    }
                    IEnumerable<string> lines = System.IO.File.ReadAllText(Server.MapPath(filename)).Replace("\t", "  ").Split('\n').ToList<string>();
                    if (lines != null)
                    {
                        if (start > 0)
                        {
                            start--;
                        }
                        if (start >= 0)
                        {
                            lines = lines.Skip(start);
                        }
                        if (end > start)
                        {
                            lines = lines.Take(end - start);
                        }

                        if (lines.Any())
                        {
                            var prefix = Regex.Match(lines.First(), @"^\s+").Value;
                            if (!string.IsNullOrEmpty(prefix))
                            {
                                lines = lines.Select(line => line.StartsWith(prefix) ? line.Substring(prefix.Length) : line);
                            }
                        }

                        snippets.Add(new
                        {
                            filename = filename,
                            type = type,
                            start = start,
                            end = end,
                            lines = lines
                        });
                    }
                    //end = start + lines.Count()-1;
                }
            }
        }
        catch
        {
            throw;
        }
    }

    string HtmlEncode(string s)
    {
        return System.Net.WebUtility.HtmlEncode(s);
    }
</script>
<!DOCTYPE html>

<html>
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Code viewer</title>
    <link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap.min.css" />
    <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/highlight.js/8.4/styles/default.min.css">
    <style>
        x.snippet h1 {
            font-size: 100%;
        }

        .snippet pre {
            word-break: initial;
            word-wrap: initial;
        }

        .container {
            width: 98%;
            font-size: 16px;
        }

        pre {
            font-size: 22px;
        }
    </style>

    <script src="//cdnjs.cloudflare.com/ajax/libs/highlight.js/8.4/highlight.min.js"></script>
</head>
<body>
    <div class="container">
        <% foreach (var snippet in snippets)
           { %>
        <section class="snippet">
            <header>
                <h1><a href="<%= thisUrl+"?"+snippet.filename %>"><%= snippet.filename %></a></h1>
            </header>

            <pre><code class="<%= snippet.type %>"><%= HtmlEncode(string.Join("\n", snippet.lines)) %></code></pre>
        </section>
        <% } %>

        <script>hljs.initHighlightingOnLoad();</script>
    </div>

    <%-- <script src="https://code.jquery.com/jquery.js"></script> --%>
    <%-- <script src="//netdna.bootstrapcdn.com/bootstrap/3.0.3/js/bootstrap.min.js"></script> --%>
</body>
</html>
