using ERPCubes.Application.Features.Crm.Tenant.Commands.SaveTenant;
using ERPCubes.Application.Models.Mail;


namespace ERPCubes.Application.Contracts.Persistence.TenantChecker
{
    public interface IAsyncTenantRepository
    {
        Task<bool> CheckTenant(string subdomain);
        Task SaveTenant(SaveTenantCommand request);
    }
}
