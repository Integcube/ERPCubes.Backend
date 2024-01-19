using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.FormBuilder.Queries.GetFieldTypes
{
    public class GetFieldTypesQuery: IRequest<List<GetFieldTypesVm>>
    {
        //public string Id { get; set; }
    }
}
