using ERPCubesApi.Models;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static ERPCubesApi.Models.WhatsappWebhook;

namespace ERPCubes.Application.Features.Social.Webhooks.Whatsapp.Commands
{
    public class WhatsappWebhookCommand:IRequest<WhatsappWebhookVm>
    {
        public string TenantGuid { get; set; }
        public WhatsAppWebhook Data { get; set; }
    }
}
