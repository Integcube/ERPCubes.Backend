using ERPCubes.Application.Features.Crm.AdAccount.SaveAdAccount;
using ERPCubes.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Contracts.Persistence.CRM
{
    public interface IAsyncAdAccountRepository : IAsyncRepository<CrmAdAccount>
    {
        Task SaveAdAccount(SaveAdAccountCommand ad);
    }
}
