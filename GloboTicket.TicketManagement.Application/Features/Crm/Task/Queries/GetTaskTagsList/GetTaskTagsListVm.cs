using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Task.Queries.GetTaskTagsList
{
    public class GetTaskTagsListVm
    {
        public int TagId { get; set; }
        public string TagTitle { get; set; } = String.Empty;
        public Boolean IsSelected { get; set; }
    }
}
