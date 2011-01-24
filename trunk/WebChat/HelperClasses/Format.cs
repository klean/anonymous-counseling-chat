using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebChat
{
    public static partial class Format
    {
        public static string JavaLineBreak(string inputStr)
        {
            string str = inputStr;
            if (!string.IsNullOrEmpty(inputStr))
            {
                str = str.Replace("\\", "\\\\").Replace("\r", "\\r").Replace("\n", "\\n").Replace("\t", "\\t");
            }
            return str;
        }
        public static string HTML2CodeBehind(string inputStr)
        {
            if (!string.IsNullOrEmpty(inputStr))
            {
                return
                    inputStr.Replace("<br/>\r\n", "\n").Replace("<br />", "\n").Replace("<br/>", "\n").Replace("<br>",
                                                                                                               "\n").
                        Replace("</br>", "\n").Replace("<ul>", "").Replace("</ul>", "").Replace("<li>", "").Replace(
                            "</li>", "\n").Replace("<p>", "\n").Replace("</p>", "\n").Replace("<ol>", "").Replace(
                                "</ol>", "");
            }
            return inputStr;
        }
        public static string HTMLLineBrak(string inputStr)
        {
            if (!string.IsNullOrEmpty(inputStr))
            {
                return inputStr.Replace("\r\n", "<br />");
            }
            return inputStr;
        }

        public static string RemoveLineBrak(string inputStr)
        {
            if (!string.IsNullOrEmpty(inputStr))
            {
                return inputStr.Replace("\r\n", " ").Replace("<br />", " ");
            }
            return inputStr;
        }


        public static bool GetFunctionNameFromScript(string script, out string functionName)
        {
            int index1 = script.IndexOf("function ");

            if (index1 >= 0)
            {
                index1 += 9;
                int index2 = script.IndexOf("(", index1);
                int length = index2 - index1;
                functionName = script.Substring(index1, length);
                return true;
            }
            functionName = "";
            return false;

        }
    }
}