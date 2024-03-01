using ERPCubes.Application.Features.Crm.Lead.Commands.BulkSaveLead;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.AdAccount.Commands.BulkSaveAdAccount
{
    public class SaveBulkAdAccountCommand : IRequest
    {
        public int TenantId { get; set; }
        public string Id { get; set; } = String.Empty;
        public List<SaveBulkAdAccountDto> AdAccount { get; set; } = new List<SaveBulkAdAccountDto>();

    }
}
