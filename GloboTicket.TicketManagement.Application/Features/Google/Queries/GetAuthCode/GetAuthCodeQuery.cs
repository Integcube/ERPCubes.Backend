using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Google.Queries.GetAuthCode
{
    public class GetAuthCodeQuery : IRequest<string>
    {
        public string Id { get; set; }=string.Empty;
        public int TenantId { get; set; }
        public string Provider { get; set; } = string.Empty;
    }
}
