using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.DocumentLibrary.Command.AddLeadFile
{
    public class AddLeadFileCommand: IRequest
    {
        public string Id { get; set; }
        public int TenantId { get; set; }
        public AddLeadFileVm File { get; set; }
        public int ParentId { get; set; }
        public int ContactTypeId { get; set; }
        public int LeadId { get; set; }
    }
}
