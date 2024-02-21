using ERPCubes.Application.Features.Social.Webhooks.Instagram.Commands;
using ERPCubes.Application.Features.Social.Webhooks.Whatsapp.Commands;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Contracts.Persistence.Social.Webhooks
{
    public interface IAsyncWebhookRepository
    {
        Task<InstagramWebhookVm> SaveInstaMessage(InstagramWebhookCommand message);
        Task<WhatsappWebhookVm> SaveWhatsappMessage(WhatsappWebhookCommand message);
    }
}
