unit DeepSeekAPI;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fphttpclient, fpjson, jsonparser, opensslsockets;

type
  TDeepSeekModel = (dsChat, dsCode);

  { TDeepSeekClient }

  TDeepSeekClient = class
  private
    FAPIKey: string;
    FBaseURL: string;
    function BuildRequestJSON(const Prompt: string; Model: TDeepSeekModel): string;
  public
    constructor Create(const APIKey: string = '');
    function Query(const Prompt: string; Model: TDeepSeekModel = dsChat): string;
    property BaseURL: string read FBaseURL write FBaseURL;
  end;

implementation

{ TDeepSeekClient }

constructor TDeepSeekClient.Create(const APIKey: string);
begin
  FAPIKey := APIKey;
  FBaseURL := 'https://api.deepseek.com/v1'; // Update when official API is available
end;

function TDeepSeekClient.BuildRequestJSON(const Prompt: string; Model: TDeepSeekModel): string;
var
  ModelStr: string;
begin
  case Model of
    dsChat: ModelStr := 'deepseek-chat';
    dsCode: ModelStr := 'deepseek-code';
  end;
  
  Result := '{"model": "' + ModelStr + '", ' +
            '"messages": [{"role": "user", "content": "' + EscapeJSONString(Prompt) + '"}]}';
end;

function TDeepSeekClient.Query(const Prompt: string; Model: TDeepSeekModel): string;
var
  HTTP: TFPHTTPClient;
  Request, Response: TStringStream;
  JSON: TJSONData;
begin
  HTTP := TFPHTTPClient.Create(nil);
  Request := TStringStream.Create(BuildRequestJSON(Prompt, Model));
  Response := TStringStream.Create('');
  try
    HTTP.AddHeader('Authorization', 'Bearer ' + FAPIKey);
    HTTP.AddHeader('Content-Type', 'application/json');
    HTTP.RequestBody := Request;
    
    try
      HTTP.Post(FBaseURL + '/chat/completions', Response);
      JSON := GetJSON(Response.DataString);
      Result := JSON.GetPath('choices[0].message.content').AsString;
    except
      on E: Exception do
        Result := 'API Error: ' + E.Message;
    end;
    
  finally
    HTTP.Free;
    Request.Free;
    Response.Free;
  end;
end;

end.
