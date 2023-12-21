using ERPCubes.Domain.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Domain.Entities
{
    public class CrmCalenderEvents : AuditableEntity
    {
        [Key]
        public int EventId { get; set;}
        public string UserId {  get; set;}=String.Empty;
        public string Description {  get; set;}=String.Empty;   
        public int Type {  get; set;}
        public DateTime? StartTime {  get; set;}
        public DateTime? EndTime { get; set;}
        public int TenantId { get; set;}
        public int Id { get; set; } 
        public int IsCompany { get; set; }
        public int IsLead { get; set; }
        public int IsOpportunity {  get; set; }
        public bool AllDay { get; set; }
    }
}
