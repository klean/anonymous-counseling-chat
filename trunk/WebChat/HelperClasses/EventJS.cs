using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace WebChat
{
    public static partial class EventJS
    {
        /// <summary>
        /// Add an event to the Webcontrol if another event is assigned the script will be appended to the event
        /// </summary>
        /// <param name="ctrl">The WebControl to add the event to eg. a button</param>
        /// <param name="eventName">The name of the event eg. onclick</param>
        /// <param name="script">The Script to call when the event is fired</param>
        public static void SetWebControlEvent(HtmlControl ctrl, string eventName, string script)
        {
            if (ctrl != null)
            {
                if (ctrl.Attributes[eventName] != null && !ctrl.Attributes[eventName].Contains(script))
                {
                    ctrl.Attributes[eventName] += script;
                }
                else if (ctrl.Attributes[eventName] == null)
                {
                    ctrl.Attributes.Add(eventName, script);
                }
            }
        }

        /// <summary>
        /// Add an event to the Webcontrol if another event is assigned the script will be appended to the event
        /// </summary>
        /// <param name="ctrl">The WebControl to add the event to eg. a button</param>
        /// <param name="eventName">The name of the event eg. onclick</param>
        /// <param name="script">The Script to call when the event is fired</param>
        public static void SetWebControlEvent(WebControl ctrl, string eventName, string script)
        {
            if (ctrl != null)
            {
                if (ctrl.Attributes[eventName] != null && !ctrl.Attributes[eventName].Contains(script))
                {
                    ctrl.Attributes[eventName] += script;
                }
                else if (ctrl.Attributes[eventName] == null)
                {
                    ctrl.Attributes.Add(eventName, script);
                }
            }
        }

        /// <summary>
        /// Add an event to the Webcontrol if another event is assigned the script will be appended to the event
        /// </summary>
        /// <param name="ctrl">The WebControl to add the event to eg. a button</param>
        /// <param name="eventName">The name of the event eg. onclick</param>
        /// <param name="script">The Script to call when the event is fired</param>
        public static void SetWebControlEvent(UserControl ctrl, string eventName, string script)
        {
            if (ctrl != null)
            {
                if (ctrl.Attributes[eventName] != null && !ctrl.Attributes[eventName].Contains(script))
                {
                    ctrl.Attributes[eventName] += script;
                }
                else if (ctrl.Attributes[eventName] == null)
                {
                    ctrl.Attributes.Add(eventName, script);
                }
            }
        }

        /// <summary>
        /// Iterates through all the controls of the first control and 
        /// recursiv calling this funktion again until the control has no more sub Controls.
        /// If one control is a Button or a LinkButton, the eventscript will be added to the event
        /// </summary>
        /// <param name="ctrl">The Control to iterate through</param>
        /// <param name="eventString">the name of the event to assign</param>
        /// <param name="eventScript">The script to assign to the event</param>
        public static void AddEventToAllSubmitItems(Control ctrl, string eventString, string eventScript)
        {
            foreach (Control control in ctrl.Controls)
            {
                if (control != null)
                {
                    AddEventToAllSubmitItems(control, eventString, eventScript);
                }
            }
            if (ctrl.GetType() == typeof(Button) || ctrl.GetType() == typeof(LinkButton) || ctrl.GetType() == typeof(ImageButton))
            {
                SetWebControlEvent((WebControl)ctrl, eventString, eventScript);
            }
        }

        public static void AddControlScript(Page page, string eventName, Control control, string script, params Control[] parameters)
        {
            string functionname;

            if (Format.GetFunctionNameFromScript(script, out functionname))
            {
                string parameterList = "";
                foreach (Control ctrl in parameters)
                {
                    if (control.ClientID == ctrl.ClientID)
                    {
                        parameterList += "this, ";
                    }
                    else
                    {
                        parameterList += "document.all." + ctrl.ClientID + ", ";
                    }
                }
                parameterList = parameterList.Length > 0 ? parameterList.Substring(0, parameterList.Length - 2) : parameterList;

                if (control is WebControl)
                {
                    SetWebControlEvent((WebControl)control, eventName, functionname + "(" + parameterList + ");");
                }
                else if (control is UserControl)
                {
                    SetWebControlEvent((UserControl)control, eventName, functionname + "(" + parameterList + ");");
                }
                else
                {
                    SetWebControlEvent((HtmlControl)control, eventName, functionname + "(" + parameterList + ");");
                }

                if (!page.ClientScript.IsStartupScriptRegistered(functionname + "_script"))
                {
                    page.ClientScript.RegisterStartupScript(typeof(Page), functionname + "_script", script + "\r\n", true);
                }
            }
        }
    }
}