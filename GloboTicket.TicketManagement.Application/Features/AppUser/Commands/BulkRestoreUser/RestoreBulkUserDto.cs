using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.AppUser.Commands.BulkRestoreUser
{
    public class RestoreBulkUserDto
    {
        public int TenantId { get; set; }
        public List<string> Id { get; set; }
    }
}
