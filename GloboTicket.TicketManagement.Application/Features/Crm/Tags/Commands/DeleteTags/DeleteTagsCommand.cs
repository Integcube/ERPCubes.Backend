using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Tags.Commands.DeleteTags
{
    public class DeleteTagsCommand: IRequest
    {
        public int TagId { get; set; }
        public string Id { get; set; } = string.Empty;
        public int TenantId { get; set; }
    }
}
