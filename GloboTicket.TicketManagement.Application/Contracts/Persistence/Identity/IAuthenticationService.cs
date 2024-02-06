using ERPCubes.Application.Models.Authentication;

namespace ERPCubes.Application.Contracts.Persistence.Identity
{
    public interface IAuthenticationService
    {
        Task<AuthenticationResponse> AuthenticateAsync(AuthenticationRequest request);
        Task<RegistrationResponse> RegisterAsync(RegistrationRequest request);
        Task<RegistrationResponse> UpdateUserAsync(RegistrationRequest request);

    }
}
