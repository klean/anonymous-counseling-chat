<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="ClientQueue.aspx.cs" Inherits="WebChat.ClientQueue" %>

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
            your.namespace.com.IServiceChat.QueueCount(chatID(), WaitQueueComplete, WaitQueueFailed);
            your.namespace.com.IServiceChat.ChildStatus(chatID(), messageID, StatusComplete);
        }
        function WaitQueueComplete(result) {
            try {
                if (result > 0) {
                    var lbl = document.getElementById('<%= LabelQueueCount.ClientID %>');
                    lbl.innerHTML = result;
                    setTimeout(WaitQueue, 1000);
                }
                else {
                    window.location = "ClientChat.aspx?id=" + chatID();
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
                            if(message.MessageType == your.namespace.com.eMessageType.QueueMessage)
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
                <asp:Label ID="Label1" runat="server" Text="There is currently a queue to get to chat with an advisor. Please be patient, or come back again later...." />
            </td>
        </tr>
        <tr>
            <td>
                <br />
                <hr />
                
                    <asp:Label ID="Label2" runat="server" Text="You are currently number" />
                    &nbsp;<asp:Label ID="LabelQueueCount" runat="server" />&nbsp;
                    <asp:Label ID="Label4" runat="server" Text="in the queue." />
                
            </td>
        </tr>
        <tr>
        <td>
            <a href="http://www.insert_your_conditions for user here.com" target="_blank" >Conditions for use...</a>
        </td>
        </tr>
        
    </table>
    </center>
</asp:Content>
