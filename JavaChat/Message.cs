using System;
using System.Runtime.Serialization;

namespace JavaChat
{
    [DataContract(Namespace = "your.namespace.com")]
    public enum eStatus
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
        Timeout
    }

    [DataContract(Namespace = "your.namespace.com")]
    public enum eMessageType
    {
        [EnumMember]
        Join,
        [EnumMember]
        Binding,
        [EnumMember]
        Message,
        [EnumMember]
        Leave,
        [EnumMember]
        QueueMessage
    }

    [DataContract(Namespace = "your.namespace.com")]
    public class Message
    {
        [DataMember]
        public int ID { get; set; }

        [DataMember]
        public eMessageType MessageType { get; set; }

        [DataMember]
        public eStatus Status { get; set; }

        private string _text;

        [DataMember]
        public string Text
        {
            get { return _text.Replace("\r\n", "<br />"); }
            set { _text = value; }
        }

        [DataMember]
        public Guid From { get; set; }

        [DataMember]
        public DateTime Received { get; set; }

        

    }
}
