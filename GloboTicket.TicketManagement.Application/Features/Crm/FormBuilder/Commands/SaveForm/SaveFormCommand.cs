using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.FormBuilder.Commands.SaveForm
{
    public class SaveFormCommand: IRequest
    {
        public int FormId { get; set; }
        public string Name { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public string Code { get; set; } = string.Empty;
        public string Id { get; set; } = string.Empty;
        public int TenantId { get; set; }
    }
}
