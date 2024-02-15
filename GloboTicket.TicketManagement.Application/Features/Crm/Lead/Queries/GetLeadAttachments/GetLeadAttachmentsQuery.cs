using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadAttachments
{
    public class GetLeadAttachmentsQuery: IRequest<List<GetLeadAttachmentsVm>>
    {
        public int TenantId { get; set; }
        public string Id { get; set; } = string.Empty;
        public int LeadId { get; set; }
        public int ContactTypeId { get; set; }
    }
}
