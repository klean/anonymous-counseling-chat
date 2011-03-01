<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="AdvisorChat.aspx.cs" Inherits="WebChat.AdvisorChat" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        var isWriting = false;
        var messageID = 0;
        var chatEndedTimeout;
        var statusUpdating = false;
        function OnLoad() {
            try {
                if (advisorID() == null || advisorID() == '<%= Guid.Empty %>') {
                    enableControls(false);
                    Join();
                }
                else {
                    setInterval(Status, 1000);
                }
            } catch (e) {

            }
        }

        function enableControls(enable) {
            var f = document.getElementById('<%= tbNewMessage.ClientID%>');
            f.disabled = !enable;
            var g = document.getElementById('<%= btnSend.ClientID%>');
            g.disabled = !enable;
            var h = document.getElementById('<%= btnEnd.ClientID%>');
            h.disabled = !enable;
        }

        function advisorID() {
            return chatID();
        }

        function Join() {
            your.namespace.com.IServiceChat.AdvisorJoin(JoinSuccess, JoinFailed);
            return false;
        }
        function JoinSuccess(result) {
            if (result != '<%= Guid.Empty %>') {
                window.location = "AdvisorChat.aspx?id=" + result;
            }
            else {
                setTimeout(Join, 2000);
            }
        }

        function JoinFailed(result) {
            setTimeout(Join, 1000);
        }

        function AdvisorReady() {
            your.namespace.com.IServiceChat.AdvisorReady(advisorID(), AdvisorReadySuccess, AdvisorReadyFailed);
            return false;
        }

        function OnReadyButtonDown() {
            clearTimeout(chatEndedTimeout)
            messageID = 0;
            ClearChat();
            AdvisorReady();

            return false;
        }

        function End() {
            your.namespace.com.IServiceChat.EndChat(advisorID(), EndChatSuccess);
            return false;
        }

        function EndChatSuccess() {
            AddMessage("Chat has ended.");
            chatEndedTimeout = setTimeout(ChatEnded, 90000);
        }

        function ChatEnded() {
            var chatList = document.getElementById('<%= tbMessages.ClientID %>');

            chatList.innerHTML = "Click here, when you are ready to chat with a new client";

            var lastMessage = document.getElementById('<%= lblLastMessage.ClientID %>');

            lastMessage.innerHTML = "";

            var childInfo = document.getElementById('<%= lblChildInfo.ClientID %>');

            childInfo.innerHTML = "";

            var lblBegin = document.getElementById('<%= lblBegin.ClientID %>');

            lblBegin.innerHTML = "";
        }

        function ClearChat() {
            var chatList = document.getElementById('<%= tbMessages.ClientID %>');

            chatList.innerHTML = "";

            var lastMessage = document.getElementById('<%= lblLastMessage.ClientID %>');

            lastMessage.innerHTML = "";

            var childInfo = document.getElementById('<%= lblChildInfo.ClientID %>');

            childInfo.innerHTML = "";

            var lblBegin = document.getElementById('<%= lblBegin.ClientID %>');

            lblBegin.innerHTML = "";
        }

        function AdvisorReadySuccess(child) {
            if (child != null) {
                var childInfo = document.getElementById('<%= lblChildInfo.ClientID %>');
                var childInfoTxt = "ID: " + child.ChildID;
                childInfo.innerHTML = childInfoTxt;
                document.getElementById('<%= lblSexValue.ClientID %>').innerHTML = child.Gender == your.namespace.com.Gender.Male ? "Male" : child.Gender == your.namespace.com.Gender.Female ? "Female" : "Unknown";
                document.getElementById('<%= lblChatBeforeValue.ClientID %>').innerHTML = child.UsedChatBefore == 0 ? "No" : "Yes";
                document.getElementById('<%= lblReferenceValue.ClientID %>').innerHTML = child.Reference;
                document.getElementById('<%= lblMunicipalityValue.ClientID %>').innerHTML = child.Municipality;
                document.getElementById('<%= lblAgeValue.ClientID %>').innerHTML = child.Age;
            }
            else {
                WaitQueue();
                setTimeout(AdvisorReady, 1000);
            }
        }

        function AdvisorReadyFailed(result) {
            setTimeout(AdvisorReady, 1000);
        }

        function WaitQueue() {
            your.namespace.com.IServiceChat.QueueCount('<%= Guid.Empty %>', WaitQueueComplete, WaitQueueFailed);
        }
        function WaitQueueComplete(result) {
            try {
                if (result >= 0) {
                    var lbl = document.getElementById('<%= lblChildInfo.ClientID %>');
                    lbl.innerHTML = "Waiting for user";
                }
            } catch (e) {

            }

        }

        function WaitQueueFailed(result) {
            setTimeout(WaitQueue, 1000);
        }

        function Say() {
            var message = document.getElementById('<%= tbNewMessage.ClientID %>');
            your.namespace.com.IServiceChat.AdvisorSay(advisorID(), message.value, SaySuccess, SayFailed);
            isWriting = false;
            return false;
        }
        function SaySuccess(result) {
            var message = document.getElementById('<%= tbNewMessage.ClientID %>');
            message.value = "";
            Writing();
            return false;
        }

        function SayFailed(result) {
        }

        function Status() {
            if (!statusUpdating) {
                statusUpdating = true;
                your.namespace.com.IServiceChat.AdvisorStatus(advisorID(), messageID, StatusComplete, StatusFailed);
                your.namespace.com.IServiceChat.GetChildActive(advisorID(), ActiveCheckComplete);
            }
        }

        function ActiveCheckComplete(status) {
            var lbl = document.getElementById('<%= lblActiveStatus.ClientID %>');
            if (status) {

                lbl.innerHTML = "Client is typing...";
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
                            enableControls(message.Status == 2 ? false : true);
                            var when = ConvertDateTimeToString(message.Received, false);
                            var who = message.From == advisorID() ? "<strong>Me:</strong>" : message.From == '<%= Guid.Empty %>' ? "" : "<b>Client:</b>";
                            updateLastMessage(message.Received, '<%= lblLastMessage.ClientID %>');
                            if (message.MessageType == 1) {
                                updateLastMessage(message.Received, '<%= lblBegin.ClientID %>');
                            }
                            AddMessage(when + " " + who + " " + message.Text);

                            if (message.MessageType == your.namespace.com.eMessageType.Leave) {
                                EndChatSuccess();
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
                your.namespace.com.IServiceChat.SetAdvisorActive(advisorID(), true);
            }

            var textbox = document.getElementById('<%= tbNewMessage.ClientID %>');

            if (textbox.value == "") {
                isWriting = false;
                your.namespace.com.IServiceChat.SetAdvisorActive(advisorID(), false);
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
            if (includeSeconds) {
                txt += ":" + (seconds < 10 ? "0" + seconds : seconds);
            }
            return txt;
        }

    </script>
</asp:Content>
<asp:Content ID="Content3" runat="server" ContentPlaceHolderID="ContentPlaceHolderTopRight">
    <div style="text-align: left;">
        <asp:Label ID="lblBeginTxt" runat="server" Text="Chat started at:"></asp:Label>
        &nbsp;
        <asp:Label ID="lblBegin" runat="server" Text=""></asp:Label>
        <br />
        <asp:Label ID="lblLastMessageTxt" runat="server" Text="Last message at:"></asp:Label>
        &nbsp;
        <asp:Label ID="lblLastMessage" runat="server" Text=""></asp:Label>
        <br />
        <asp:Label ID="lblChildInfo" runat="server" />
    </div>
</asp:Content>
<asp:Content ID="Content4" runat="server" ContentPlaceHolderID="ContentPlaceHolderTopCenter">
    <div style="text-align: left;">
        <asp:Label ID="lblSex" runat="server" Text="Sex:"></asp:Label>
        &nbsp;
        <asp:Label ID="lblSexValue" runat="server" Text=""></asp:Label>
        <br />
        <asp:Label ID="lblAge" runat="server" Text="Age:"></asp:Label>
        &nbsp;
        <asp:Label ID="lblAgeValue" runat="server" Text=""></asp:Label>
        <br />
        <asp:Label ID="lblChatBefore" runat="server" Text="New user:"></asp:Label>
        &nbsp;
        <asp:Label ID="lblChatBeforeValue" runat="server" Text=""></asp:Label>
        <br />
        <asp:Label ID="lblReference" runat="server" Text="Reference:"></asp:Label>
        &nbsp;
        <asp:Label ID="lblReferenceValue" runat="server" Text=""></asp:Label>
        <br />
        <asp:Label ID="lblMunicipality" runat="server" Text="Municipality:"></asp:Label>
        &nbsp;
        <asp:Label ID="lblMunicipalityValue" runat="server" Text=""></asp:Label>
    </div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <table width="100%" cellpadding="5">
        <tr>
            <td>
                <table width="98%">
                    <tr>
                        <td>
                            <asp:Panel ID="tbMessages" runat="server" Font-Names="Verdana" BorderColor="LightBlue"
                                BorderStyle="Solid" BorderWidth="2px" Style="padding: 10px;" Width="585px" Height="300px"
                                ScrollBars="Auto">
                            </asp:Panel>
                        </td>
                        <td id="rightImage" style="vertical-align: bottom; width: 106px;">
                            <asp:Button ID="btnPrint" runat="server" Text="Print" Height="25px" Width="75px"
                                Style="margin: 5px 15px;" SkinID="btnIgnore" />
                            <asp:Button ID="btnPause" runat="server" Text="Online" Height="25px" Width="75px" Style="margin: 5px 15px;"
                                OnClientClick="javascript:return OnReadyButtonDown();" SkinID="btnOK" />
                            <asp:Button ID="btnEnd" runat="server" Text="End" Height="25px" Width="75px" Style="margin: 5px 15px;"
                                OnClientClick="javascript:return End();" SkinID="btnExit" />
                        </td>
                    </tr>
                    <tr align="right">
                        <td colspan="2">
                            <asp:Label ID="lblActiveStatus" runat="server" Text=""></asp:Label>
                            &nbsp;
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
                                <asp:TextBox ID="tbNewMessage" runat="server" OnKeyUp="javascript:return Writing();"
                                    TextMode="MultiLine" Width="585px" BorderColor="LightBlue" BorderStyle="Solid"
                                    BorderWidth="2px" Style="padding: 10px;" Font-Names="Verdana" Height="75px"></asp:TextBox>
                            </td>
                            <td style="width: 106px;" align="right">
                                <asp:Button ID="btnSend" runat="server" Text="Send" Height="75px" Width="75px" OnClientClick="javascript:return Say();"
                                    SkinID="btnOK" /><br />
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
            </td>
        </tr>
    </table>
    <asp:HiddenField ID="hfAdvisorID" runat="server" />
</asp:Content>
