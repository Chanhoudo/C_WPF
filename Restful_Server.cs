using System;
using System.IO;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace WpfRestExample
{
    public partial class MainWindow : Window
    {
        private HttpListener? _listener;

        public MainWindow()
        {
            InitializeComponent();
        }

        // 서버 시작 버튼 클릭
        private async void StartServerButton_Click(object sender, RoutedEventArgs e)
        {
            _listener = new HttpListener();
            _listener.Prefixes.Add("http://localhost:5000/");
            _listener.Start();
            ServerLog.AppendText("Server started on http://localhost:5000/\n");

            await Task.Run(() => RunServer());
        }

        private async Task RunServer()
        {
            while (_listener != null && _listener.IsListening)
            {
                var context = await _listener.GetContextAsync();
                var request = context.Request;
                var response = context.Response;

                string responseString;

                if (request.HttpMethod == "GET" && request.Url.AbsolutePath == "/api/data")
                {
                    responseString = "[\"Sample Data 1\", \"Sample Data 2\"]";
                    response.StatusCode = (int)HttpStatusCode.OK;
                }
                else if (request.HttpMethod == "POST" && request.Url.AbsolutePath == "/api/data")
                {
                    using (var reader = new StreamReader(request.InputStream, request.ContentEncoding))
                    {
                        string requestData = await reader.ReadToEndAsync();
                        Dispatcher.Invoke(() => ServerLog.AppendText($"Received: {requestData}\n"));
                        responseString = "{\"message\":\"Data received\",\"data\":" + requestData + "}";
                    }
                    response.StatusCode = (int)HttpStatusCode.OK;
                }
                else
                {
                    responseString = "{\"message\":\"Not Found\"}";
                    response.StatusCode = (int)HttpStatusCode.NotFound;
                }

                byte[] buffer = Encoding.UTF8.GetBytes(responseString);
                response.ContentLength64 = buffer.Length;
                response.OutputStream.Write(buffer, 0, buffer.Length);
                response.Close();
            }
        }

        // GET 요청 버튼 클릭
        private async void SendGetButton_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                var request = (HttpWebRequest)WebRequest.Create("http://localhost:5000/api/data");
                request.Method = "GET";

                var response = (HttpWebResponse)await request.GetResponseAsync();
                using (var reader = new StreamReader(response.GetResponseStream()))
                {
                    string responseText = await reader.ReadToEndAsync();
                    ClientLog.AppendText($"GET Response: {responseText}\n");
                }
            }
            catch (Exception ex)
            {
                ClientLog.AppendText($"GET Error: {ex.Message}\n");
            }
        }

        // POST 요청 버튼 클릭
        private async void SendPostButton_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                var request = (HttpWebRequest)WebRequest.Create("http://localhost:5000/api/data");
                request.Method = "POST";
                request.ContentType = "application/json";

                string inputData = ClientInput.Text;
                using (var writer = new StreamWriter(request.GetRequestStream()))
                {
                    await writer.WriteAsync($"\"{inputData}\"");
                }

                var response = (HttpWebResponse)await request.GetResponseAsync();
                using (var reader = new StreamReader(response.GetResponseStream()))
                {
                    string responseText = await reader.ReadToEndAsync();
                    ClientLog.AppendText($"POST Response: {responseText}\n");
                }
            }
            catch (Exception ex)
            {
                ClientLog.AppendText($"POST Error: {ex.Message}\n");
            }
        }
    }
}
