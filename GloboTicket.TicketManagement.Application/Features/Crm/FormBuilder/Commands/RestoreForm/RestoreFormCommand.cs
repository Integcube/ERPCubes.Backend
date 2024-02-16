using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.FormBuilder.Commands.RestoreForm
{
    public class RestoreFormCommand : IRequest
    {
        public int FormId { get; set; }

    }
}
