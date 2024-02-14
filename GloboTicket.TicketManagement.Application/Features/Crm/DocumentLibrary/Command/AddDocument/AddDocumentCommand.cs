using ERPCubes.Application.Features.Crm.DocumentLibrary.Command.AddDocument;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.DocumentLibrary.Command.AddDocument
{
    public class AddDocumentCommand:IRequest<AddDocumentCommandVm>
    {
        public string Id { get; set; }
        public int TenantId { get; set; }
        public AddDocumentCommandVm Document { get; set; }
    }
}
