using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Commands.BulkRestoreLeads
{
    public class RestoreBulkLeadCommand : IRequest
    {
        public List<int> LeadId { get; set; }

    }
}
