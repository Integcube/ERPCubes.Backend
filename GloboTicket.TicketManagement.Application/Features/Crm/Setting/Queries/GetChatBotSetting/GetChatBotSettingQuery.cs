using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Setting.Queries.GetChatBotSetting
{

    public class GetChatBotSettingQuery : IRequest<GetChatBotSettingQueryVm>
    {
        public int TenantId { get; set; }
    }
}
