codeunit 53001 "Trafalgar General Codeunit"
{
    procedure GetUserNameFromSecurityId(ParUserSecurityID: Guid): Code[50]
    var
        User: Record User;
    begin
        IF User.Get(ParUserSecurityID) THEN
            exit(User."User Name")
        ELSE
            exit('');
    end;
}
