using ERPCubes.Domain.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetCheckPoint
{
    public class GetCheckPointLeadVm
    {
        public int CLId { get; set; }
        public string Title { get; set; }
        public int DueDays { get; set; }
        public string IsRequired { get; set; }
        public int CPId { get; set; }
        public DateTime DueDate { get; set; }
        public int Status { get; set; }
        public int? Priority { get; set; }
        


    }
}
