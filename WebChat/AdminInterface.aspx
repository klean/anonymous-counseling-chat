<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="AdminInterface.aspx.cs" Inherits="WebChat.AdminInterface" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">

        function OnLoad() {

            setInterval(WaitQueue, 1000);
        }

        function OpenQueue() {

            javachat.iservicechat.OpenQueue();

            return false;
        }

        function CloseQueue() {

            javachat.iservicechat.CloseQueue();

            return false;
        }

        function WaitQueue() {
            javachat.iservicechat.QueueCount('<%= Guid.Empty %>', WaitQueueComplete, WaitQueueFailed);
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
                        <asp:Label ID="lblHeader" runat="server" Text="AlbaHusChat Admin Interface" />
                    </h1>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <div style="float: right;">
                        <asp:Button ID="btnCloseQueue" runat="server" Text="Luk kø" OnClientClick="javascript:return CloseQueue();" />
                        &nbsp;
                        <asp:Button ID="btnOpenQueue" runat="server" Text="Åben kø" OnClientClick="javascript:return OpenQueue();" />
                    </div>
                </td>
            </tr>
        </table>
    </asp:Panel>
</asp:Content>
