using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;

namespace JavaChat
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the interface name "IServiceChat" in both code and config file together.
    [ServiceContract(Namespace = "http://JavaChat")]
    public interface IServiceChat
    {
        [OperationContract]
        Guid ChildJoin(int age, bool male, bool usedChatBefore, string reference, string location);

        [OperationContract]
        Guid AdvisorJoin();
        
        [OperationContract]
        void ChildSay(Guid childID, string text);

        [OperationContract]
        void AdvisorSay(Guid advisorID, string text);

        [OperationContract]
        void ChildLeave(Guid childID, eChildStatus status);

        [OperationContract]
        void AdvisorLeave(Guid advisorID, eAdvisorStatus status);

        [OperationContract]
        Child AdvisorReady(Guid advisorID);

        [OperationContract]
        Message[] ChildStatus(Guid childID, int messageID);

        [OperationContract]
        Message[] AdvisorStatus(Guid advisorID, int messageID);

        [OperationContract]
        void SetChildActive(Guid childID, bool isActive);

        [OperationContract]
        bool GetChildActive(Guid advisorID);

        [OperationContract]
        void SetAdvisorActive(Guid advisorID, bool isActive);

        [OperationContract]
        bool GetAdvisorActive(Guid childID);

        [OperationContract]
        int QueueCount(Guid childID);

        [OperationContract]
        void EndChat(Guid advisorID);

        [OperationContract]
        void CloseQueue();

        [OperationContract]
        void OpenQueue();
    }
}
