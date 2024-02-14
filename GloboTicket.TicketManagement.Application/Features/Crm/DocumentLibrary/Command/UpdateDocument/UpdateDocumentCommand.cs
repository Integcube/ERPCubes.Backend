using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.DocumentLibrary.Command.UpdateDocumentCommand
{
    public class UpdateDocumentCommand : IRequest
    {
        public int FileId { get; set; }
        public string Description { get; set; } = string.Empty;
        public string Id { get; set; } = string.Empty;
        public int TenantId { get; set; }
    }
}
