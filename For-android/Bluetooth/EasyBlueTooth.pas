{
  Имя EasyBlueTooth
  Описание Модуль для простого использования блютуз для Android
  Автор PTyTb
  Дата 19.09.2017
}
unit EasyBlueTooth;

interface

uses System.Bluetooth, System.SysUtils,FMX.ListBox, System.Classes;


type
  TServerConnectionTH = class(TThread)
  private
    { Private declarations }
    FServerSocket: TBluetoothServerSocket;
    FSocket: TBluetoothSocket;
    FData: TBytes;
  protected
    procedure Execute; override;
    procedure UpdateText;

  public
    { Public declarations }
    constructor Create(ACreateSuspended: Boolean);
    destructor Destroy; override;
    procedure Connect(index: integer);
    procedure PairedDevices(ComboboxPaired: TCombobox);
    procedure SendData(TextData: string);
  private
    function ManagerConnected: Boolean;
  end;

Const
  ServiceName = 'SerialPort';
  ServiceGUI = '{00001101-0000-1000-8000-00805f9b34fb}';

var
  ToSend: TBytes;
  LDevice: TBluetoothDevice;
  FBluetoothManager: TBluetoothManager;
  FDiscoverDevices: TBluetoothDeviceList;
  FPairedDevices: TBluetoothDeviceList;
  FAdapter: TBluetoothAdapter;
  FData: TBytes;
  FSocket: TBluetoothSocket;
  ItemIndex: integer;
  ServerConnectionTH: TServerConnectionTH;

implementation

{ TServerConnectionTH }

constructor TServerConnectionTH.Create(ACreateSuspended: Boolean);
begin
  inherited;
end;

destructor TServerConnectionTH.Destroy;
begin
  FSocket.Free;
  FServerSocket.Free;
  inherited;
end;

procedure TServerConnectionTH.Execute;
var
  ASocket: TBluetoothSocket;
  Msg: string;
begin
  while not Terminated do
    try
      ASocket := nil;
      while not Terminated and (ASocket = nil) do
        ASocket := FServerSocket.Accept(100);
      if (ASocket <> nil) then
      begin
        FSocket := ASocket;
        while not Terminated do
        begin
          FData := ASocket.ReadData;
          if Length(FData) > 0 then
            Synchronize(
              procedure
              begin

              end);
          sleep(100);
        end;
      end;
    except
      on E: Exception do
      begin
        Msg := E.Message;
        Synchronize(
          procedure
          begin

          end);
      end;
    end;
end;

procedure TServerConnectionTH.UpdateText;
begin
  if Length(FData) > 0 then
  begin

  end;
end;

procedure TServerConnectionTH.Connect(index: integer);
begin
  if (ServerConnectionTH = nil) and ManagerConnected then
  begin
    FAdapter := FBluetoothManager.CurrentAdapter;
    ServerConnectionTH := TServerConnectionTH.Create(True);
    ServerConnectionTH.FServerSocket := FAdapter.CreateServerSocket(ServiceName,
      StringToGUID(ServiceGUI), False);
    ServerConnectionTH.Start;
    if (FSocket = nil) or (ItemIndex <> index) then
    begin
      if index > -1 then
      begin
        LDevice := FPairedDevices[index] as TBluetoothDevice;
        FSocket := LDevice.CreateClientSocket(StringToGUID(ServiceGUI), False);
        if FSocket <> nil then
        begin
          ItemIndex := index;
          FSocket.Connect;
        end;
      end;
    end;
  end;
end;

function TServerConnectionTH.ManagerConnected: Boolean;
begin
  if FBluetoothManager.ConnectionState = TBluetoothConnectionState.Connected
  then
  begin
    result := True;
  end
  else
  begin
    result := False;
  end
end;

procedure TServerConnectionTH.PairedDevices(ComboboxPaired: TCombobox);
var
  i: integer;
begin
  FBluetoothManager := TBluetoothManager.Current;
  if ManagerConnected then
  begin
    ComboboxPaired.Clear;
    FPairedDevices := FBluetoothManager.GetPairedDevices;
    if FPairedDevices.Count > 0 then
      for i := 0 to FPairedDevices.Count - 1 do
        ComboboxPaired.Items.Add(FPairedDevices[i].DeviceName)
    else
      ComboboxPaired.Items.Add('No Paired Devices');
  end;

end;

procedure TServerConnectionTH.SendData(TextData: string);
begin
  if FSocket <> nil then
  begin
    ToSend := TEncoding.UTF8.GetBytes(TextData);
    FSocket.SendData(ToSend);
  end;
end;

end.
