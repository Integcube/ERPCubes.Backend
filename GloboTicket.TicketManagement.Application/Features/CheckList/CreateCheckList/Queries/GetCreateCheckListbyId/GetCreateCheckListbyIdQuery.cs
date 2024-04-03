using ERPCubes.Application.Features.AppUser.Queries.GetUserList;
using ERPCubes.Domain.Common;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.CheckList.CreateCheckList.Queries.GetCreateCheckListbyId
{
    public class GetCreateCheckListbyIdQuery : IRequest<GetCreateCheckListbyIdVm>
    {
        public int TenantId { get; set; }
        public string Id { get; set; }
        public int CLId { get; set; }

    }
}
