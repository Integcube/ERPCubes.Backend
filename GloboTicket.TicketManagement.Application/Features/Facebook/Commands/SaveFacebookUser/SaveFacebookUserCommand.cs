using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Facebook.Commands.SaveFacebookUser
{
    public class SaveFacebookUserCommand:IRequest
    {
        public string Id { get; set; }
        public int TenantId { get; set; }
        public SaveFacebookUserDto FbUser { get; set; } = new SaveFacebookUserDto();
    }
}
