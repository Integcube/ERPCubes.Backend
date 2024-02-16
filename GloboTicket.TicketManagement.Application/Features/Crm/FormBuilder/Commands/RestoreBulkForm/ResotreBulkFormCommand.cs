using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.FormBuilder.Commands.RestoreBulkForm
{
    public class ResotreBulkFormCommand : IRequest
    {
        public List<int> FormId { get; set; }
    }
}
