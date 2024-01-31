using ERPCubes.Application.Contracts.Identity;
using ERPCubes.Application.Models.Authentication;
using Microsoft.AspNetCore.Mvc;

namespace ERPCubes.Api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AccountController : ControllerBase
    {
        private readonly IAuthenticationService _authenticationService;
        public AccountController(IAuthenticationService authenticationService)
        {
            _authenticationService = authenticationService;
        }

        [HttpPost("authenticate")]
        public async Task<ActionResult<AuthenticationResponse>> AuthenticateAsync(AuthenticationRequest request)
        {
            return Ok(await _authenticationService.AuthenticateAsync(request));
        }

        [HttpPost("register")]
        public async Task<ActionResult<RegistrationResponse>> RegisterAsync(RegistrationRequest request)
        {
            return Ok(await _authenticationService.RegisterAsync(request));
        }

        [HttpPost("Update")]
        public async Task<ActionResult<RegistrationResponse>> UpdateUser(RegistrationRequest request)
        {
            return Ok(await _authenticationService.UpdateUserAsync(request));
        }
        

    }
}
