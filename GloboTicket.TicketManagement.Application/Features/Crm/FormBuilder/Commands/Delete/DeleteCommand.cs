using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Call.Commands.Delete
{
    public class DeleteCommand : IRequest
    {
        public int FormId { get; set; }
        public string Id { get; set; }
        public int TenantId { get; set; }
        
    }
}
