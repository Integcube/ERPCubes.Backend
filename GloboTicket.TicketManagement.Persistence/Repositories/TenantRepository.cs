using ERPCubes.Application.Contracts.Persistence.TenantChecker;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Lead.Commands.SaveLead;
using ERPCubes.Application.Features.Crm.Tenant.Commands.SaveTenant;
using ERPCubes.Application.Models.Authentication;
using ERPCubes.Application.Models.Mail;
using ERPCubes.Domain.Entities;
using ERPCubes.Identity;
using ERPCubes.Identity.Models;
using MediatR;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using System.Transactions;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory.Database;

namespace ERPCubes.Persistence.Repositories
{
    public class TenantRepository : BaseRepository<Task>, IAsyncTenantRepository
    {
        private readonly UserManager<ApplicationUser> _userManager;
        public TenantRepository(ERPCubesDbContext dbContext, ERPCubesIdentityDbContext dbContextIdentity, UserManager<ApplicationUser> userManager) : base(dbContext, dbContextIdentity)
        {
            _userManager = userManager;
        }
        
        public async Task<bool> CheckTenant(string subdomain)
        {
            try
            {
                Tenant tenant = await (from a in _dbContextIdentity.Tenant.Where(a => a.Subdomain.ToLower() == subdomain.ToLower())
                                       select a).FirstOrDefaultAsync();
                if(tenant == null)
                {
                    return false;
                }
                return true;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }
        public async Task SaveTenant(SaveTenantCommand obj)
        {
            using (var transaction = await _dbContextIdentity.Database.BeginTransactionAsync())
            {
                try
                {
                    Tenant NewObj = new Tenant();

                    NewObj.Name = obj.Company;
                    NewObj.Subdomain = obj.Domain;
                    NewObj.IsDocumentAcces = 1;
                    NewObj.IsDeleted = 0;
                    NewObj.Owner = obj.FirstName;
                    NewObj.CreatedBy = obj.FirstName;
                    NewObj.CreatedDate = DateTime.UtcNow; ;
                    NewObj.TenantGuid = Guid.NewGuid();
                   
                    _dbContextIdentity.Add(NewObj);
                    _dbContextIdentity.SaveChanges();


                    var user = new ApplicationUser();

                    user.FirstName = obj.FirstName;
                    user.LastName = obj.LastName;
                    user.UserName = obj.FirstName.ToLower() + "01";
                    user.PhoneNumber = "";
                    user.EmailConfirmed = true;
                    user.TenantId = NewObj.TenantId;
                   
                    //var result = await _userManager.CreateAsync(user, obj.Password);

                    await transaction.CommitAsync();

                    //return new Email {
                    //    Body = "Welcome to our platform!",
                    //    Subject = "Welcome Email",
                    //    To = NewObj.Name
                    //};
                }

                catch (Exception e)
                {
                    await transaction.RollbackAsync();
                    throw new BadRequestException(e.Message);
                  
                }
            }
        }
    }
}
   