using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Identity.Models
{
    public class SocialUsers
    {
        public string Id { get; set; } = string.Empty;
        public string FirstName { get; set; } = string.Empty;
        public string LastName { get; set; } = string.Empty;
        public string Name { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string PhotoUrl { get; set; } = string.Empty;
        public string Provider { get; set; } = string.Empty;
        public DateTime CreatedDate { get; set; } 
        public string CreatedBy { get; set; } = string.Empty;
        public int TenantId { get; set; }
    }
}
