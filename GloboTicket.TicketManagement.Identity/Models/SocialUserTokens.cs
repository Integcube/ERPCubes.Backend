using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Identity.Models
{
    public class SocialUserTokens
    {
        [Key]
        public string SocialUserId { get; set; } = string.Empty;
        public string AuthToken { get; set; } = string.Empty;
        public string IdToken { get; set; } = string.Empty;
        public string AuthorizationCode { get; set; } = string.Empty;
        public string Provider { get; set; } = string.Empty;
        public DateTime CreatedDate { get; set; }
        public string CreatedBy { get; set; } = string.Empty;
        public string ModifiedBy { get; set; } = string.Empty;
        public DateTime ModifiedDate { get; set; }
        public int TenantId { get; set; }
    }
}
