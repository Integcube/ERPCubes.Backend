using ERPCubes.Application.Features.Product.Queries.GetProductList;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Meeting.Queries.GetMeetingList
{
    public class GetMeetingListQuery : IRequest<List<GetMeetingVm>>
    {
        public string Id { get; set; } = String.Empty;
        public int TenantId { get; set; }
        public int ContactId { get; set; }
        public int ContactTypeId { get; set; }
    }
}
