using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Commands.ChangeLeadStatus
{
    public class ChangeLeadStatusCommand : IRequest
    {
        public int TenantId { get; set; }
        public string userId { get; set; }
        public int LeadId { get; set; }
        public int statusId { get; set; }
        public string StausTitle { get; set; } 

    }
}
