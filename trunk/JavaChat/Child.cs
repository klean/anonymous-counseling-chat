using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;

namespace JavaChat
{
    [DataContract]
    public enum Gender
    {
        [EnumMember]
        Male,
        [EnumMember]
        Female,
        [EnumMember]
        Unknown,
    }

    [DataContract]
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

    [DataContract]
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
        public bool UsedChatBefore { get; set; }

        [DataMember]
        public string Reference { get; set; }

        [DataMember]
        public string Location { get; set; }

        [DataMember]
        public string Description { get; set; }

        public static string StatusText(string name, eChildStatus reason)
        {
            DateTime when = DateTime.Now;
            string text = "";
            switch (reason)
            {
                case eChildStatus.Active:
                    text = string.Format("{0} taster en besked", name);
                    break;
                case eChildStatus.Ready:
                    text = string.Format("{0} har en rådgiver tildelt", name);
                    break;
                case eChildStatus.Waiting:
                    text = string.Format("{0} venter på en rådgiver", name);
                    break;
                case eChildStatus.Offline:
                    text = string.Format("{0} forlod chatten kl. {1}", name, when.ToShortTimeString());
                    break;
                case eChildStatus.Timeout:
                    text = string.Format("{0} forlod chatten kl. {1}, pga. timeout", name, when.ToShortTimeString());
                    break;
                case eChildStatus.Panic:
                    text = string.Format("{0} forlod chatten kl. {1} i panik", name, when.ToShortTimeString());
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
                       ? "Rådgiveren er klar til at tale med dig"
                       : string.Format("{0} er klar til at tale med dig", value.Name);
        }
    }
}
