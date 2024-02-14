namespace ERPCubesApi.Model
{
    public class SaveFileDto
    {
        public IFormFile File { get; set; }
        public string TenantId { get; set; }
        public string Id { get; set; }
        public string ParentId { get; set; }
    }
}
