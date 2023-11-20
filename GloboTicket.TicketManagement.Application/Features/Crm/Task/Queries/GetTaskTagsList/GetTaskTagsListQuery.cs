using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Task.Queries.GetTaskTagsList
{
    public class GetTaskTagsListQuery:IRequest<List<GetTaskTagsListVm>>
    {
        public int TaskId { get; set; }
        public int  TenantId{ get; set; }
        public string Id { get; set; }=String.Empty;
    }
}
