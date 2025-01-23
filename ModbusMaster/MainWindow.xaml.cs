using NModbus;
using NModbus.Tcp;
using System;
using System.Net;
using System.Net.Sockets;
using System.Threading;
using System.Windows;

namespace ModbusServerApp
{
    public partial class MainWindow : Window
    {
        private TcpListener tcpListener;
        private Thread serverThread;

        public MainWindow()
        {
            InitializeComponent();
        }

        private void StartServerButton_Click(object sender, RoutedEventArgs e)
        {
            serverThread = new Thread(StartModbusServer);
            serverThread.IsBackground = true;
            serverThread.Start();
            AppendMessage("Modbus server started.");
        }

        private void StartModbusServer()
        {
            try
            {
                tcpListener = new TcpListener(IPAddress.Any, 502); // Modbus TCP 기본 포트
                tcpListener.Start();

                var factory = new ModbusFactory();
                var slaveNetwork = factory.CreateSlaveNetwork(tcpListener);

                // 홀딩 레지스터 설정 (서버가 클라이언트 요청에 응답할 데이터)
                var slave = factory.CreateSlave(1); // Unit ID: 1
                slave.DataStore.HoldingRegisters[0] = 123; // 예제 데이터
                slaveNetwork.AddSlave(slave);

                slaveNetwork.ListenAsync().Wait();
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
