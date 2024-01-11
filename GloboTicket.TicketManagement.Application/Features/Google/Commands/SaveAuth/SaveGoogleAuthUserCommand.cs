using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Google.Commands.SaveAuth
{
    public class SaveGoogleAuthUserCommand:IRequest
    {
        public int TenantId { get; set; }
        public string Id { get; set; } = string.Empty;
        public string AuthToken { get; set; } = string.Empty;
        public string AuthCode { get; set; } = string.Empty;
        public string IdToken { get; set; } = string.Empty;
        public GoogleAuthUser User { get; set; } = new GoogleAuthUser();
    }
}
