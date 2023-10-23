using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.AppMenu.Queries.GetMenuList
{
    public class AppMenuDto
    {
        public List<AppMenuVm>? defaultList { get; set; }
        public List<AppMenuVm>? allMenu { get; set; }
    }
}
