using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace WebChat
{
    public static partial class Print
    {
        public static void PrintPreview(Page page, WebControl ctrl, string title, string theme, params string[] divIDs)
        {
            PrintPreview(page, ctrl, title, theme, false, null, "", divIDs);
        }

        public static void PrintPreview(Page page, HtmlControl ctrl, string title, string theme, params string[] divIDs)
        {
            PrintPreview(page, ctrl, title, theme, false, null, "", divIDs);
        }

        public static void PrintPreview(Page page, WebControl ctrl, string title, string theme, bool runCustomHideScript, params string[] divIDs)
        {
            PrintPreview(page, ctrl, title, theme, runCustomHideScript, null, "", divIDs);
        }

        public static void PrintPreview(Page page, HtmlControl ctrl, string title, string theme, bool runCustomHideScript, params string[] divIDs)
        {
            PrintPreview(page, ctrl, title, theme, runCustomHideScript, null, "", divIDs);
        }

        public static void PrintPreview(Page page, WebControl ctrl, string title, string theme, bool runCustomHideScript, GridView grid, string removeColumns, params string[] divIDs)
        {
            PrintPreview(page, ctrl, null, title, theme, runCustomHideScript, grid, removeColumns, divIDs);
        }

        public static void PrintPreview(Page page, HtmlControl ctrl, string title, string theme, bool runCustomHideScript, GridView grid, string removeColumns, params string[] divIDs)
        {
            PrintPreview(page, null, ctrl, title, theme, runCustomHideScript, grid, removeColumns, divIDs);
        }

        public static void PrintPreview(Page page, WebControl ctrl, string title, string theme, GridView grid, string removeColumns, params string[] divIDs)
        {
            PrintPreview(page, ctrl, null, title, theme, false, grid, removeColumns, divIDs);
        }

        public static void PrintPreview(Page page, HtmlControl ctrl, string title, string theme, GridView grid, string removeColumns, params string[] divIDs)
        {
            PrintPreview(page, null, ctrl, title, theme, false, grid, removeColumns, divIDs);
        }

        private static void PrintPreview(Page page, WebControl ctrlWeb, HtmlControl ctrlHtml, string title, string theme, bool runCustomHideScript, GridView grid, string removeColumns, params string[] divIDs)
        {
            string script =
                @"  
                function getPrint(pp, print_area, gridViewID, removeColumns, runCustomHideScript)
                {
                    var strArray = print_area.split("","");
                    pp.document.writeln(""<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>"");
                    pp.document.writeln(""<html xmlns='http://www.w3.org/1999/xhtml'>"");
                    pp.document.writeln(""<HEAD>"");
                    pp.document.writeln(""<link href='../App_Themes/" +
                theme + "/" + theme +
                @".css' type='text/css' rel='stylesheet' /><\/link>"");                    
                    pp.document.writeln(""<title>" +
                title +
                @"<\/title>"");                    
                    pp.document.writeln(""<base target='_self'>"");
                    pp.document.writeln(""<script type='text/javascript'>"");
                    pp.document.writeln(""function expandTA(ta) {"");
                    pp.document.writeln(""try {"");
                    pp.document.writeln(""var minRows = ta.minRows != null ? ta.minRows : 1;"");
                    pp.document.writeln(""while (ta.rows > minRows && ta.scrollHeight < ta.offsetHeight){"");
	                pp.document.writeln(""ta.rows--;"");
                    pp.document.writeln(""}"");
                    pp.document.writeln(""var h=0;"");
                    pp.document.writeln(""while (ta.scrollHeight > ta.offsetHeight && h!==ta.offsetHeight)"");
                    pp.document.writeln(""{"");
	                pp.document.writeln(""h=ta.offsetHeight;"");
	                pp.document.writeln(""ta.rows++;"");
                    pp.document.writeln(""}"");
                    pp.document.writeln(""ta.rows++;"");          
                    pp.document.writeln(""}"");
                    pp.document.writeln(""catch (ex) { }"");
                    pp.document.writeln(""}"");
                    pp.document.writeln(""function expandAllTA() {"");
                    pp.document.writeln(""try {"");
                    pp.document.writeln(""var items = document.getElementsByTagName('textarea');"");
                    pp.document.writeln(""for (var i = 0; i < items.length; i++) {"");
                    pp.document.writeln(""expandTA(items[i]);"");
                    pp.document.writeln(""}"");
                    pp.document.writeln(""}"");
                    pp.document.writeln(""catch (ex) { }"");
                    pp.document.writeln(""}"");   
                    pp.document.writeln(""<\/script"");
                    pp.document.writeln(""<\/HEAD>"");
                    pp.document.writeln(""<body MS_POSITIONING='GridLayout' bottomMargin='0'"");
                    pp.document.writeln(""leftMargin='0' topMargin='0' rightMargin='0'>"");
                    pp.document.writeln(""<form method='post'>"");
                    //Writing print area of the calling page
                    var columns = removeColumns.split("","");
                    var grid = document.getElementById(gridViewID);
                    if(grid != null)
                    {
                        for(var i = 0; i < grid.rows.length; i++)
                        {
                            for(var j = columns.length-1; j >= 0; j--)
                            {
                                grid.rows[i].deleteCell(Number(columns[j]));                                                                 
                            }
                        }
                    }
                    for(var i=0; i<strArray.length;i++) 
                    {
                        if(document.getElementById(strArray[i]) != null)
                        {
                            pp.document.writeln(document.getElementById(strArray[i]).innerHTML);
                        }
                    }
                    function expandTA1(ta) 
                    {
                        try {
                            var minRows = ta.minRows != null ? ta.minRows : 1;
                            while (ta.rows > minRows && ta.scrollHeight < ta.offsetHeight){
	                            ta.rows--;
                            }
                            var h=0;
                            while (ta.scrollHeight > ta.offsetHeight && h!==ta.offsetHeight)
                            {
	                            h=ta.offsetHeight;
	                            ta.rows++;
                            }
                            ta.rows++;
                        }
                        catch (ex) 
                        {
                        }
                    }
                    function expandAllTA1() {
                        try {
                            var items = document.getElementsByTagName(""textarea"");
                            for (var i = 0; i < items.length; i++) {
                                expandTA1(items[i]);
                            }
                        }
                        catch (ex) 
                        {
                        }
                    }
                    expandAllTA1(); 
                    pp.document.writeln(""<script type='text/javascript'>"");
                    pp.document.writeln(""var spans = document.getElementsByTagName('span');"");
                    pp.document.writeln(""for (var i = 0; i < spans.length; i++) {"");
                    pp.document.writeln(""spans[i].style.color = 'black'"");
                    pp.document.writeln(""}"");
                    pp.document.writeln(""expandAllTA();"");
                    if(runCustomHideScript == ""true"")
                    {
                        pp.document.writeln(""try{hideFromPrint();}catch(ex){}"");
                    }
                    pp.document.writeln(""if (window.print) {setTimeout('window.print();', 2000); }"");
                    pp.document.writeln(""<\/script"");
                    pp.document.writeln(""<\/form>"");
                    pp.document.writeln(""<\/body>"");
                    pp.document.writeln(""<\/HTML>"");
                } 
                ";
            if (!page.ClientScript.IsClientScriptBlockRegistered("getPrint_script"))
            {
                page.ClientScript.RegisterStartupScript(typeof(Page), "getPrint_script", script + "\r\n", true);
            }
            string divID = "";
            foreach (string s in divIDs)
            {
                divID += s + ",";
            }
            divID = divID.Length > 0 ? divID.Substring(0, divID.Length - 1) : "";
            string gridID = (grid != null ? grid.ClientID : null);
            string columns = (removeColumns != null ? removeColumns : "");
            string eventName = "onClick";
            string eventScript = "var pp = window.open();getPrint(pp, \"" + divID + "\", \"" + gridID + "\", \"" + columns + "\", \"" + (runCustomHideScript ? "true" : "false") + "\");return false;";
            if (ctrlWeb != null)
                EventJS.SetWebControlEvent(ctrlWeb, eventName, eventScript);
            else if (ctrlHtml != null)
                EventJS.SetWebControlEvent(ctrlHtml, eventName, eventScript);
        }

        public static void PrintPage(Page page, int timeout, bool closeAfter)
        {
            string script = "<script language=javascript>\r\n";
            script += "\twindow.setTimeout('javascript:expandAllTA();window.print();', " + timeout + ");\r\n";
            script += closeAfter ? "\twindow.setTimeout('javascript:window.close();', " + (timeout + 200) + ");\r\n" : "";
            script += "</script>";
            page.Response.Write(script);
        }



    }
}