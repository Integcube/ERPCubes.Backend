using Microsoft.AspNetCore.Identity;

namespace ERPCubes.Identity.Models
{
    public class ApplicationUser : IdentityUser
    {
        public string FirstName { get; set; } = string.Empty;
        public string LastName { get; set; } = string.Empty;
        public int TenantId { get; set; }
    }
}
