using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.CustomLists.Queries.GetCustomLists
{
    public class GetCustomListVm
    {
        public int ListId { get; set; }
        public string ListTitle { get; set; } = String.Empty;
        public string Filter { get; set; } = String.Empty;
    }
}
