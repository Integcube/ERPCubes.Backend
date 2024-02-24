using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.FormBuilder.Queries.GetFormFields
{
    public class GetFormFieldsQuery: IRequest<List<GetFormFieldsVm>>
    {
        public int FormId { get; set; }
        public string TenantGuid { get; set; } = string.Empty;
       // public string Id { get; set; } = string.Empty;
    }
}
