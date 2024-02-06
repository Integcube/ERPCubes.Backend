using ERPCubes.Application.Features.Tickets.Queries.GetAllTickets;
using ERPCubes.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Social.Webhooks.Whatsapp.Commands
{
    public class WhatsappWebhookVm
    {
        public GetAllTicketsVm Ticket { get; set; }
        public Conversation Conversation { get; set; }
    }
}
