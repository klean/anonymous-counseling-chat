using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using System.Timers;

namespace JavaChat
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the class name "ServiceChat" in both code and config file together.
    public class ServiceChat : IServiceChat
    {
        private static readonly Dictionary<Guid, Advisor> advisors = new Dictionary<Guid, Advisor>();
        private static readonly Dictionary<Guid, Child> children = new Dictionary<Guid, Child>();
        private static bool m_isQueueOpen = false;
        private readonly Timer m_timoutChecker = new Timer(5000);
        private readonly Dictionary<string, string> m_emoticonMapping;
        public ServiceChat()
        {
            m_timoutChecker.Elapsed += new ElapsedEventHandler(m_timer_Elapsed);
            m_timoutChecker.Start();
            //m_closeConsultingTimeout.Elapsed += new ElapsedEventHandler(m_closeQueueTimeout_Elapsed);
            m_emoticonMapping = new Dictionary<string, string>();
            InitializeSmileys();
        }

        private void InitializeSmileys()
        {
            m_emoticonMapping.Add(":)", "smile.gif");
            m_emoticonMapping.Add(":-)", "smile.gif");
            m_emoticonMapping.Add(";)", "happywink.gif");
            m_emoticonMapping.Add(";-)", "happywink.gif");
            m_emoticonMapping.Add(":(", "sad.gif");
            m_emoticonMapping.Add(":-(", "sad.gif");
            m_emoticonMapping.Add(":D", "biggrin.gif");
            m_emoticonMapping.Add(":-D", "biggrin.gif");
        }

        /// <summary>
        /// Removes any client or advisor which hasn't updated the status in 90 seconds
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        void m_timer_Elapsed(object sender, ElapsedEventArgs e)
        {
            var childrenToRemove = children.Where(c => c.Value.LastUpdate.AddSeconds(90) < DateTime.Now).Select(child => child.Value).ToList();

            foreach (var item in childrenToRemove)
            {
                ChildLeave(item.ChildID, eChildStatus.Panic);
            }

            var advisorsToRemove = advisors.Where(a => a.Value.LastUpdate.AddSeconds(90) < DateTime.Now).Select(advisor => advisor.Value).ToList();

            foreach (var item in advisorsToRemove)
            {
                AdvisorLeave(item.AdvisorID, eAdvisorStatus.Timeout);
            }
        }

        public Guid ChildJoin(int age, bool male, bool usedChatBefore, string reference, string location)
        {
            Guid g = Guid.Empty;
            if (m_isQueueOpen)
            {
                g = Guid.NewGuid();
                children.Add(g, new Child()
                                    {
                                        ChildID = g,
                                        Age = age,
                                        Status = eChildStatus.Waiting,
                                        Gender = male ? Gender.Male : Gender.Female,
                                        Name = g.ToString(),
                                        UsedChatBefore = usedChatBefore,
                                        Reference = reference,
                                        Location = location,
                                        Description = "",
                                        Enter = DateTime.Now,
                                        LastUpdate = DateTime.Now,
                                        Messages = new List<Message>()
                                                   {
                                                       new Message()
                                                           {
                                                               ID = 0,
                                                               MessageType = eMessageType.Join,
                                                               Status = eStatus.Waiting,
                                                               From = Guid.Empty,
                                                               Received = DateTime.Now,
                                                               Text = "Velkommen til chatten"
                                                           }
                               },

                                    });

            }
            return g;
        }

        public Guid AdvisorJoin()
        {
            Guid g = Guid.NewGuid();
            advisors.Add(g, new Advisor()
                                {
                                    AdvisorID = g,

                                    Name = g.ToString(),
                                    Description = "",
                                    Status = eAdvisorStatus.Hold,
                                    Enter = DateTime.Now,
                                    LastUpdate = DateTime.Now,
                                    Messages = new List<Message>()
                                                   {
                                                       new Message()
                                                           {
                                                               ID = 0,
                                                               MessageType = eMessageType.Join,
                                                               Status = eStatus.Waiting,
                                                               From = Guid.Empty,
                                                               Received = DateTime.Now,
                                                               Text = "Velkommen til chatten, klik på klar når du vil tale med en klient"
                                                           }
                                                   },
                                });

            return g;
        }

        public void ChildSay(Guid childID, string text)
        {
            ChildSay(childID, text, eMessageType.Message);
        }

        private void ChildSay(Guid childID, string text, eMessageType messageType)
        {
            if (children.ContainsKey(childID) && children[childID].Advisor.HasValue)
            {
                children[childID].Messages.Add(
                    new Message()
                    {
                        ID = children[childID].Messages.Count,
                        From = childID,
                        MessageType = messageType,
                        Received = DateTime.Now,
                        Text = InsertEmoticon(text)
                    });
                var advisorID = children[childID].Advisor.Value;
                if (advisors.ContainsKey(advisorID))
                {
                    advisors[advisorID].Messages.Add(
                        new Message()
                        {
                            ID = advisors[advisorID].Messages.Count,
                            From = childID,
                            MessageType = messageType,
                            Received = DateTime.Now,
                            Text = InsertEmoticon(text)
                        });
                }
            }
        }

        public void AdvisorSay(Guid advisorID, string text)
        {
            AdvisorSay(advisorID, text, eMessageType.Message);
        }

        private void AdvisorSay(Guid advisorID, string text, eMessageType messageType)
        {
            if (advisors.ContainsKey(advisorID) && advisors[advisorID].Child.HasValue)
            {
                advisors[advisorID].Messages.Add(
                    new Message()
                    {
                        ID = advisors[advisorID].Messages.Count,
                        From = advisorID,
                        MessageType = messageType,
                        Received = DateTime.Now,
                        Text = InsertEmoticon(text)
                    });

                var childId = advisors[advisorID].Child.Value;
                if (children.ContainsKey(childId))
                {
                    children[childId].Messages.Add(
                        new Message()
                        {
                            ID = children[childId].Messages.Count,
                            From = advisorID,
                            MessageType = messageType,
                            Received = DateTime.Now,
                            Text = InsertEmoticon(text)
                        });
                }
            }
        }

        private String InsertEmoticon(string text)
        {
            return m_emoticonMapping.Aggregate(text, (current, item) => current.Replace(item.Key, "<img src=\"images/smileys/" + item.Value + "\" border=\"0\" />"));
        }

        public void ChildLeave(Guid childID, eChildStatus status)
        {
            if (children.ContainsKey(childID))
            {
                var child = children[childID];
                var advisorID = child.Advisor;
                var text = Child.StatusText(child.Name == childID.ToString() ? "Barnet" : child.Name, status);
                if (advisorID.HasValue && advisors.ContainsKey(advisorID.Value))
                {
                    ChildSay(childID, text, eMessageType.Leave);
                    var advisor = advisors[advisorID.Value];
                    advisor.Child = null;
                    advisor.Status = eAdvisorStatus.Hold;
                }

                children.Remove(childID);
            }
        }

        public void AdvisorLeave(Guid advisorID, eAdvisorStatus status)
        {
            if (advisors.ContainsKey(advisorID))
            {
                var advisor = advisors[advisorID];
                var childId = advisor.Child;
                var text = Advisor.StatusText(advisor.Name == advisorID.ToString() ? "Rådgiveren" : advisor.Name, status);
                if (childId.HasValue && children.ContainsKey(childId.Value))
                {
                    AdvisorSay(advisorID, text, eMessageType.Leave);
                    children[childId.Value].Advisor = null;
                }

                advisors.Remove(advisorID);
            }

            if (advisors.Count == 0)
                m_isQueueOpen = false;
        }

        public Child AdvisorReady(Guid advisorID)
        {
            if (advisors.ContainsKey(advisorID))
            {
                m_isQueueOpen = true;
                lock (advisors)
                {
                    var advisor = advisors[advisorID];
                    advisor.Messages.Clear();
                    advisor.LastUpdate = DateTime.Now;
                    if (advisor.Child != null && advisor.Child.Value != Guid.Empty)
                        return children[advisor.Child.Value];
                    for (int i = 0; i < children.Count; i++)
                    {
                        var child = children.ElementAt(i);
                        if (!child.Value.Advisor.HasValue)
                        {

                            advisor.Child = child.Key;
                            child.Value.Advisor = advisorID;
                            DateTime received = DateTime.Now;
                            advisor.Messages.Add(new Message()
                                                     {
                                                         ID = advisor.Messages.Count,
                                                         From = Guid.Empty,
                                                         Received = received,
                                                         MessageType = eMessageType.Binding,
                                                         Status = eStatus.Ready,
                                                         Text = Advisor.Binding(child.Value)
                                                     });
                            child.Value.Messages.Add(new Message()
                                                         {
                                                             ID = child.Value.Messages.Count,
                                                             From = Guid.Empty,
                                                             Received = received,
                                                             MessageType = eMessageType.Binding,
                                                             Status = eStatus.Ready,
                                                             Text = Child.Binding(advisor)
                                                         });
                            return child.Value;
                        }
                    }
                }
            }
            return null;
        }

        public Message[] ChildStatus(Guid childID, int lastmessageID)
        {
            var lst = new Message[0];

            if (children.ContainsKey(childID) && children[childID].Messages.Count > 0)
            {
                var child = children[childID];
                child.LastUpdate = DateTime.Now;
                lst = new Message[child.Messages.Count];
                for (int i = lastmessageID; i < child.Messages.Count; i++)
                {
                    lst[i] = child.Messages[i];
                }
            }

            return lst;
        }

        public Message[] AdvisorStatus(Guid advisorID, int lastMessageID)
        {
            if (advisors.ContainsKey(advisorID) && advisors[advisorID].Messages.Count > 0)
            {
                var advisor = advisors[advisorID];
                advisor.LastUpdate = DateTime.Now;
                var lst = new Message[advisor.Messages.Count];
                for (int i = lastMessageID; i < advisor.Messages.Count; i++)
                {
                    lst[i] = advisor.Messages[i];
                }
                return lst.ToArray();
            }
            return new Message[0];
        }

        public int QueueCount(Guid childID)
        {
            int count = 0;
            if (children.ContainsKey(childID))
            {
                count = 1;
                var me = children[childID];
                me.LastUpdate = DateTime.Now;
                if (me.Advisor != null)
                    return 0;
            }
            for (int i = 0; i < children.Count; i++)
            {

                var child = children.ElementAt(i);
                if (!child.Value.Advisor.HasValue)
                {
                    if (child.Key == childID)
                    {

                        return count;
                    }
                    count++;
                }
            }
            return count;
        }

        public bool GetChildActive(Guid advisorID)
        {
            bool retVal = false;

            if (advisors.ContainsKey(advisorID) && advisors[advisorID].Child.HasValue)
            {
                retVal = children[advisors[advisorID].Child.Value].Status.Equals(eChildStatus.Active);
            }

            return retVal;
        }

        public bool GetAdvisorActive(Guid childID)
        {
            bool retVal = false;

            if (children.ContainsKey(childID) && children[childID].Advisor.HasValue)
            {
                if (advisors.ContainsKey(children[childID].Advisor.Value))
                {
                    var advisor = advisors[children[childID].Advisor.Value];

                    retVal = advisor.Status.Equals(eAdvisorStatus.Active);
                }
            }

            return retVal;
        }


        public void SetChildActive(Guid childID, bool isActive)
        {
            if (children.ContainsKey(childID))
            {
                children[childID].Status = isActive ? eChildStatus.Active : eChildStatus.Ready;
            }
        }

        public void SetAdvisorActive(Guid advisorID, bool isActive)
        {
            if (advisors.ContainsKey(advisorID))
            {
                advisors[advisorID].Status = isActive ? eAdvisorStatus.Active : eAdvisorStatus.Ready;
            }
        }

        public void EndChat(Guid advisorID)
        {
            if (advisors.ContainsKey(advisorID))
            {
                var advisor = advisors[advisorID];
                if (advisor.Child.HasValue)
                {
                    Guid childGuid = advisor.Child.Value;
                    if (children.ContainsKey(childGuid))
                    {
                        var child = children[childGuid];
                        child.Messages.Add(new Message()
                        {
                            ID = child.Messages.Count,
                            From = Guid.Empty,
                            Received = DateTime.Now,
                            MessageType = eMessageType.Leave,
                            Status = eStatus.Waiting,
                            Text = (advisor.Name == advisorID.ToString() ? "Rådgiveren" : advisor.Name) + " afsluttede chatten."
                        });
                        child.Advisor = null;
                        child.Status = eChildStatus.Offline;

                        advisor.Child = null;
                        advisor.Status = eAdvisorStatus.Hold;
                        advisor.Messages.Clear();
                    }
                }
            }
        }

        public void CloseQueue()
        {
            m_isQueueOpen = false;

            var childrenInQueue = children.Where(c => c.Value.Advisor.HasValue.Equals(false)).Select(child => child.Value);

            foreach (var child in childrenInQueue)
            {
                child.Messages.Add(
                    new Message()
                    {
                        ID = child.Messages.Count,
                        From = Guid.Empty,
                        MessageType = eMessageType.QueueMessage,
                        Received = DateTime.Now,
                        Text = "Der er i øjeblikket så mange i kø, at vi desværre forventer, at du ikke kan nå at komme igennem i dag. Du er velkommen til at blive i køen, men du er også meget velkommen til at chatte med os, næste gang rådgivningen er åben."
                    }
                );
            }

        }


        public void OpenQueue()
        {
            m_isQueueOpen = true;
        }
    }
}
