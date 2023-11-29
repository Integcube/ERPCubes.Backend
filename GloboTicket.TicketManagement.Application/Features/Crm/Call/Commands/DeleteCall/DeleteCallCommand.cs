using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Call.Commands.DeleteCall
{
    public class DeleteCallCommand: IRequest
    {
        public int CallId { get; set; }

    }
}
