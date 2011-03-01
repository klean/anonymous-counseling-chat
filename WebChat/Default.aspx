<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="Default.aspx.cs" Inherits="WebChat.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        function OnLoad() {
            //Join();
        }
        function Join() {
            var male = document.getElementById('<%=ddlbGender.ClientID %>').value;
            var age = document.getElementById('<%=tbAge.ClientID %>').value;
            if (isNaN(age))
                age = 0;

            var chatBefore = document.getElementById('<%=ddlbChatBeforeYes.ClientID %>').value;

            var ddReference = document.getElementById('<%= ddlReference.ClientID %>');
            var index = ddReference.selectedIndex;
            var reference = ddReference.options[index].value;

            var ddlMunicipality = document.getElementById('<%= ddlMunicipality.ClientID %>');
            index = ddlMunicipality.selectedIndex;
            var municipality = ddlMunicipality.options[index].value;

            your.namespace.com.IServiceChat.ChildJoin(age, Number(male), Number(chatBefore), reference, municipality, JoinSuccess, JoinFailed);

            return false;
        }
        function JoinSuccess(result) {
            if (result != '<%= Guid.Empty %>') {
                window.location = "ClientQueue.aspx?id=" + result;
            }
            else {
                alert("Køen til chatten er nu så lang, at vi desværre er nødt til at lukke den. Det er derfor ikke muligt at stille sig i kø lige nu. Prøv igen senere.");
            }
        }

        function JoinFailed(result) {

        }
    </script>
</asp:Content>
<asp:Content ID="Content2" runat="server" ContentPlaceHolderID="ContentPlaceHolder1">
    <asp:Panel ID="Panel1" runat="server" DefaultButton="btnJoin">
        <table style="margin: 10px;" cellpadding="5">
            <tr>
                <td colspan="4">
                    <h1>
                        <asp:Label ID="lblHeader" runat="server" Text="Welcome to AnonymousChat" />
                    </h1>
                    <asp:Label ID="lblDescription" runat="server" Text="You don't have to fill out the form, but we would appreciate it..." />
                    <hr />
                </td>
            </tr>
            <tr>
                <td style="width: 300px;">
                    <b>
                        <asp:Label ID="lblGenderTxt" runat="server" Text="1. Sex?" /></b>
                </td>
                <td>
                    <asp:DropDownList ID="ddlbGender" runat="server">
                        <asp:ListItem Text="[Choose]" Value="0" Selected="True"></asp:ListItem>
                        <asp:ListItem Text="Male" Value="1"></asp:ListItem>
                        <asp:ListItem Text="Female" Value="2"></asp:ListItem>
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td>
                    <b>
                        <asp:Label ID="lblAge" runat="server" Text="2. Age?" /></b>
                </td>
                <td colspan="2">
                    <asp:TextBox ID="tbAge" runat="server" Width="20px" MaxLength="2" />
                    år
                    <asp:RequiredFieldValidator ID="RequiredFieldValidatorAge" runat="server" ControlToValidate="tbAge"
                        ErrorMessage="* age" SetFocusOnError="True" ValidationGroup="age"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td style="width: 300px;">
                    <b>
                        <asp:Label ID="lblChatBeforeText" runat="server" Text="3. Chatted with us before?" /></b>
                </td>
                <td>
                    <asp:DropDownList ID="ddlbChatBeforeYes" runat="server">
                        <asp:ListItem Text="[Choose]" Value="0" Selected="True"></asp:ListItem>
                        <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                        <asp:ListItem Text="No" Value="2"></asp:ListItem>
                    </asp:DropDownList>
                </td>
                <td>
                </td>
            </tr>
            <tr>
                <td>
                    <b>
                        <asp:Label ID="lblWhere" runat="server" Text="4. Where did you hear about us?" /></b>
                </td>
                <td colspan="2">
                    <asp:DropDownList ID="ddlReference" runat="server" Width="250px">
                        <asp:ListItem Text="[Choose]" Value="0" Selected="True" />
                        <asp:ListItem Text="Website" Value="Website" />
                        <asp:ListItem Text="Flyer" Value="Flyer" />
                        <asp:ListItem Text="Other" Value="Other" />
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td>
                    <b>
                        <asp:Label ID="lblMunicipality" runat="server" Text="6. State / Municipality" />
                    </b>
                </td>
                <td colspan="2">
                    <asp:DropDownList ID="ddlMunicipality" runat="server" Width="250px">
                        <asp:ListItem Selected="True" Text="[Choose]" Value="0" />
                        <asp:ListItem Text="Aarhus" Value="Aarhus"></asp:ListItem>
                        <asp:ListItem Text="Copenhagen" Value="Copenhagen"></asp:ListItem>
                    </asp:DropDownList>
                </td>
            </tr>
           
            <tr>
                <td colspan="3">
                </td>
                <td>
                    <asp:Button ID="btnJoin" runat="server" Text="Next" OnClientClick="javascript:return Join();" ValidationGroup="age" />
                </td>
            </tr>
            <tr>
                <td colspan="4">
                    <asp:Label ID="Label1" runat="server" Text="A lot of people is using the chat, and some waiting can occur." />
                </td>
            </tr>
        </table>
    </asp:Panel>
</asp:Content>
