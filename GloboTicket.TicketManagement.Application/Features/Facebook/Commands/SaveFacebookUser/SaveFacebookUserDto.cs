using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Facebook.Commands.SaveFacebookUser
{
    public class SaveFacebookUserDto
    {
        public string AuthToken { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string FirstName { get; set; } = string.Empty;
        public string Id { get; set; } = string.Empty;
        public string LastName { get; set; } = string.Empty;
        public string Name { get; set; } = string.Empty;
        public string PhotoUrl { get; set; } = string.Empty;
        public string Provider { get; set; } = string.Empty; 
        public string IdToken { get; set; } = string.Empty;
        public string AuthorizationCode { get; set; } = string.Empty;
    }
}
