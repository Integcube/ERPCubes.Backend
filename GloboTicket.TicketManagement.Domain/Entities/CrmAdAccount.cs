using ERPCubes.Domain.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Domain.Entities
{
    public class CrmAdAccount: AuditableEntity
    {
        [Key]
        public string Id { get; set; } = string.Empty;
        public string AccountId { get; set; } = string.Empty;
        public string Title { get; set; } = string.Empty;
        public int IsSelected { get; set; }  
        public string SocialId { get; set; } = string.Empty;
    }
}
