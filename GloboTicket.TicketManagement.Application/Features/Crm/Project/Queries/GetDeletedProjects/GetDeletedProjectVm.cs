using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Project.Queries.GetDeletedProjects
{
    public class GetDeletedProjectVm
    {
        public int Id { get; set; }
        public string Title { get; set; } = string.Empty;
        public string DeletedBy { get; set; }
        public DateTime? DeletedDate { get; set; }
    }
}
