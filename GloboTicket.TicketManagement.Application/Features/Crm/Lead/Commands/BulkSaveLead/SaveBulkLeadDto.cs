using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Commands.BulkSaveLead
{
    public class SaveBulkLeadDto
    {
        public int LeadId { get; set; }
        public string? FirstName { get; set; }
        public string? LastName { get; set; }
        public string? Email { get; set; }
        public string? City { get; set; }
        public int ProductId { get; set; }
        public string? Mobile { get; set; }
        public string? Address { get; set; }
        public string? Street { get; set; }
        public string? Zip { get; set; }
        public string? State { get; set; }
        public string? Country { get; set; }
        public int SourceId { get; set; }
        public int IndustryId { get; set; }
    }
}
