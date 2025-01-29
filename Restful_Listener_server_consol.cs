using System;
using System.IO;
using System.Net;
using System.Text;
using System.Threading.Tasks;

class Program
{
    static async Task Main(string[] args)
    {
        HttpListener listener = new HttpListener();
        listener.Prefixes.Add("http://localhost:5000/");
        listener.Start();
        Console.WriteLine("HTTP Server started on http://localhost:5000/");

        while (true)
        {
            // 요청 대기
            var context = await listener.GetContextAsync();
            var request = context.Request;
            var response = context.Response;

            string responseString;

            if (request.HttpMethod == "GET" && request.Url.AbsolutePath == "/api/data")
            {
                // GET 요청 처리
                responseString = "[\"Sample Data 1\", \"Sample Data 2\"]";
                response.StatusCode = (int)HttpStatusCode.OK;
            }
            else if (request.HttpMethod == "POST" && request.Url.AbsolutePath == "/api/data")
            {
                // POST 요청 처리
                using (var reader = new StreamReader(request.InputStream, request.ContentEncoding))
                {
                    string requestData = await reader.ReadToEndAsync();
                    Console.WriteLine($"Received data: {requestData}");
                    responseString = "{\"message\": \"Data received successfully\", \"data\": " + requestData + "}";
                }
                response.StatusCode = (int)HttpStatusCode.OK;
            }
            else
            {
                // 기타 요청 처리
                responseString = "{\"message\": \"Not Found\"}";
                response.StatusCode = (int)HttpStatusCode.NotFound;
            }

            // 응답 전송
            byte[] buffer = Encoding.UTF8.GetBytes(responseString);
            response.ContentLength64 = buffer.Length;
            response.OutputStream.Write(buffer, 0, buffer.Length);
            response.Close();
        }
    }
}
