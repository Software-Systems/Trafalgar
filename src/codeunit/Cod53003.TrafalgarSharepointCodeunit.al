codeunit 53003 "Trafalgar Sharepoint Codeunit"
{
    Permissions = tabledata "G/L Entry" = rimd;

    var
        GLSetup: Record "General Ledger Setup";

    procedure GenerateJournalNo() JournalNo: Code[20];
    var
        GLSetup: Record "General Ledger Setup";
        NoSeries: Codeunit "No. Series";
    begin
        GLSetup.Get;
        GLSetup.TestField("Sharepoint GLEntries Nos.");
        JournalNo := NoSeries.GetNextNo(GLSetup."Sharepoint GLEntries Nos.", WorkDate, TRUE);
        exit(JournalNo);
    end;

    [EventSubscriber(ObjectType::Table, Database::"G/L Entry", OnAfterCopyGLEntryFromGenJnlLine, '', false, false)]
    local procedure GLEntry_OnAfterCopyGLEntryFromGenJnlLine(var GLEntry: Record "G/L Entry"; var GenJournalLine: Record "Gen. Journal Line");
    begin
        GLEntry."Journal No." := GenJournalLine."Journal No.";
    end;

    procedure UpdateGLEntryJournalNo(ParEntryNo: Integer) JournalNo: Text
    var
        GLEntry: Record "G/L Entry";
    begin
        if GLEntry.Get(ParEntryNo) then begin
            JournalNo := GenerateJournalNo;
            GLEntry."Journal No." := JournalNo;
            GLEntry.Modify();
            exit(JournalNo);
        end;
    end;

    procedure OpenSharepointDocument(ParTableID: Integer; ParDocNo: Code[20]): Text
    var
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        Headers: HttpHeaders;
        ContentHeader: HttpHeaders;
        RequestContent: HttpContent;
        JsonResponse: JsonObject;
        AuthToken: SecretText;
        HeaderURL: Text;
        SharePointFileUrl: Text;
        ResponseText: Text;
        OutStream: OutStream;
        FileContent: InStream;
        DocAttach: Record "Document Attachment";
        TempBlob: Codeunit "Temp Blob";
        FolderName: Text;
        FileName: Text;
        FileUrl: Text;
    begin
        // Get OAuth token
        AuthToken := GetOAuthToken();
        if AuthToken.IsEmpty() then
            Error('Failed to obtain access token.');

        case
            ParTableID of
            17:
                begin
                    FolderName := 'GLEntriesDocs';
                end;
            18:
                begin
                    FolderName := 'CustomerDocs';
                end;
            21:
                begin
                    FolderName := 'CustLedgerEntriesDocs';
                end;
            23:
                begin
                    FolderName := 'VendorDocs';
                end;
            25:
                begin
                    FolderName := 'VendLedgerEntriesDocs';
                end;
            36:
                begin
                    FolderName := 'SalesDocs';
                end;
            38:
                begin
                    FolderName := 'PurchDocs';
                end;
            1170:
                begin
                    FolderName := 'UserTasks';
                end;
        end;
        FolderName := FolderName + '/' + ParDocNo;

        // Define the SharePoint folder URL
        FileName := 'BC.txt';

        // application permissions (replace with the actual site-id, drive-id, folder path and file name)
        HeaderURL := 'https://graph.microsoft.com/v1.0/sites/' + GetSiteID +
                            '/drives/' + GetDriveID() + '/root:/';
        FileURL := GLSetup."SharePoint Document Path" + '/' + FolderName;
        SharePointFileUrl := HeaderURL + FolderName + '/' + FileName + ':/content';

        // Initialize the HTTP request
        HttpRequestMessage.SetRequestUri(SharePointFileUrl);
        HttpRequestMessage.Method := 'PUT';
        HttpRequestMessage.GetHeaders(Headers);
        Headers.Add('Authorization', SecretStrSubstNo('Bearer %1', AuthToken));
        RequestContent.GetHeaders(ContentHeader);
        ContentHeader.Clear();
        ContentHeader.Add('Content-Type', 'text/csv');
        //HttpRequestMessage.Content.WriteFrom(FileContent);

        // Send the HTTP request
        if HttpClient.Send(HttpRequestMessage, HttpResponseMessage) then begin
            // Log the status code for debugging
            if HttpResponseMessage.IsSuccessStatusCode() then begin
                HttpResponseMessage.Content.ReadAs(ResponseText);
                JsonResponse.ReadFrom(ResponseText);
                //Message(ResponseText); 
            end else begin
                //Report errors!
                HttpResponseMessage.Content.ReadAs(ResponseText);
                Error('Failed to upload files to SharePoint: %1 %2', HttpResponseMessage.HttpStatusCode(), ResponseText);
            end;
        end else
            Error('Failed to send HTTP request to SharePoint');

        exit(FileUrl);
    end;

    procedure GetOAuthToken() AuthToken: SecretText
    var
        ClientID: Text;
        ClientSecret: Text;
        TenantID: Text;
        AccessTokenURL: Text;
        OAuth2: Codeunit OAuth2;
        Scopes: List of [Text];
    begin
        ClientID := GetClientID();
        ClientSecret := GetClientSecret();
        TenantID := GetTenantID();
        AccessTokenURL := 'https://login.microsoftonline.com/' + TenantID + '/oauth2/v2.0/token';
        Scopes.Add('https://graph.microsoft.com/.default');
        if not OAuth2.AcquireTokenWithClientCredentials(ClientID, ClientSecret, AccessTokenURL, '', Scopes, AuthToken) then
            Error('Failed to get access token from response\%1', GetLastErrorText());
    end;

    procedure GetClientID(): Text
    begin
        Exit('cbfcc940-706f-4617-9e57-2f76762d848b');
    end;

    procedure GetClientSecret(): Text
    begin
        if GLSetup.Get then
            Exit(GLSetup."Sharepoint Client Secret");
        //unT8Q~ImXL2wRUzW6CksaMWdiCzvMaTITYbcoaxx
    end;

    procedure GetTenantID(): Text;
    var
        AzureADTenant: Codeunit "Azure AD Tenant";
    begin
        exit(AzureADTenant.GetAadTenantId);
    end;

    procedure GetSiteID(): Text
    begin
        exit('862db21e-a6d4-45eb-8afe-baf91f894c06');
    end;

    procedure GetDriveID(): Text
    begin
        exit('b!HrIthtSm60WK_rr5H4lMBvAgPZX-g3BJhFZt-uUiqdPdNn8nQLwYQpeuKzThX7n1');
    end;
}
