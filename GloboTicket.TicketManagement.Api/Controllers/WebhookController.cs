using ERPCubes.Domain.Entities;
using ERPCubesApi.Models;
using MediatR;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using System.Net.Sockets;
using System.Text;

namespace ERPCubesApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class WebhookController : ControllerBase
    {
        private readonly IMediator _mediator;
        public WebhookController(IMediator mediator)
        {
            _mediator = mediator;
        }
        [HttpGet]
        public IActionResult VerifyWebhook([FromQuery(Name = "hub.mode")] string mode,
                                         [FromQuery(Name = "hub.challenge")] string challenge,
                                         [FromQuery(Name = "hub.verify_token")] string verifyToken)
        {
            if (mode == "subscribe" && verifyToken == "BL090")
            {
                return Ok(challenge);
            }
            else
            {
                return StatusCode(403); 
            }
        }
        [HttpPost("instagram")]
        public async Task<IActionResult> HandleInstagramWebhook([FromQuery(Name = "tenantId")] string tenantId)
        {
            try
            {
                using (StreamReader reader = new StreamReader(Request.Body, Encoding.UTF8))
                {
                    string body = await reader.ReadToEndAsync();
                    InstagramWebhook instagramWebhook = JsonConvert.DeserializeObject<InstagramWebhook>(body);
                    
                    return Ok();
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error processing Instagram webhook: {ex.Message}");
                return StatusCode(500, "An error occurred while processing the Instagram webhook");
            }
        }


    }
}
