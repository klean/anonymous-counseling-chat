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
            javachat.iservicechat.AdvisorJoin(JoinSuccess, JoinFailed);
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
            javachat.iservicechat.AdvisorReady(advisorID(), AdvisorReadySuccess, AdvisorReadyFailed);
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
            javachat.iservicechat.EndChat(advisorID(), EndChatSuccess);
            return false;
        }

        function EndChatSuccess() {
            AddMessage("Chatten er afsluttet.");
            chatEndedTimeout = setTimeout(ChatEnded, 90000);
        }

        function ChatEnded() {
            var chatList = document.getElementById('<%= tbMessages.ClientID %>');

            chatList.innerHTML = "Klik på klar når du vil tale med en ny klient";

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
                //childInfoTxt += " - <b>" + (child.Gender == 0 ? "Dreng" : "Pige") + (child.Age > 0 ? ", " + child.Age + " år" : "") + "</b>";
                childInfo.innerHTML = childInfoTxt;
                document.getElementById('<%= lblSexValue.ClientID %>').innerHTML = child.Gender == 0 ? "Mand/Dreng" : "Kvinde/Pige";
                document.getElementById('<%= lblChatBeforeValue.ClientID %>').innerHTML = child.UsedChatBefore == 0 ? "Nej" : "Ja";
                document.getElementById('<%= lblReferenceValue.ClientID %>').innerHTML = child.Reference;
                document.getElementById('<%= lblLocationValue.ClientID %>').innerHTML = child.Location;
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
            javachat.iservicechat.QueueCount('<%= Guid.Empty %>', WaitQueueComplete, WaitQueueFailed);
        }
        function WaitQueueComplete(result) {
            try {
                if (result >= 0) {
                    var lbl = document.getElementById('<%= lblChildInfo.ClientID %>');
                    lbl.innerHTML = "Venter på barn, der er " + result + " i kø...";
                }
            } catch (e) {

            }

        }

        function WaitQueueFailed(result) {
            setTimeout(WaitQueue, 1000);
        }

        function Say() {
            var message = document.getElementById('<%= tbNewMessage.ClientID %>');
            javachat.iservicechat.AdvisorSay(advisorID(), message.value, SaySuccess, SayFailed);
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
                javachat.iservicechat.AdvisorStatus(advisorID(), messageID, StatusComplete, StatusFailed);
                javachat.iservicechat.GetChildActive(advisorID(), ActiveCheckComplete);
            }
        }

        function ActiveCheckComplete(status) {
            var lbl = document.getElementById('<%= lblActiveStatus.ClientID %>');
            if (status) {

                lbl.innerHTML = "Barnet taster...";
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
                            var who = message.From == advisorID() ? "<strong>Mig:</strong>" : message.From == '<%= Guid.Empty %>' ? "" : "<b>Barn:</b>";
                            updateLastMessage(message.Received, '<%= lblLastMessage.ClientID %>');
                            if (message.MessageType == 1) {
                                updateLastMessage(message.Received, '<%= lblBegin.ClientID %>');
                            }
                            AddMessage(when +" "+ who + " " + message.Text);

                            if (message.MessageType == JavaChat.eMessageType.Leave) {
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
                javachat.iservicechat.SetAdvisorActive(advisorID(), true);
            }

            var textbox = document.getElementById('<%= tbNewMessage.ClientID %>');

            if (textbox.value == "") {
                isWriting = false;
                javachat.iservicechat.SetAdvisorActive(advisorID(), false);
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

//        function CloseQueue() {

//            javachat.iservicechat.CloseQueue(5,false);

//            return false;
//        }

    </script>
</asp:Content>
<asp:Content ID="Content3" runat="server" contentplaceholderid="ContentPlaceHolderTopRight">
    
                            <div style="text-align: left;">
                                <asp:Label ID="lblBeginTxt" runat="server" Text="Samtalen startede kl.:"></asp:Label>
                                &nbsp;
                                <asp:Label ID="lblBegin" runat="server" Text=""></asp:Label>
                            
                            <br />
                            
                                <asp:Label ID="lblLastMessageTxt" runat="server" Text="Sidste indtastning kl.:"></asp:Label>
                            &nbsp;
                            <asp:Label ID="lblLastMessage" runat="server" Text=""></asp:Label>
                            
                            <br />
                                <asp:Label ID="lblChildInfo" runat="server" />
                            </div>
                            
</asp:Content>

<asp:Content ID="Content4" runat="server" contentplaceholderid="ContentPlaceHolderTopCenter">
                            <div style="text-align: left;">
                                <asp:Label ID="lblSex" runat="server" Text="Køn:"></asp:Label>
                                &nbsp;
                                <asp:Label ID="lblSexValue" runat="server" Text=""></asp:Label>
                            <br />
                                <asp:Label ID="lblAge" runat="server" Text="Alder:"></asp:Label>
                                &nbsp;
                                <asp:Label ID="lblAgeValue" runat="server" Text=""></asp:Label>
                            <br />
                                <asp:Label ID="lblChatBefore" runat="server" Text="Chattet her før:"></asp:Label>
                                &nbsp;
                                <asp:Label ID="lblChatBeforeValue" runat="server" Text=""></asp:Label>
                            
                            <br />
                                <asp:Label ID="lblReference" runat="server" Text="Reference:"></asp:Label>
                                &nbsp;
                                <asp:Label ID="lblReferenceValue" runat="server" Text=""></asp:Label>
                            <br />
                                <asp:Label ID="lblLocation" runat="server" Text="Bopælsregion:"></asp:Label>
                                &nbsp;
                                <asp:Label ID="lblLocationValue" runat="server" Text=""></asp:Label>
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
                                BorderStyle="Solid" BorderWidth="2px" Style="padding: 10px;" Width="535px" Height="300px"
                                ScrollBars="Auto">
                            </asp:Panel>
                        </td>
                        <td id="rightImage" style=" vertical-align: bottom;">
                        <asp:Button ID="btnPrint" runat="server" Text="Print" Height="25px" Width="75px" 
                                style="margin: 5px;" SkinID="btnIgnore" />
                        <asp:Button ID="btnPause" runat="server" Text="Klar" Height="25px" Width="75px" style="margin: 5px;" OnClientClick="javascript:return OnReadyButtonDown();" SkinID="btnOK" />
                        <asp:Button ID="btnEnd" runat="server" Text="Afslut" Height="25px" Width="75px" style="margin: 5px;" OnClientClick="javascript:return End();" SkinID="btnExit" />
                        <%--<asp:Button ID="btnEndInFive" runat="server" Text="Luk kø" Height="25px" Width="75px" style="margin: 5px;" OnClientClick="javascript:return CloseQueue();" SkinID="btnExit" />--%>
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
                                    TextMode="MultiLine" Width="535px" BorderColor="LightBlue" BorderStyle="Solid"
                                    BorderWidth="2px" Style="padding: 10px;" Font-Names="Verdana" 
                                    Height="75px"></asp:TextBox>
                            </td>
                            <td style="width: 106px;" align="right">
                                <asp:Button ID="btnSend" runat="server" Text="Send" Height="75px" Width="75px" OnClientClick="javascript:return Say();" SkinID="btnOK" /><br />
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
            </td>
        </tr>
    </table>
    <asp:HiddenField ID="hfAdvisorID" runat="server" />
</asp:Content>


