using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.DocumentLibrary.Command.AddFile
{
    public class AddFileCommand:IRequest<AddFileCommandVm>
    {
        public string Id { get; set; }
        public int TenantId { get; set; }
        public string FileName { get; set; }
        public int ParentId { get; set; }
        public string Description { get; set; }
    }
}
