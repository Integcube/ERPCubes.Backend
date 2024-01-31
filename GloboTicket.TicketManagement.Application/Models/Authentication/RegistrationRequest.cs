using System.ComponentModel.DataAnnotations;

namespace ERPCubes.Application.Models.Authentication
{
    public class RegistrationRequest
    {


        
        public string UserId { get; set; } = string.Empty;
        [Required] 
        public string FirstName { get; set; } = string.Empty;

        [Required]
        public string LastName { get; set; } = string.Empty;

        [Required]
        public int TenantId { get; set; }

        [Required]
        [EmailAddress]
        public string Email { get; set; } = string.Empty;

        [Required]
        [MinLength(6)]
        public string UserName { get; set; } = string.Empty;

        [Required]
        [MinLength(6)]
        public string Password { get; set; } = string.Empty;

        public string PhoneNumber { get; set; } = string.Empty;
    }
}
