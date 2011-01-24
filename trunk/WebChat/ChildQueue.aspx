<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="ChildQueue.aspx.cs" Inherits="WebChat.ChildQueue" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        var messageID = 0;
        function OnLoad() {
            WaitQueue();
        }

        function setFocus() {
            var isChrome = /chrome/.test(navigator.userAgent.toLowerCase());
            if (isChrome) {
                window.blur();
                setTimeout(window.focus, 0);
            }
            else {
                window.focus();
            }
        }
        function WaitQueue() {
            javachat.iservicechat.QueueCount(chatID(), WaitQueueComplete, WaitQueueFailed);
            javachat.iservicechat.ChildStatus(chatID(), messageID, StatusComplete);
        }
        function WaitQueueComplete(result) {
            try {
                if (result > 0) {
                    var lbl = document.getElementById('<%= LabelQueueCount.ClientID %>');
                    lbl.innerHTML = result;
                    setTimeout(WaitQueue, 1000);
                }
                else {
                    window.location = "ChildChat.aspx?id=" + chatID();
                    setFocus();
                }
            } catch (e) {

            }
        }

        function WaitQueueFailed(result) {
            setTimeout(WaitQueue, 1000);
        }

        function StatusComplete(messages) {
                for (var i = 0; i < messages.length; i++) {
                    try {
                        var message = messages[i];
                        if (message != null) {
                            messageID = messageID + 1;
                            if(message.MessageType == JavaChat.eMessageType.QueueMessage)
                                alert(message.Text);
                        }
                    } catch (e) {

                    }
                }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<center>
    <table style="margin: 10px;" cellpadding="5">
        <tr>
            <td>
                <asp:Label ID="Label1" runat="server" Text="Der er mange, der gerne vil bruge AlbaHusChatten, så ind imellem kan der være lang ventetid i køen. Brug for eksempel tiden på at kigge på Albahus.dk, hvor mange finder god hjælp" />
            </td>
        </tr>
        <tr>
            <td>
                <br />
                <hr />
                
                    <asp:Label ID="Label2" runat="server" Text="Du er nummer" />
                    &nbsp;<asp:Label ID="LabelQueueCount" runat="server" />&nbsp;
                    <asp:Label ID="Label4" runat="server" Text="i køen" />
                
            </td>
        </tr>
        <tr>
        <td>
            <a href="http://www.albahus.dk/page_unge.asp?id_page=11&id_page_sub1=259&id_page_sub2=85" target="_blank" >Betingelser for brug af chatten</a>
        </td>
        </tr>
        
    </table>
    </center>
</asp:Content>
