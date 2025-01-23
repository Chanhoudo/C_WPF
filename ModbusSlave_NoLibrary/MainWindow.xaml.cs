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

                var posts = JsonSerializer.Deserialize<Post[]>(response); // JSON 데이터를 C# 객체로 변환
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
        public int UserId { get; set; } // 사용자 ID
        public int Id { get; set; } // 게시물 ID
        public string Title { get; set; } // 게시물 제목
        public string Body { get; set; } // 게시물 내용
    }
}
