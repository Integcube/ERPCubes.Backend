namespace ERPCubesApi.Models
{
    public class WhatsappWebhook
    {
        public class WhatsAppWebhook
        {
            public string Object { get; set; }
            public List<WhatsAppEntry> Entry { get; set; }
        }

        public class WhatsAppEntry
        {
            public string Id { get; set; }
            public List<WhatsAppChange> Changes { get; set; }
        }

        public class WhatsAppChange
        {
            public string Field { get; set; }
            public WhatsAppValue Value { get; set; }
        }

        public class WhatsAppValue
        {
            public string MessagingProduct { get; set; }
            public WhatsAppMetadata Metadata { get; set; }
            public List<WhatsAppContact> Contacts { get; set; }
            public List<WhatsAppMessage> Messages { get; set; }
        }

        public class WhatsAppMetadata
        {
            public string DisplayPhoneNumber { get; set; }
            public string PhoneNumberId { get; set; }
        }

        public class WhatsAppContact
        {
            public WhatsAppProfile Profile { get; set; }
            public string WaId { get; set; }
        }

        public class WhatsAppProfile
        {
            public string Name { get; set; }
        }

        public class WhatsAppMessage
        {
            public string From { get; set; }
            public string Id { get; set; }
            public string Timestamp { get; set; }
            public string Type { get; set; }
            public WhatsAppMessageText Text { get; set; }
        }

        public class WhatsAppMessageText
        {
            public string Body { get; set; }
        }
    }
}
