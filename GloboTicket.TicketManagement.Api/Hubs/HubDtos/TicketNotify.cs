namespace ERPCubesApi.Hubs.HubDtos
{
    public class TicketNotify
    {
        public int NotificationId { get; set; }
        public string Icon { get; set; }
        public string Image { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public string Link { get; set; }
        public string UseRouter { get; set; }
        public int Read { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
    }
}
