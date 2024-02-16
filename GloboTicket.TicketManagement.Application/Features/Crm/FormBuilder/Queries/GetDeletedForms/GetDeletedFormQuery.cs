using ERPCubes.Application.Features.Crm.Campaign.Queries.GetDeletedCampaigns;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.FormBuilder.Queries.GetDeletedForms
{
    public class GetDeletedFormQuery : IRequest<List<GetDeletedFormVm>>
    {
        public string Id { get; set; } = String.Empty;
        public int TenantId { get; set; }
    }
}
