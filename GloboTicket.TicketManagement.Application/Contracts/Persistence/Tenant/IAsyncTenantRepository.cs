using ERPCubes.Application.Features.Tickets.Queries.GetAllTickets;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Contracts.Persistence.TenantChecker
{
    public interface IAsyncTenantRepository
    {
        Task<bool> CheckTenant(string subdomain);

    }
}
