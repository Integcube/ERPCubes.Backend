using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Google.Commands.SaveAuth
{
    public class GoogleAuthUser
    {
        public string Sub { get; set; }=string.Empty;
        public string Email { get; set; } = string.Empty;
        public string Name { get; set; } = string.Empty;
        public string Given_Name { get; set; } = string.Empty;
        public string Family_Name { get; set; } = string.Empty;
        public string Picture { get; set; } = string.Empty;
    }
}
