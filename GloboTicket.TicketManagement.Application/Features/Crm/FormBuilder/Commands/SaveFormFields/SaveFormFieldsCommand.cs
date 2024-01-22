using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.FormBuilder.Commands.SaveFormFields
{
    public class SaveFormFieldsCommand: IRequest
    {
        public int TenantId { get; set; }
        public string Id { get; set; }
        public List<SaveFormFieldsDto> FormFields { get; set; } = new List<SaveFormFieldsDto>();
    }
}
