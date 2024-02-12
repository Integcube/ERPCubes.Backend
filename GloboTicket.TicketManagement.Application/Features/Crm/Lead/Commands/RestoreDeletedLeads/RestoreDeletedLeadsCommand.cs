using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Commands.RestoreDeletedLeads
{
    public class RestoreDeletedLeadsCommand:IRequest
    {
        public int LeadId { get; set; }

    }
}
