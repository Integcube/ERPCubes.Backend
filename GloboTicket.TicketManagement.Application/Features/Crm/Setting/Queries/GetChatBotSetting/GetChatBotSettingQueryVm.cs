using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Setting.Queries.GetChatBotSetting
{
    public class GetChatBotSettingQueryVm
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string PrimaryColor { get; set; }
        public int TenantId { get; set; }
    }

}
