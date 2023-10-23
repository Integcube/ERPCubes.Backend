using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.AppMenu.Queries.GetMenuList
{
    public class AppMenuVm
    {
        public int MenuId { get; set; }
        public string? Id { get; set; } = string.Empty;
        public string? Title { get; set; } = string.Empty;
        public string? Subtitle { get; set; } = string.Empty;
        public string? Type { get; set; } = string.Empty;
        public string? Icon { get; set; } = string.Empty;
        public string? Link { get; set; } = string.Empty;
        public List<AppMenuVm>? Children { get; set; }
        public int? ParentId { get; set; }
    }
}
