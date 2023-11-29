using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Email.Commands.DeleteEmail
{
    public class DeleteEmailCommand : IRequest
    {
        public int EmailId { get; set; }
    }
}
