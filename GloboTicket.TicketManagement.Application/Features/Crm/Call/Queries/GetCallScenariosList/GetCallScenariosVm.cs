using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Call.Queries.GetCallScenariosList
{
    [Table("CrmICallScenarios")]
    public class GetCallScenariosVm
    {
        [Key]
        public int ReasonId { get; set; }
        public string Title { get; set; }
        public int IsTask { get; set; }
        public int IsShowResponse { get; set; }
        public int IsDeleted { get; set; }
    }
}
