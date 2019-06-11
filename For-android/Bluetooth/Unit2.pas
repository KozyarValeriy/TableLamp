unit Unit2;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, easybluetooth, //��������� ������, �� �������� �������� pas ���� � �������
  FMX.ListBox, FMX.Edit, FMX.Controls.Presentation, FMX.StdCtrls,
  System.Bluetooth, System.Bluetooth.Components, math, FMX.Objects, FMX.Layouts,
  System.ImageList, FMX.ImgList;

type

  TForm1 = class(TForm)
    Main_layout: TLayout;
    ArcDial1: TArcDial;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Image1: TImage;
    Label2: TLabel;
    Timer1: TTimer;
    Timer2: TTimer;
    Timer3: TTimer;
    TrackBar1: TTrackBar;
    TrackBar2: TTrackBar;
    Layout1: TLayout;
    Button2: TButton;
    ComboBox1: TComboBox;
    Layout2: TLayout;
    Label3: TLabel;
    Layout3: TLayout;
    Label4: TLabel;
    Layout4: TLayout;
    Label5: TLabel;
    Layout5: TLayout;
    VertScrollBox1: TVertScrollBox;
    Label1: TLabel;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Button15: TButton;
    Button16: TButton;
    Rectangle1: TRectangle;
    Button1: TButton;
    Button17: TButton;//������ ��������� ������ ���������
    procedure ComboBox1Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure TrackBar2Change(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure ArcDial1Change(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  procedure send(Send_data: string; m: byte);

var
    Form1: TForm1;
    a:TServerConnectionTH;//������� ��������� ������
    prev, speed, bright: single;
    Send_by_button: string;
    mode: byte;

implementation

{$R *.fmx}

procedure send(Send_data: string; m: byte);
    begin
        Try
            Send_data := inttostr(m) + Send_data;
            Form1.label2.Text := '����������: ' + Send_data;
            a.SendData(Send_data);
        Except
            ShowMessage('����������� ������. ��������, ��� ����������� � ������.');
        end;
    end;

procedure TForm1.ArcDial1Change(Sender: TObject);
    begin
        timer2.Enabled := false;
        bright := ArcDial1.Value;
        //TrackBar2.Value := prev_bright;
        //prev_bright := TrackBar2.Value;
        if ArcDial1.Value >= 0 then
            label3.text := '�������: ' + floattostr(roundto((ArcDial1.Value / 180) * (255 / 2),0))
        else
            label3.text := '�������: ' + floattostr(roundto((255 / 2 + (1 - abs(ArcDial1.Value) / 180) * (255 / 2)),0));
        mode := 0;
        timer2.Enabled := true;
    end;

procedure TForm1.Button10Click(Sender: TObject);
    begin
        Send_by_button := '23';
        mode := 2;
        send(Send_by_button, mode);
    end;

procedure TForm1.Button11Click(Sender: TObject);
    begin
        Send_by_button := '30';
        mode := 2;
        send(Send_by_button, mode);
    end;

procedure TForm1.Button12Click(Sender: TObject);
    begin
        Send_by_button := '4';
        mode := 2;
        send(Send_by_button, mode);
    end;

procedure TForm1.Button13Click(Sender: TObject);
    begin
        Send_by_button := '5';
        mode := 2;
        send(Send_by_button, mode);
    end;

procedure TForm1.Button14Click(Sender: TObject);
    begin
        Send_by_button := '6';
        mode := 2;
        send(Send_by_button, mode);
    end;

procedure TForm1.Button15Click(Sender: TObject);
    begin
        Send_by_button := '7';
        mode := 2;
        send(Send_by_button, mode);
    end;

procedure TForm1.Button16Click(Sender: TObject);
    begin
        Send_by_button := '';
        mode := 9;
        send(Send_by_button, mode);
    end;


procedure TForm1.Button17Click(Sender: TObject);
    begin
        Send_by_button := '32';
        mode := 2;
        send(Send_by_button, mode);
    end;

procedure TForm1.Button1Click(Sender: TObject);
    begin
        Send_by_button := '31';
        mode := 2;
        send(Send_by_button, mode);
    end;

procedure TForm1.Button2Click(Sender: TObject);
    begin
        a := TServerConnectionTH.Create(true);//�������������� ������
        a.PairedDevices(ComboBox1);//�������� ������ ����������� ���������
    end;

procedure TForm1.Button3Click(Sender: TObject);
    begin
        mode := 1;
        TrackBar1.Value := 255 / 3;
        Send_by_button := floattostr(roundto(TrackBar1.Value, 0));
        TrackBar1Change(TrackBar1);
        //send(Send_by_button, mode);
    end;

procedure TForm1.Button4Click(Sender: TObject);
    begin
        mode := 1;
        TrackBar1.Value := 0;
        Send_by_button := floattostr(roundto(TrackBar1.Value, 0));
        TrackBar1Change(TrackBar1);
        //send(Send_by_button, mode);
    end;

procedure TForm1.Button5Click(Sender: TObject);
    begin
        mode := 1;
        TrackBar1.Value := 2 * 255 / 3;
        Send_by_button := floattostr(roundto(TrackBar1.Value, 0));
        TrackBar1Change(TrackBar1);
        //send(Send_by_button, mode);
    end;

procedure TForm1.Button6Click(Sender: TObject);
    begin
        Send_by_button := '1';
        mode := 2;
        send(Send_by_button, mode);
    end;

procedure TForm1.Button7Click(Sender: TObject);
    begin
        Send_by_button := '20';
        mode := 2;
        send(Send_by_button, mode);
    end;

procedure TForm1.Button8Click(Sender: TObject);
    begin
        Send_by_button := '21';
        mode := 2;
        send(Send_by_button, mode);
    end;
procedure TForm1.Button9Click(Sender: TObject);
    begin
        Send_by_button := '22';
        mode := 2;
        send(Send_by_button, mode);
    end;

procedure TForm1.ComboBox1Change(Sender: TObject);
    begin
        a.Connect(combobox1.ItemIndex);//������������ � ���������� ����������
        //timer1.Enabled := true;
    end;


procedure TForm1.FormCreate(Sender: TObject);
    begin
        //prev := TrackBar1.Max + 5;
        Main_layout.Height := Screen.Size.Height - 20;
        layout5.Height := Main_layout.Height - layout5.Position.Y - 75;
        //label2.Text := floattostr(Screen.Size.Height);
        label2.Margins.Left := Screen.Size.Width - 130;

    end;

procedure TForm1.Timer1Timer(Sender: TObject);
    begin
        if (prev = TrackBar1.Value) then
            send(floattostr(roundto(TrackBar1.Value, 0)), mode);
        timer1.Enabled := false;
    end;

procedure TForm1.Timer2Timer(Sender: TObject);
    begin
        if (bright = ArcDial1.Value) then
            begin
                if ArcDial1.Value >= 0 then
                    bright := (ArcDial1.Value / 180) * (255 / 2)
                else
                    bright := 255 / 2 + (1 - abs(ArcDial1.Value) / 180) * (255 / 2);
                send(floattostr(roundto(bright, 0)), mode);
            end;
        timer2.Enabled := false;
    end;

procedure TForm1.Timer3Timer(Sender: TObject);
    begin
        if (speed = TrackBar2.Value) then
            send(floattostr(roundto(250 - TrackBar2.Value, 0)), mode);
        timer3.Enabled := false;
    end;

procedure TForm1.TrackBar1Change(Sender: TObject);
    begin
        timer1.Enabled := false;
        label5.Text := '������ ������: ' + floattostr(roundto(TrackBar1.Value, 0));
        prev := TrackBar1.Value;
        mode := 1;
        timer1.Enabled := true;
    end;

procedure TForm1.TrackBar2Change(Sender: TObject);
    begin
        timer3.Enabled := false;
        speed := TrackBar2.Value;
        label4.Text := '�������� ��������: ' + floattostr(roundto(TrackBar2.Value, 0));
        mode := 3;
        timer3.Enabled := true;
    end;

end.
