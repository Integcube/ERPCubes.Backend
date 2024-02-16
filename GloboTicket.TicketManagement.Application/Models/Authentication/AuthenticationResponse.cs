namespace ERPCubes.Application.Models.Authentication
{
    public class AuthenticationResponse
    {
        public string Id { get; set; } = string.Empty;
        public string UserName { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string Token { get; set; } = string.Empty;
        public string Name { get; set; } = string.Empty;
        public int TenantId { get; set; }
        public Guid TenantGuid { get; set; } 

        
    }
}
