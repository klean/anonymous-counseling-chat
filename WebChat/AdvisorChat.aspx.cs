using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Net;

namespace WebChat
{
    public partial class AdvisorChat : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            IPAddress ipRangeStart = IPAddress.Parse(ConfigurationSettings.AppSettings["IPRangeStart"]);
            IPAddress ipRangeEnd = IPAddress.Parse(ConfigurationSettings.AppSettings["IPRangeEnd"]);
            IPAddress userIp = IPAddress.Parse(Request.UserHostAddress);

            if (!(ipRangeStart.Address <= userIp.Address && userIp.Address <= ipRangeEnd.Address))
            {
                Response.Redirect("Default.aspx");
            }

            Print.PrintPreview(this, btnPrint, "Print chatlog", "AnonymousChat", tbMessages.ClientID);
            EventJS.SetWebControlEvent(btnPrint, "onClick", "return false;");
        }
    }
}