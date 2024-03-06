using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadCountByMonth
{
    public class GetLeadCountByMonthVm
    {
        public string MonthName { get; set; }
        public int TotalLeadsCount { get; set; }
    }
}
