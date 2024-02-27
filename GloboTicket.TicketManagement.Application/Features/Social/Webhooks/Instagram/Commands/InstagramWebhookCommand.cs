using ERPCubesApi.Models;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Social.Webhooks.Instagram.Commands
{
    public class InstagramWebhookCommand:IRequest<InstagramWebhookVm>
    {
        public string TenantGuid { get; set; }
        public InstagramWebhook Data { get; set; }
    }
}
