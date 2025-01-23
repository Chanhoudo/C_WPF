using System;
using System.Collections.Generic;
using System.Net.Sockets;
using System.Text;
using System.Windows;

namespace ModbusApp
{
    public partial class MainWindow : Window
    {
        private TcpClient _tcpClient;
        private NetworkStream _stream;

        public MainWindow()
        {
            InitializeComponent();
            _tcpClient = new TcpClient(); // 기본값 초기화
            _stream = null; // 기본값 초기화
        }

        private void ConnectButton_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                string ipAddress = IpAddressTextBox.Text; // IP 주소를 TextBox에서 가져옴
                int port = int.Parse(PortTextBox.Text);   // 포트 번호를 TextBox에서 가져옴

                _tcpClient = new TcpClient(ipAddress, port);  // 입력된 IP와 포트로 Slave에 연결 시도
                _stream = _tcpClient.GetStream();             // Slave와의 통신 스트림을 생성

                MessageBox.Show("Connected to Modbus Server!");
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Connection failed: {ex.Message}");
            }
        }

        private void ReadCoilsButton_Click(object sender, RoutedEventArgs e)
        {
            ReadCoilsButton.IsEnabled = false; // 버튼 비활성화
            try
            {
                if (_stream == null || !_tcpClient.Connected) // 스트림이나 TCP 연결 상태 확인
                {
                    MessageBox.Show("Slave에 연결되지 않았습니다.");
                    return;
                }

                byte[] request = CreateReadRequest(1, 0, 10, 0x01); // Read Coils 요청 생성 (Unit ID: 1, 주소: 0, 개수: 10)
                _stream.Write(request, 0, request.Length);          // 요청을 Slave로 전송

                byte[] response = new byte[256];                    // 응답 데이터를 저장할 버퍼
                int bytesRead = _stream.Read(response, 0, response.Length); // 응답 데이터를 읽음

                if (bytesRead < 5) // 최소한의 Modbus 응답 크기 확인
                {
                    MessageBox.Show("Slave에서 유효하지 않은 응답을 받았습니다.");
                    return;
                }

                List<CoilData> coils = ParseCoilResponse(response, 10);
                Dispatcher.Invoke(() =>
                {
                    CoilGrid.ItemsSource = coils; // UI 업데이트
                    MessageBox.Show("코일 데이터를 가져왔습니다.");
                });
            }
            catch (Exception ex)
            {
                MessageBox.Show($"코일 데이터를 가져오지 못했습니다: {ex.Message}");
            }
            finally
            {
                ReadCoilsButton.IsEnabled = true; // 작업 완료 후 버튼 활성화
            }
        }


        private void ReadRegistersButton_Click(object sender, RoutedEventArgs e)
        {
            if (!_tcpClient.Connected)
            {
                MessageBox.Show("Slave에 연결되지 않았습니다.");
                return;
            }
            try
            {
                byte[] request = CreateReadRequest(1, 0, 10, 0x03); // Function Code 0x03 (Read Holding Registers)
                _stream.Write(request, 0, request.Length);

                byte[] response = new byte[256];
                _stream.Read(response, 0, response.Length);

                List<RegisterData> registers = ParseRegisterResponse(response, 10);
                RegisterGrid.ItemsSource = registers;

                // 데이터 가져오기 성공 알림
                MessageBox.Show("레지스터 데이터를 가져왔습니다.");
            }
            catch (Exception ex)
            {
                MessageBox.Show($"레지스터 데이터를 가져오지 못했습니다: {ex.Message}");
            }
        }


        private byte[] CreateReadRequest(byte unitId, ushort startAddress, ushort quantity, byte functionCode)
        {
            byte[] request = new byte[12];
            request[0] = 0; // Transaction ID
            request[1] = 0; // Transaction ID
            request[2] = 0; // Protocol ID
            request[3] = 0; // Protocol ID
            request[4] = 0; // Length
            request[5] = 6; // Length
            request[6] = unitId; // Unit ID
            request[7] = functionCode; // Function Code
            request[8] = (byte)(startAddress >> 8); // Start Address High
            request[9] = (byte)(startAddress & 0xFF); // Start Address Low
            request[10] = (byte)(quantity >> 8); // Quantity High
            request[11] = (byte)(quantity & 0xFF); // Quantity Low
            return request;
        }

        private List<CoilData> ParseCoilResponse(byte[] response, int quantity)
        {
            List<CoilData> coils = new List<CoilData>();
            for (int i = 0; i < quantity; i++)
            {
                bool value = (response[9 + (i / 8)] & (1 << (i % 8))) != 0;
                coils.Add(new CoilData { Address = i, Value = value });
            }
            return coils;
        }

        private List<RegisterData> ParseRegisterResponse(byte[] response, int quantity)
        {
            List<RegisterData> registers = new List<RegisterData>();
            for (int i = 0; i < quantity; i++)
            {
                ushort value = (ushort)((response[9 + i * 2] << 8) | response[9 + i * 2 + 1]);
                registers.Add(new RegisterData { Address = i, Value = value });
            }
            return registers;
        }
    }

    public class CoilData
    {
        public int Address { get; set; }
        public bool Value { get; set; }
    }

    public class RegisterData
    {
        public int Address { get; set; }
        public ushort Value { get; set; }
    }
}
