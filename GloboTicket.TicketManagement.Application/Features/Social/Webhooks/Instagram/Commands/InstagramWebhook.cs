namespace ERPCubesApi.Models
{

    public class InstagramWebhook
    {

        public string Object { get; set; }
        public List<InstagramEntry> Entry { get; set; }

    }
    public class InstagramEntry
    {
        public long Time { get; set; }
        public string Id { get; set; }
        public List<InstagramMessaging> Messaging { get; set; }
    }

    public class InstagramMessaging
    {
        public InstagramSender Sender { get; set; }
        public InstagramRecipient Recipient { get; set; }
        public string Timestamp { get; set; }
        public InstagramMessage Message { get; set; }
    }

    public class InstagramSender
    {
        public string Id { get; set; }
    }

    public class InstagramRecipient
    {
        public string Id { get; set; }
    }

    public class InstagramMessage
    {
        public string Mid { get; set; }
        public string Text { get; set; }
    }
}
