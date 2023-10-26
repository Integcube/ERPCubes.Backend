using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Company.GetCompanyList.Queries
{
    public class GetCompanyListQuery:IRequest<List<GetCompanyVm>>
    {
        public string Id { get; set; }
        public int TenantId { get; set; }
    }
}
