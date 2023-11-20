using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Tags.Queries.GetTagsList
{
    public class GetTagsVm
    {
        public int TagId { get; set; }
        public string TagTitle { get; set; } = string.Empty;
    }
}
