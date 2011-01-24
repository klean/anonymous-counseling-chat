using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;

namespace JavaChat
{
    [DataContract]
    public enum eAdvisorStatus
    {
        [EnumMember]
        Active,
        [EnumMember]
        Ready,
        [EnumMember]
        Hold,
        [EnumMember]
        Offline,
        [EnumMember]
        Timeout
    }

    [DataContract]
    public class Advisor
    {
        [DataMember]
        public Guid AdvisorID { get; set; }

        [DataMember]
        public eAdvisorStatus Status { get; set; }

        [DataMember]
        public string Name { get; set; }

        [DataMember]
        public string Description { get; set; }

        [DataMember]
        public DateTime Enter { get; set; }

        [DataMember]
        public DateTime LastUpdate { get; set; }

        [DataMember]
        public DateTime? Leave { get; set; }

        [DataMember]
        public Guid? Child { get; set; }

        [DataMember]
        public List<Message> Messages { get; set; }

        public static string StatusText(string name, eAdvisorStatus reason)
        {
            DateTime when = DateTime.Now;
            string text = "";
            switch(reason)
            {
                case eAdvisorStatus.Active:
                    text = string.Format("{0} taster en besked", name);
                    break;
                case eAdvisorStatus.Ready:
                    text = string.Format("{0} har et barn tildelt", name);
                    break;
                case eAdvisorStatus.Hold:
                    text = string.Format("{0} er på hold", name);
                    break;
                case eAdvisorStatus.Offline:
                    text = string.Format("{0} forlod chatten kl. {1}", name, when.ToShortTimeString());
                    break;
                case eAdvisorStatus.Timeout:
                    text = string.Format("{0} forlod chatten kl. {1}, pga. timeout", name, when.ToShortTimeString());
                    break;
            }
            return text;
        }

        public static string Binding(Child value)
        {
            return value.Age > 0 ? 
                string.Format("ID {0} - {1}, {2} år", value.Name, value.Gender == Gender.Male ? "Dreng" : "Pige", value.Age) : 
                string.Format("ID {0}", value.Name, value.Gender == Gender.Male ? "Dreng" : "Pige");
        }
    }
}
