using System.Text.Json.Serialization;

namespace ERPCubes.Application.Models.Authentication
{
    public class AuthenticationRequest
    {
        public string Email { get; set; } = string.Empty;
        public string Password { get; set; } = string.Empty;
        public bool RememberMe { get; set; }
    }
}
