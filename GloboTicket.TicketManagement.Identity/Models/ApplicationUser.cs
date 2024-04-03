using Microsoft.AspNetCore.Identity;

namespace ERPCubes.Identity.Models
{
    public class ApplicationUser : IdentityUser
    {
        public string FirstName { get; set; } = string.Empty;
        public string LastName { get; set; } = string.Empty;
        public int TenantId { get; set; }
        public int IsActive { get; set; }
        public string Createdby { get; set; }
        public string ModifiedBy { get; set; }
        public DateTime CreatedOn { get; set; }
        public DateTime? ModifiedOn { get; set; }
        public string DeletedBy { get; set; }
        public DateTime? DeletedDate { get; set; }

    }
}
