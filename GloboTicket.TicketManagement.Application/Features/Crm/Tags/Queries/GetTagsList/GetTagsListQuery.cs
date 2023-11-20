using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Tags.Queries.GetTagsList
{
    public class GetTagsListQuery: IRequest<List<GetTagsVm>>
    {
        public int TenantId { get; set; }
        public string Id { get; set; }=string.Empty;
    }
}
