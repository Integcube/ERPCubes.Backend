﻿using ERPCubes.Application.Features.Social.Webhooks.Instagram.Commands;
using ERPCubes.Application.Features.Social.Webhooks.Whatsapp.Commands;
using ERPCubes.Domain.Entities;
using ERPCubesApi.Hubs;
using ERPCubesApi.Models;
using MediatR;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;
using Newtonsoft.Json;
using System.Net.Sockets;
using System.Text;
using static ERPCubesApi.Models.WhatsappWebhook;

namespace ERPCubesApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class WebhookController : ControllerBase
    {
        private readonly IMediator _mediator;
        private readonly IHubContext<TicketHub> _hubContext;

        public WebhookController(IMediator mediator, IHubContext<TicketHub> hubContext)
        {
            _mediator = mediator;
            _hubContext = hubContext;
        }
        [HttpGet]
        public IActionResult VerifyWebhook([FromQuery(Name = "hub.mode")] string mode,
                                         [FromQuery(Name = "hub.challenge")] string challenge,
                                         [FromQuery(Name = "hub.verify_token")] string verifyToken)
        {
            if (mode == "subscribe" && verifyToken == "BL090VB^IR%NGDR%$U&")
            {
                return Ok(challenge);
            }
            else
            {
                return StatusCode(403); 
            }
        }
        [HttpPost("instagram")]
        public async Task<IActionResult> HandleInstagramWebhook([FromQuery(Name = "key")] string key)
        {
            try
            {
                using (StreamReader reader = new StreamReader(Request.Body, Encoding.UTF8))
                {
                    string body = await reader.ReadToEndAsync();
                    InstagramWebhook instagramWebhook = JsonConvert.DeserializeObject<InstagramWebhook>(body);
                    InstagramWebhookCommand data = new InstagramWebhookCommand
                    {
                        TenantGuid = key,
                        Data = instagramWebhook
                    };
                    InstagramWebhookVm dtos = await _mediator.Send(data);
                    await _hubContext.Clients.All.SendAsync("ReceiveNewTicket", dtos.Ticket);

                    return Ok(dtos);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error processing Instagram webhook: {ex.Message}");
                return StatusCode(500, "An error occurred while processing the Instagram webhook");
            }
        }
        [HttpPost("whatsapp")]
        public async Task<IActionResult> HandleWhatsAppWebhook([FromQuery(Name = "key")] string key)
        {
            try
            {
                using (StreamReader reader = new StreamReader(Request.Body, Encoding.UTF8))
                {
                    string body = await reader.ReadToEndAsync();
                    WhatsAppWebhook whatsappWebhook = JsonConvert.DeserializeObject<WhatsAppWebhook>(body);

                    WhatsappWebhookCommand data = new WhatsappWebhookCommand
                    {
                        TenantGuid = key,
                        Data = whatsappWebhook
                    };

                    WhatsappWebhookVm dtos = await _mediator.Send(data);
                    await _hubContext.Clients.All.SendAsync("ReceiveNewTicket", dtos.Ticket);

                    // Add your custom logic here, if needed

                    return Ok(dtos);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error processing WhatsApp webhook: {ex.Message}");
                return StatusCode(500, "An error occurred while processing the WhatsApp webhook");
            }
        }

    }
}
