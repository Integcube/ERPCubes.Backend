namespace ERPCubesApi.Model
{
    public class AddLeadFileDto
    {
        public IFormFile File { get; set; }
        public string TenantId { get; set; }
        public string Id { get; set; }
        public string LeadId { get; set; }
        public string ContactTypeId { get; set; }
        public string ParentId { get; set; }
    }
}
