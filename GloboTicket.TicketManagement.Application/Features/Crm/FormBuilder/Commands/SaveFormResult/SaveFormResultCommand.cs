using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.FormBuilder.Commands.SaveFormResult
{
    public class SaveFormResultCommand: IRequest
    {
        public string TenantGuid { get; set; }
        public List<SaveFormResultDto> FormResult { get; set; } = new List<SaveFormResultDto>();
    }
}
