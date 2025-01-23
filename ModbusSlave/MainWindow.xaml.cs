using NModbus;
using NModbus.Tcp;
using System;
using System.Net.Sockets;
using System.Windows;

namespace ModbusClientApp
{
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
        }

        private void ReadDataButton_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                using (var client = new TcpClient("127.0.0.1", 502)) // 서버 IP 및 포트
                {
                    var factory = new ModbusFactory();
                    var master = factory.CreateMaster(client.GetStream());

                    // 서버(Unit ID: 1)의 홀딩 레지스터에서 데이터 읽기
                    ushort[] holdingRegisters = master.ReadHoldingRegisters(1, 0, 1);

                    AppendMessage($"Data from server: {holdingRegisters[0]}");
                }
            }
            catch (Exception ex)
            {
                AppendMessage($"Error: {ex.Message}");
            }
        }

        private void AppendMessage(string message)
        {
            Dispatcher.Invoke(() => MessageBox.Text += $"{message}\n");
        }
    }
}
