using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Checklist.Queries.CheckListReport
{
    public class CheckListReportQuery : IRequest<List<CheckListReportVm>>
    {
        public string Id { get; set; } = String.Empty;
        public int TenantId { get; set; }
    }
}
