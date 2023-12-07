using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Tags.Commands.SaveTags
{
    public class SaveTagVm
    {
        public int TagId { get; set; }
        public string TagTitle { get; set; } = string.Empty;
        public Boolean IsSelected { get; set; }
    }
}
