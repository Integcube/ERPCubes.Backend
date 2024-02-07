using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Commands.SaveLead
{
    public class SaveLeadCommand:IRequest
    {
        public int TenantId { get; set; }
        public string Id { get; set; } 
        public SaveLeadDto Lead {  get; set; } = new SaveLeadDto();
    }
}
