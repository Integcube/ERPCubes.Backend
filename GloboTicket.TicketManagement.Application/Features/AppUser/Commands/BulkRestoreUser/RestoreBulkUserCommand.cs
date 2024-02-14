using ERPCubes.Application.Features.AppUser.Commands.RestoreUser;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.AppUser.Commands.BulkRestoreUser
{
    public class RestoreBulkUserCommand : IRequest
    {

        public string Id { get; set; }
        public RestoreBulkUserDto? User { get; set; }

    }
}
