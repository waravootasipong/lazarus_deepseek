unit DeepSeekSettings;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ButtonPanel;

type

  { TDeepSeekSettingsForm }

  TDeepSeekSettingsForm = class(TForm)
    ButtonPanel1: TButtonPanel;
    edtAPIKey: TEdit;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    function GetAPIKey: string;
    procedure SetAPIKey(AValue: string);
  public
    property APIKey: string read GetAPIKey write SetAPIKey;
  end;

implementation

{$R *.lfm}

{ TDeepSeekSettingsForm }

procedure TDeepSeekSettingsForm.FormCreate(Sender: TObject);
begin
  // Initialize form
end;

function TDeepSeekSettingsForm.GetAPIKey: string;
begin
  Result := edtAPIKey.Text;
end;

procedure TDeepSeekSettingsForm.SetAPIKey(AValue: string);
begin
  edtAPIKey.Text := AValue;
end;

end.
