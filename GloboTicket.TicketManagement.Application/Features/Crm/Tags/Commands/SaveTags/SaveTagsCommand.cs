using ERPCubes.Application.Features.Crm.Tags.Commands.SaveTags;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Tags.Commands.SaveTags
{
    public class SaveTagsCommand : IRequest<SaveTagVm>
    {
        public int TagId { get; set; }
        public string TagTitle { get; set; } = string.Empty;
        public string Id { get; set; } = string.Empty;
        public int TenantId { get; set; }
    }
}
