using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Industry.Queries.GetIndustryList
{
    public class GetIndustryListVm
    {
        public int IndustryId { get; set; }
        public string IndustryTitle { get; set; } = string.Empty;
    }
}
