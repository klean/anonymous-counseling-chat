<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="Default.aspx.cs" Inherits="WebChat.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        function OnLoad() {
            //Join();
        }
        function Join() {
            var male = document.getElementById('<%=rbGenderMale.ClientID %>').checked;

            var age = document.getElementById('<%=tbAge.ClientID %>').value;
            if (isNaN(age))
                age = 0;

            var chatBefore = document.getElementById('<%=rbChatBeforeYes.ClientID %>').checked;

            var ddReference = document.getElementById('<%= ddlReference.ClientID %>');
            var index = ddReference.selectedIndex;
            var reference = ddReference.options[index].value;

            var ddLocation = document.getElementById('<%= ddlLocation.ClientID %>');
            index = ddLocation.selectedIndex;
            var location = ddLocation.options[index].value;

            javachat.iservicechat.ChildJoin(age, male, chatBefore, reference, location, JoinSuccess, JoinFailed);

            return false;
        }
        function JoinSuccess(result) {
            if (result != '<%= Guid.Empty %>') {
                window.location = "ChildQueue.aspx?id=" + result;
            }
            else {
                alert("Køen til chatten er nu så lang at vi desværre er nødt til at lukke den. Det er derfor ikke muligt at stille sig i kø lige nu. Prøv igen senere");
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
                        <asp:Label ID="lblHeader" runat="server" Text="Velkommen til AlbaHusChatten" />
                    </h1>
                    <asp:Label ID="lblDescription" runat="server" Text="Spørgsmålene nedenfor hjælper rådgiveren til at sikre, at du får en god samtale. Det er friviligt om og hvor mange af spørgsmålene du vil besvare. Når du trykker &quot;videre&quot; kommer du i kø til AlbaHusChatten." />
                    <hr />
                </td>
            </tr>
            <tr>
                <td style="width: 300px;">
                    <b>
                        <asp:Label ID="lblGenderTxt" runat="server" Text="1. Hvilket køn er du?" /></b>
                </td>
                <td>
                    <asp:RadioButton ID="rbGenderMale" runat="server" Text="Mand/Dreng" Checked="True" GroupName="Gender" />
                </td>
                <td>
                    <asp:RadioButton ID="rbGenderFemale" runat="server" Text="Kvinde/Pige" GroupName="Gender" />
                </td>
                <td>
                </td>
            </tr>
            <tr>
                <td>
                    <b>
                        <asp:Label ID="lblAge" runat="server" Text="2. Hvor gammel er du?" /></b>
                </td>
                <td colspan="2">
                    <asp:TextBox ID="tbAge" runat="server" width="20px" MaxLength="2" /> år
                </td>
            </tr>
            <tr>
                <td style="width: 300px;">
                    <b>
                        <asp:Label ID="lblChatBeforeText" runat="server" Text="4. Har du chattet med os før?" /></b>
                </td>
                <td>
                    <asp:RadioButton ID="rbChatBeforeYes" runat="server" Text="Ja"  Checked="True" GroupName="ChatBefore" />
                </td>
                <td>
                    <asp:RadioButton ID="rbChatBeforeNo" runat="server" Text="Nej" GroupName="ChatBefore" />
                </td>
                <td>
                </td>
            </tr>
            <tr>
                <td>
                    <b>
                        <asp:Label ID="lblWhere" runat="server" Text="5. Hvor har du hørt om AlbaHus?" /></b>
                </td>
                <td colspan="2">
                    <asp:DropDownList ID="ddlReference" runat="server" Width="250px">
                        <asp:ListItem Text="Vælg svar" Value="0" Selected="True" />
                        <asp:ListItem Text="AlbaHus hjemmeside" Value="AlbaHus hjemmeside" />
                        <asp:ListItem Text="Pjece eller andet trykt oplysningsmateriale" Value="Pjece eller andet trykt oplysningsmateriale" />
                        <asp:ListItem Text="Tekst eller onlineannonce" Value="Tekst eller onlineannonce" />
                        <asp:ListItem Text="Socialforvaltning, Politi" Value="Socialforvaltning, Politi" />
                        <asp:ListItem Text="Læge, psykolog eller andet sundhedspersonale" Value="Læge, psykolog eller andet sundhedspersonale" />
                        <asp:ListItem Text="Støttecenter, terapeut eller behandler i privat regi" Value="Støttecenter, terapeut eller behandler i privat regi" />
                        <asp:ListItem Text="Venner eller bekendte" Value="Venner eller bekendte" />
                        <asp:ListItem Text="Familie" Value="Familie" />
                        <asp:ListItem Text="Presse" Value="Presse" />
                        <asp:ListItem Text="Andet" Value="Andet" />
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td>
                    <b>
                        <asp:Label ID="lblLocation" runat="server" Text="6. Bopælsregion" /></b>
                </td>
                <td colspan="2">
                    <asp:DropDownList ID="ddlLocation" runat="server" Width="250px">
                        <asp:ListItem Text="Vælg svar" Value="0" Selected="True" />
                        <asp:ListItem Text="Hovedstaden" Value="Hovedstaden" />
                        <asp:ListItem Text="Sjælland" Value="Sjælland" />
                        <asp:ListItem Text="Syddanmark" Value="Syddanmark" />
                        <asp:ListItem Text="Midtjylland" Value="Midtjylland" />
                        <asp:ListItem Text="Nordjylland" Value="Nordjylland" />
                    </asp:DropDownList>
                </td>
            </tr>

            <tr>
                <td valign="top">
                    <b>
                        <asp:Label ID="lblHusk" runat="server" Text="Husk!"  /></b>
                </td>
                <td colspan="2">
                    <asp:Label ID="anonym" runat="server" Text="Du må være "/> <asp:HyperLink NavigateUrl="http://www.albahus.dk/page_unge.asp?id_page=11&id_page_sub1=259&id_page_sub2=84" runat="server" Target="_blank" Text="anonym" /> <br />
                    <asp:Label ID="Label3" runat="server" Text="Vi har " /><asp:HyperLink NavigateUrl="http://www.albahus.dk/page_unge.asp?id_page=11&id_page_sub1=259&id_page_sub2=85" runat="server" Target="_blank" Text="tavshedspligt" /> <br />
                    <asp:Label ID="Label4" runat="server" Text="Vi har " /><asp:HyperLink NavigateUrl="http://www.albahus.dk/page_unge.asp?id_page=11&id_page_sub1=259&id_page_sub2=85" runat="server" Target="_blank" Text="underretningspligt"/> <br />
                    <asp:Label ID="Label5" runat="server" Text="Vi tager korte " /><asp:HyperLink NavigateUrl="http://www.albahus.dk/page_unge.asp?id_page=11&id_page_sub1=259&id_page_sub2=85" runat="server" Target="_blank" Text="noter" /><asp:Label ID="Label6" runat="server" Text=" af vores samtaler"/>
                </td>
            </tr>
            <tr>
                <td colspan="3">
                </td>
                <td>
                    <asp:Button ID="btnJoin" runat="server" Text="Videre" OnClientClick="javascript:return Join();" />
                </td>
            </tr>
            <tr>
                <td colspan="4">
                    <asp:Label ID="Label1" runat="server" Text="Der er mange, der gerne vil bruge AlbaHusChatten, så ind imellem kan der være lang ventetid i køen. Bruge for eksempel tiden på at kigge på AlbaHus.dk, hvor mange finder god hjælp" />
                </td>
            </tr>
        </table>
    </asp:Panel>
</asp:Content>
