using ERPCubes.Domain.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Domain.Entities
{
    public class CrmChatbotSetting : AuditableEntity
    {
        [Key]
        public int Id { get; set; }
        public string Title { get; set; }
        public string PrimaryColor { get; set; }
        public int TenantId { get; set; }

    }
    
}
