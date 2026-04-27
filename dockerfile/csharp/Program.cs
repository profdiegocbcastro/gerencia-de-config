using System.Net;
using System.Text;

var listener = new HttpListener();
listener.Prefixes.Add("http://+:8087/");
listener.Start();

while (true)
{
    var context = await listener.GetContextAsync();
    var request = context.Request;
    var response = context.Response;

    if (request.HttpMethod == "GET" && request.Url?.AbsolutePath == "/")
    {
        var bytes = Encoding.UTF8.GetBytes("Hello World");
        response.StatusCode = 200;
        response.ContentType = "text/plain";
        response.ContentLength64 = bytes.Length;
        await response.OutputStream.WriteAsync(bytes, 0, bytes.Length);
    }
    else
    {
        response.StatusCode = 404;
    }

    response.Close();
}
