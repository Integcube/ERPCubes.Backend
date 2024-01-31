using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.AppUser.Commands.DeleteUser
{
    public class DeleteUserCommand : IRequest
    {
        public string Id { get; set; } 
        public string UserId { get; set; } 
        public int TenantId { get; set; }
    }
}
