using ERPCubes.Application.Features.AppUser.Queries.GetUserList;
using ERPCubes.Domain.Common;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetCheckPoint
{
    public class GetCheckPointLeadQuery : IRequest<List<GetCheckPointLeadVm>>
    {
        public int TenantId { get; set; }
        public string Id { get; set; }
        public int ContactId { get; set; }
        
    }
}
