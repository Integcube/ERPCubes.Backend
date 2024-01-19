using ERPCubes.Application.Features.Crm.FormBuilder.Queries.GetForms;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.FormBuilder.Queries.GetFormsList
{
    public class GetFormsListQuery: IRequest<List<GetFormsListVm>>
    {
        //public string Id { get; set; }
        public int TenantId { get; set; }
    }
}
