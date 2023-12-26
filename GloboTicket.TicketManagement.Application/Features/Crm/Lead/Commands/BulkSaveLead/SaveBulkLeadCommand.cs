using ERPCubes.Application.Features.Crm.Lead.Commands.SaveLead;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Commands.BulkSaveLead
{
    public class SaveBulkLeadCommand:IRequest
    {
        public int TenantId { get; set; }
        public string Id { get; set; } = String.Empty;
        public List<SaveBulkLeadDto> Lead { get; set; } = new List<SaveBulkLeadDto>();
    }
}
