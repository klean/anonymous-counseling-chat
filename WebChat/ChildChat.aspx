<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="ChildChat.aspx.cs" Inherits="WebChat.ChildChat" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        var isWriting = false;
        var messageID = 0;
        var statusUpdating = false;
        function OnLoad() {
            setInterval(Status, 1000);
        }

        function Panic() {
            javachat.iservicechat.ChildLeave(chatID(), JavaChat.eChildStatus.Panic, PanicSuccess, PanicFailed);
            return false;
        }

        function PanicSuccess() {
            window.location = "http://www.google.dk";
        }

        function PanicFailed() {
            window.location = "http://www.google.dk";
        }

        function End() {
            if (confirm("Vil du afbryde chatten? - hvis du afbryder vil din chat blive slettet og du har ikke mulighed for at genoptage denne chat"))
                javachat.iservicechat.ChildLeave(chatID(), JavaChat.eChildStatus.Offline, EndSuccess, EndFailed);

            return false;
        }

        function EndSuccess() {
            window.location = "Default.aspx";
        }

        function EndFailed() {
            alert("Fejl i afslutning af chat");
        }

        function Say() {
            var message = document.getElementById('<%= tbNewMessage.ClientID %>');
            javachat.iservicechat.ChildSay(chatID(), message.value, SaySuccess, SayFailed);
            return false;
        }
        function SaySuccess(result) {
            var message = document.getElementById('<%= tbNewMessage.ClientID %>');
            message.value = "";
            Writing();
            return false;
        }

        function SayFailed(result) {
            alert("Fejl i Say");
        }



        function Status() {
            if (!statusUpdating) {
                statusUpdating = true;
                javachat.iservicechat.ChildStatus(chatID(), messageID, StatusComplete, StatusFailed);
                javachat.iservicechat.GetAdvisorActive(chatID(), ActiveCheckComplete);
            }

            return false;
        }

        function ActiveCheckComplete(status)
        {
            var lbl = document.getElementById('<%= lblActiveStatus.ClientID %>');
            if (status) {

                lbl.innerHTML = "Rådgiveren taster...";
            }
            else {
                lbl.innerHTML = "";
            }
        }

        function StatusComplete(messages) {
            try {

                for (var i = 0; i < messages.length; i++) {
                    try {
                        var message = messages[i];
                        if (message != null) {
                            messageID = message.ID + 1;
                            var when = ConvertDateTimeToString(message.Received, false);
                            var who = message.From == chatID() ? "<strong>Dig:</strong>" : message.From == '<%= Guid.Empty %>' ? "" : "<strong>Rådgiver:</strong>";
                            updateLastMessage(message.Received, '<%= lblLastMessage.ClientID %>');
                            if (message.MessageType == 1) {
                                updateLastMessage(message.Received, '<%= lblBegin.ClientID %>');
                            }

                            if (message.MessageType != JavaChat.eMessageType.QueueMessage) {
                                AddMessage(when + " " + who + " " + message.Text);
                            }

                            if (message.MessageType == JavaChat.eMessageType.Leave) {
                                javachat.iservicechat.ChildLeave(chatID(), JavaChat.eChildStatus.Offline);
                            }
                                

                        }
                    } catch (e) {

                    }
                }
            } catch (e) {

            }
            statusUpdating = false;
            //setTimeout(Status, 1000);
        }
        function StatusFailed(messages) {
            statusUpdating = false;
            //setTimeout(Status, 1000);
        }

        function linkify(text) {
            if (!text) return text;

            text = text.replace(/((https?\:\/\/|ftp\:\/\/)|(www\.))(\S+)(\w{2,4})(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/gi, function (url) {
                nice = url;
                if (url.match('^https?:\/\/')) {
                    nice = nice.replace(/^https?:\/\//i, '')
                }
                else
                    url = 'http://' + url;


                return '<a target="_blank" rel="nofollow" href="' + url + '">' + nice.replace(/^www./i, '') + '</a>';
            });

            return text;
        }

        function AddMessage(text) {
            try {
                var resultDiv = document.getElementById('<%= tbMessages.ClientID %>');
                var opt = document.createElement("span");
                var br = document.createElement("br");
                opt.innerHTML = linkify(text);
                var scrollToEnd = resultDiv.scrollTop == (resultDiv.scrollHeight - resultDiv.clientHeight);
                resultDiv.appendChild(opt);
                resultDiv.appendChild(br);
                setTimeout(ScrollToEnd(scrollToEnd), 1);
            } catch (e) {

            }
        }

        function Writing() {

            if (!isWriting) {
                isWriting = true;
                javachat.iservicechat.SetChildActive(chatID(), true);
            }

            var textbox = document.getElementById('<%= tbNewMessage.ClientID %>');

            if (textbox.value == "") {
                isWriting = false;
                javachat.iservicechat.SetChildActive(chatID(), false);
            }
        }

        function ScrollToEnd(scrollToEnd) {
            if (scrollToEnd) {
                var resultDiv = document.getElementById('<%= tbMessages.ClientID %>');
                resultDiv.scrollTop = resultDiv.scrollHeight;
            }
        }

        function updateLastMessage(value, clientID) {
            var lastMessage = document.getElementById(clientID);
            lastMessage.innerHTML = ConvertDateTimeToString(value, true);
        }

        function ConvertDateTimeToString(value, includeSeconds) {
            var currentTime = value;
            var hours = currentTime.getHours()
            var minutes = currentTime.getMinutes()
            var seconds = currentTime.getSeconds();
            var txt = hours + ":" + (minutes < 10 ? "0" + minutes : minutes);
            if(includeSeconds)
            {
                txt += ":" + (seconds < 10 ? "0" + seconds : seconds);
            }
            return txt;
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" runat="server" ContentPlaceHolderID="ContentPlaceHolder1">
    <table width="100%" cellpadding="5">
        <tr>
            <td>
                <table width="98%">
                    <tr>
                        <td>
                            <asp:Panel ID="tbMessages" runat="server" BorderColor="LightBlue" BorderStyle="Solid"
                                BorderWidth="2px" Style="padding: 10px;" Font-Names="Verdana" 
                                Width="535px" Height="300px"
                                ScrollBars="Auto">
                            </asp:Panel>
                        </td>
                        <td id="rightImage" style="vertical-align: bottom;">
                <asp:Button ID="btnFinish" runat="server" Text="Afslut"  Height="25px" Width="75px" style="margin: 5px;" 
                    OnClientClick="javascript:return End();" SkinID="btnExit" />
                        </td>
                    </tr>
                    <tr align="right">
                        <td colspan="2">
                            <asp:Label ID="lblActiveStatus" runat="server" Text=""></asp:Label>                            
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Panel ID="Panel1" runat="server" DefaultButton="btnSend">
                    <table width="98%">
                        <tr>
                            <td>
                                <asp:TextBox ID="tbNewMessage" runat="server" 
                                    OnKeyUp="javascript:return Writing();" TextMode="MultiLine" Width="535px" BorderColor="LightBlue"
                                    BorderStyle="Solid" BorderWidth="2px" Style="padding: 10px;" Font-Names="Verdana"
                                    Height="75px"></asp:TextBox>
                            </td>
                            <td style="width: 106px;" align="right">
                                <asp:Button ID="btnSend" runat="server" Text="Send" Height="75px" Width="75px" 
                                    OnClientClick="javascript:return Say();" SkinID="btnOK" />
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
            </td>
        </tr>
    </table>
</asp:Content>
<asp:Content ID="Content3" runat="server" 
    contentplaceholderid="ContentPlaceHolderTopRight">
    <asp:Label ID="lblBeginTxt" runat="server" Text="Samtalen startede kl.:"></asp:Label>
                            &nbsp;
                            <asp:Label ID="lblBegin" runat="server" Text=""></asp:Label>
    <br />
    <asp:Label ID="lblLastMessageTxt" runat="server" Text="Sidste indtastning kl.:"></asp:Label>
    &nbsp;
    <asp:Label ID="lblLastMessage" runat="server" Text=""></asp:Label>
</asp:Content>

