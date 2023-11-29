using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.CustomLists.Commands.SaveCustomListFilters
{
    public class SaveCustomListFilterCommand:IRequest
    {
        public string Id { get; set; } = String.Empty;
        public int TenantId { get; set; }
        public int ListId { get; set; }
        public string ListTitle { get; set; } = String.Empty;
        public string Filter { get; set; } = String.Empty;
    }
}
