using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.CustomLists.Queries.GetCustomLists
{
    public class GetCustomListQuery:IRequest<List<GetCustomListVm>>
    {
        public int TenantId { get; set; }
        public string Id { get; set; } = String.Empty;
        public string Type { get; set; } = String.Empty;
    }
}
