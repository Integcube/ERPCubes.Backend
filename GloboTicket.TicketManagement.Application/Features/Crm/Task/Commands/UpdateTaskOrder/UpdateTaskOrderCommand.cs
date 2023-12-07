using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Task.Commands.UpdateTaskOrder
{
    public class UpdateTaskOrderCommand:IRequest
    {
        public List<UpdateTaskOrderDto> Tasks { get; set; } = new List<UpdateTaskOrderDto>();
    }
}
