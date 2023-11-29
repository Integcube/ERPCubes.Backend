using ERPCubes.Application.Features.Product.Queries.GetProductList;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Calender.Queries.GetCalenderList
{
    public class GetCalenderListQuery : IRequest<List<GetCalenderListVm>>
    {
        public string Id { get; set; } = String.Empty;
        public int TenantId { get; set; }
        public int LeadId { get; set; }
        public int CompanyId { get; set; }
    }
}
