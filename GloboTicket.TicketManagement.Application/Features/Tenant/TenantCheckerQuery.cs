using MediatR;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.TenantChecker
{
    public class TenantCheckerQuery:IRequest<bool>
    {
        public string Subdomain { get; set; }
    }
}
