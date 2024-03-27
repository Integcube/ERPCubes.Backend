using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.CheckList.CreateCheckList.Queries.GetCheckpoints
{
    public class GetCheckpointQuery : IRequest<List<GetCheckpointsVm>>
    {
        public string Id { get; set; } = String.Empty;
        public int TenantId { get; set; }
        public int CLId { get; set; }
    }
}
