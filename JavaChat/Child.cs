using System;
using System.Collections.Generic;
using System.Runtime.Serialization;

namespace JavaChat
{
    [DataContract(Namespace = "your.namespace.com")]
    public enum Gender
    {
        [EnumMember]
        Male = 1,
        [EnumMember]
        Female = 2,
        [EnumMember]
        Unknown = 0,
    }

    [DataContract(Namespace = "your.namespace.com")]
    public enum eChildStatus
    {
        [EnumMember]
        Active,
        [EnumMember]
        Ready,
        [EnumMember]
        Waiting,
        [EnumMember]
        Offline,
        [EnumMember]
        Timeout,
        [EnumMember]
        Panic
    }

    [DataContract(Namespace = "your.namespace.com")]
    public class Child
    {
        [DataMember]
        public Guid ChildID { get; set; }

        public eChildStatus Status { get; set; }

        [DataMember]
        public DateTime Enter { get; set; }

        [DataMember]
        public DateTime LastUpdate { get; set; }

        [DataMember]
        public DateTime? Leave { get; set; }

        [DataMember]
        public List<Message> Messages { get; set; }

        [DataMember]
        public Guid? Advisor { get; set; }

        [DataMember]
        public string Name { get; set; }

        [DataMember]
        public int Age { get; set; }

        [DataMember]
        public Gender Gender { get; set; }

        [DataMember]
        public string UsedChatBefore { get; set; }

        [DataMember]
        public string Reference { get; set; }

        [DataMember]
        public string Location { get; set; }

        [DataMember]
        public string Municipality { get; set; }

        [DataMember]
        public string Description { get; set; }

        public static string StatusText(string name, eChildStatus reason)
        {
            DateTime when = DateTime.Now;
            string text = "";
            switch (reason)
            {
                case eChildStatus.Active:
                    text = string.Format("{0} is typing a message", name);
                    break;
                case eChildStatus.Ready:
                    text = string.Format("{0} has an advisor assigned", name);
                    break;
                case eChildStatus.Waiting:
                    text = string.Format("{0} is waiting for an advisor", name);
                    break;
                case eChildStatus.Offline:
                    text = string.Format("{0} left the chat at {1}", name, when.ToShortTimeString());
                    break;
                case eChildStatus.Timeout:
                    text = string.Format("{0} left the chat at {1}, due to timeout", name, when.ToShortTimeString());
                    break;
                case eChildStatus.Panic:
                    text = string.Format("{0} left the chat at {1} due to panic...", name, when.ToShortTimeString());
                    break;
                default:
                    text = "";
                    break;
            }
            return text;
        }

        public static string Binding(Advisor value)
        {
            return value.AdvisorID.ToString() == value.Name
                       ? "Advisor ready to chat"
                       : string.Format("{0} is ready to chat with you", value.Name);
        }
    }
}
