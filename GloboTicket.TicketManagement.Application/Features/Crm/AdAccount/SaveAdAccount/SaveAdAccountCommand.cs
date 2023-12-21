using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.AdAccount.SaveAdAccount
{
    public class SaveAdAccountCommand : IRequest
    {
        public int AccountId { get; set; }
        public string Title { get; set; } = String.Empty;
        public int IsSelected { get; set; }
        public string SocialId { get; set; } = String.Empty;
        public string Id { get; set; } = String.Empty;
        public int TenantId { get; set; }
    }
}
