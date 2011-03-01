<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="AdminInterface.aspx.cs" Inherits="WebChat.AdminInterface" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">

        var isQueueOpen = false;
        var queueStatusInterval = "";
        function OnLoad() {

            WaitQueue();
            QueueStatus();
            setInterval(WaitQueue, 1000);
            queueStatusInterval = setInterval(QueueStatus, 1500);
        }

        function OpenQueue() {

            clearInterval(queueStatusInterval);
            var btnOpen = document.getElementById('<%= btnOpenQueue.ClientID %>');
            btnOpen.disabled = true;
            your.namespace.com.IServiceChat.OpenQueue(QueueChangeCompleted, QueueChangeFailed);
            return false;
        }

        function CloseQueue() {

            clearInterval(queueStatusInterval);
            var btnClose = document.getElementById('<%= btnCloseQueue.ClientID %>');
            btnClose.disabled = true;
            your.namespace.com.IServiceChat.CloseQueue(QueueChangeCompleted, QueueChangeFailed);           
            
            return false;
        }

        function QueueChangeCompleted() {
            WaitQueue();
            queueStatusInterval = setInterval(QueueStatus, 1500);
        }

        function QueueChangeFailed() {
            WaitQueue();
            queueStatusInterval = setInterval(QueueStatus, 1500);
        }


        function WaitQueue() {
            your.namespace.com.IServiceChat.QueueCount('<%= Guid.Empty %>', WaitQueueComplete, WaitQueueFailed);
        }
        function WaitQueueComplete(result) {
            try {
                if (result >= 0) {
                    var lbl = document.getElementById('<%= lblQueueSizeValue.ClientID %>');
                    lbl.innerHTML = result;
                    
                }
            } catch (e) {

            }

        }

        function WaitQueueFailed(result) {
            
        }

        function QueueStatus() {
            your.namespace.com.IServiceChat.QueueStatus(QueueStatusComplete, QueueStatusFailed);
        }
        function QueueStatusComplete(result) {
            try {
                isQueueOpen = result;
                var btnClose = document.getElementById('<%= btnCloseQueue.ClientID %>');
                var btnOpen = document.getElementById('<%= btnOpenQueue.ClientID %>');
                btnOpen.disabled = false;
                btnClose.disabled = false;
                if (isQueueOpen) {
                    btnClose.style.visibility = "visible";
                    btnClose.style.display = "";
                    btnOpen.style.visibility = "hidden";
                    btnOpen.style.display = "none";
                }
                else {
                    btnClose.style.visibility = "hidden";
                    btnClose.style.display = "none";
                    btnOpen.style.visibility = "visible";
                    btnOpen.style.display = "";
                }
                
                
            } catch (e) {

            }

        }

        function QueueStatusFailed(result) {
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderTopRight" runat="server">
    <div style="float: left;">
        <asp:Label ID="lblQueueSize" runat="server" Text="Antal personer i kø:" />
        &nbsp;
        <asp:Label ID="lblQueueSizeValue" runat="server" Text="" />
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolderTopCenter" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Panel ID="Panel1" runat="server" DefaultButton="btnCloseQueue">
        <table style="margin: 10px;" cellpadding="5" width="97%">
            <tr>
                <td colspan="2">
                    <h1>
                        <asp:Label ID="lblHeader" runat="server" Text="AnnonymousChat Admin Interface" />
                    </h1>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <div style="float: right;">
                        <asp:Button ID="btnCloseQueue" runat="server" Text="Køen er åben" OnClientClick="javascript:return CloseQueue();" style=" display: none; visibility: hidden; margin-right:5px; width: 125px; height:90px; background-color: #9cbf1a;" />
                        <asp:Button ID="btnOpenQueue" runat="server" Text="Køen er lukket" OnClientClick="javascript:return OpenQueue();" style=" display: none; visibility: hidden;  margin-right:5px; width: 125px; height:90px; background-color: #bf1a1a;"/>
                    </div>
                </td>
            </tr>
        </table>
    </asp:Panel>
</asp:Content>
