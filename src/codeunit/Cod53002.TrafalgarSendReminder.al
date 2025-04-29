codeunit 53002 "Trafalgar Send Reminder"
{
    trigger OnRun()
    var
        IsSent: Boolean;
        DateParam: DateTime;
    begin
        DateParam := CreateDateTime(CalcDate('<-7D>', Today), 000000T);
        UserTask.Reset;
        UserTask.Setrange(UserTask."Completed DateTime", 0DT);
        UserTask.Setfilter(UserTask."Created DateTime", '<%1', DateParam);
        if UserTask.findset then
            repeat
                SendUserTaskReminder(UserTask.ID);
            until UserTask.Next() = 0;
    end;

    local procedure GetSendToEmail(ParUserID: Text): Text
    var
        User: Record User;
    begin
        User.Reset;
        User.Setrange(User."User Name", ParUserID);
        if User.FindFirst() then
            exit(User."Authentication Email")
        else
            Exit('');
    end;

    var
        UserTask: Record "User Task";

    procedure SendUserTaskReminder(ParUserTaskID: Integer)
    var
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        SendToEmail: List of [Text];
        CCEmail: List of [Text];
        BCCEmail: List of [Text];

        SubjectText: Text;
        BodyText: Text;

    begin
        if UserTask.Get(ParUserTaskID) then begin
            UserTask.CalcFields(UserTask."Assigned To User Name");
            if GetSendToEmail(UserTask."Assigned To User Name") <> '' then begin
                SendToEmail.Add(GetSendToEmail(UserTask."Assigned To User Name"));
                //CCEmail.Add(Salesperson."E-Mail");

                SubjectText := 'User Task Reminder : ' + UserTask.Title;
                BodyText := BodyText + '<p style="color:black">';
                BodyText := BodyText + 'Dear ' + UserTask."Assigned To User Name" + ',';
                BodyText := BodyText + '<br><br>';
                BodyText := BodyText + 'This is a friendly reminder to follow up on your assigned User task <b>ID : ' + Format(UserTask.ID) + '</b>';
                BodyText := BodyText + '<br><br>';
                BodyText := BodyText + 'Comment : <i>' + UserTask.GetDescription() + '</i>';
                BodyText := BodyText + '<br><br>';
                BodyText := BodyText + 'Please ensure that all necessary updates are recorded and any required actions are completed.';
                BodyText := BodyText + '<br><br>';
                BodyText := BodyText + 'Thank you';
                BodyText := BodyText + '<br><br>';
                BodyText := BodyText + '<b>Regards,';
                BodyText := BodyText + '<br>';
                BodyText := BodyText + CompanyName;
                BodyText := BodyText + '</b>';

                EmailMessage.Create(SendToEmail, SubjectText, BodyText, true, CCEmail, BCCEmail);

                //Send mail
                Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
            end;
        end;
    END;
}