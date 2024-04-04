using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Commands.SetStatus
{
    public class SetCheckPointStatusCommand : IRequest
    {
        public int CpId { get; set; }
        public int TenantId { get; set; }
        public string Id { get; set; }
        public int StatusId { get; set; }
        public int ContactId { get; set; }
        public int ContactTypeId { get; set; }
        public string CompletedBy { get; set; }
        public DateTime CompletedOn { get; set; }
      
    }
}
