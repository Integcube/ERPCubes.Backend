using ERPCubes.Application.Features.Crm.Tenant.Commands.SaveTenant;
using ERPCubes.Application.Models.Authentication;
using ERPCubes.Application.Models.Mail;

namespace ERPCubes.Application.Contracts.Persistence.Identity
{
    public interface IAuthenticationService
    {
        Task<AuthenticationResponse> AuthenticateAsync(AuthenticationRequest request);
        Task<RegistrationResponse> RegisterAsync(RegistrationRequest request);
        Task<RegistrationResponse> UpdateUserAsync(RegistrationRequest request);
        Task<bool> SaveTenant(SaveTenantCommand request);
    }
}
