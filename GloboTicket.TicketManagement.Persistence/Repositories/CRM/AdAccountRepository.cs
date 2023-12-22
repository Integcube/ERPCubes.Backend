using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.AdAccount.SaveAdAccount;
using ERPCubes.Domain.Entities;
using ERPCubes.Identity;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Persistence.Repositories.CRM
{
    public class AdAccountRepository : BaseRepository<CrmAdAccount>, IAsyncAdAccountRepository
    {
        public AdAccountRepository(ERPCubesDbContext dbContext, ERPCubesIdentityDbContext dbContextIdentity) : base(dbContext, dbContextIdentity)
        {
        }

        public async Task SaveAdAccount(List<SaveAdAccountCommand> ad)
        {
            try
            {
                DateTime localDateTime = DateTime.Now;

                foreach (var ads in ad)
                {
                    if (ads.AccountId == "-1")
                    {
                        CrmAdAccount addAccount = new CrmAdAccount();
                        addAccount.Title = ads.Title;
                        addAccount.SocialId = ads.SocialId;
                        addAccount.IsSelected = ads.IsSelected;
                        addAccount.CreatedDate = localDateTime.ToUniversalTime();
                        addAccount.TenantId = ads.TenantId;
                        addAccount.IsDeleted = 0;
                        addAccount.CreatedBy = ads.Id;
                        await _dbContext.AddAsync(addAccount);
                        await _dbContext.SaveChangesAsync();

                    }
                    else
                    {
                        var existingAccount = await (from a in _dbContext.CrmAdAccount.Where(a => a.AccountId == ads.AccountId)
                                                     select a).FirstAsync();
                        if (existingAccount == null)
                        {
                            throw new NotFoundException(ads.Title, ads.AccountId);
                        }
                        else
                        {
                            existingAccount.Title = ads.Title;
                            existingAccount.SocialId = ads.SocialId;

                            existingAccount.IsSelected = ads.IsSelected;

                            //addAccount.CreatedBy = ad.Id;
                            //existingAccount.CreatedDate = localDateTime.ToUniversalTime();
                            existingAccount.TenantId = ads.TenantId;
                            existingAccount.IsDeleted = 0;
                            existingAccount.LastModifiedBy = ads.Id;
                            existingAccount.LastModifiedDate = localDateTime.ToUniversalTime();
                            await _dbContext.SaveChangesAsync();
                        }

                    }
                }
                    
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
