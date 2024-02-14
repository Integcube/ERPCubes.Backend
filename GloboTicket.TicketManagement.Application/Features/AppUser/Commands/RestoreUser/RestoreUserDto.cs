using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.AppUser.Commands.RestoreUser
{
    public class RestoreUserDto
    {
        public string Id { get; set; }
        public int TenantId { get; set; }
    }
}
