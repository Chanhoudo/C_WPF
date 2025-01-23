using System;
using System.Collections.ObjectModel;
using System.Net.Http;
using System.Text.Json;
using System.Threading.Tasks;
using System.Windows;

namespace RestApiClient
{
    public partial class MainWindow : Window
    {
        private readonly HttpClient _httpClient = new HttpClient(); // HTTP 요청을 처리하는 HttpClient
        private ObservableCollection<Post> _posts = new ObservableCollection<Post>(); // DataGrid와 바인딩할 데이터 컬렉션

        public MainWindow()
        {
            InitializeComponent();
            PostsDataGrid.ItemsSource = _posts; // DataGrid에 데이터 바인딩
        }

        private async void FetchPostsButton_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                string url = "https://jsonplaceholder.typicode.com/posts"; // REST API URL
                string response = await _httpClient.GetStringAsync(url); // API에서 JSON 데이터 가져오기

                var options = new JsonSerializerOptions
                {
                    PropertyNameCaseInsensitive = true // 대소문자 무시
                };
                var posts = JsonSerializer.Deserialize<Post[]>(response, options); // JSON 데이터를 C# 객체로 변환

                if (posts != null)
                {
                    _posts.Clear();
                    foreach (var post in posts)
                    {
                        _posts.Add(post); // ObservableCollection에 데이터 추가
                    }

                    MessageBox.Show("Posts fetched successfully!", "Success", MessageBoxButton.OK, MessageBoxImage.Information);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error fetching posts: {ex.Message}", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

    }

    // Post 데이터 모델
    public class Post
    {
        public int userId { get; set; } // JSON의 "userId"와 일치
        public int id { get; set; }     // JSON의 "id"와 일치
        public string title { get; set; } // JSON의 "title"과 일치
        public string body { get; set; }  // JSON의 "body"와 일치
    }

}
