using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Linq.Expressions;
using ERPCubes.Application.Features.Crm.Industry.Queries.GetIndustryList;
using ERPCubes.Application.Features.Facebook.Commands.SaveFacebookUser;
using MediatR;

namespace ERPCubesApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class FacebookLoginController : ControllerBase
    {
        private readonly IMediator _mediator;
        public FacebookLoginController(IMediator mediator)
        {
            _mediator = mediator;

        }
        [HttpPost("facebook-login")]
        public async Task<ActionResult> FacebookLogin(SaveFacebookUserCommand request)
        {
            try
            {
                var dtos = await _mediator.Send(request);
                return Ok(dtos);
            }
            catch (Exception ex)
            {
                return BadRequest("Authentication failed");
            }
        }
        [HttpPost("adAccount")]
        public async Task<ActionResult> AdAccount(SaveFacebookUserCommand request)
        {
            try
            {
                var dtos = await _mediator.Send(request);
                return Ok(dtos);
            }
            catch (Exception ex)
            {
                return BadRequest("Authentication failed");
            }
        }
        [HttpGet("signin-facebook")]
        public IActionResult FacebookResponse()
        {


            // Handle the authenticated user (retrieve user info, create session, etc.)
            // Example: var userEmail = result.Principal.FindFirst(ClaimTypes.Email)?.Value;

            return Ok("Successfully authenticated with Facebook");
        }
    }
}
