using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.AdAccount.Commands.BulkSaveAdAccount;
using ERPCubes.Application.Features.Crm.AdAccount.Commands.SaveAdAccount;
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

        public async Task SaveAdAccount(SaveAdAccountCommand ad)
        {
            try
            {
                DateTime localDateTime = DateTime.Now;

                if (ad.AccountId == "-1")
                {
                    CrmAdAccount addAccount = new CrmAdAccount();
                    addAccount.AccountId = $"{new Random().Next(1_000_000_000):000000000}{new Random().Next(1_000_000_000):000000000}";
                    addAccount.Title = ad.Title;
                    addAccount.SocialId = ad.SocialId;
                    addAccount.IsSelected = ad.IsSelected;
                    addAccount.CreatedDate = localDateTime.ToUniversalTime();
                    addAccount.TenantId = ad.TenantId;
                    addAccount.IsDeleted = 0;
                    addAccount.CreatedBy = ad.Id;
                    await _dbContext.AddAsync(addAccount);
                    await _dbContext.SaveChangesAsync();

                }
                else
                {
                    var existingAccount = await (from a in _dbContext.CrmAdAccount.Where(a => a.AccountId == ad.AccountId)
                                                 select a).FirstAsync();
                    if (existingAccount == null)
                    {
                        throw new NotFoundException(ad.Title, ad.AccountId);
                    }
                    else
                    {
                        existingAccount.Title = ad.Title;
                        existingAccount.SocialId = ad.SocialId;
                        existingAccount.IsSelected = ad.IsSelected;
                        existingAccount.TenantId = ad.TenantId;
                        existingAccount.IsDeleted = 0;
                        existingAccount.LastModifiedBy = ad.Id;
                        existingAccount.LastModifiedDate = localDateTime.ToUniversalTime();
                        await _dbContext.SaveChangesAsync();
                    }

                }
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task SaveAdAccountBulk(SaveBulkAdAccountCommand ad)
        {
            try
            {
                DateTime utcDateTime = DateTime.UtcNow;

                await _dbContext.Database.ExecuteSqlRawAsync("DELETE FROM \"CrmAdAccount\" WHERE \"TenantId\" = {0} AND \"Provider\" = {1}", ad.TenantId, ad.AdAccount[0].Provider);
                await _dbContext.SaveChangesAsync();
                foreach (var adAccount in ad.AdAccount)
                {
                    
                        CrmAdAccount addAccount = new CrmAdAccount();
                        addAccount.AccountId = adAccount.AccountId;
                        addAccount.Title = adAccount.Title;
                        addAccount.SocialId = adAccount.SocialId;
                        addAccount.IsSelected = adAccount.IsSelected == true?1:0;
                        addAccount.CreatedDate = utcDateTime;
                        addAccount.TenantId = ad.TenantId;
                        addAccount.IsDeleted = 0;
                        addAccount.CreatedBy = ad.Id;
                    addAccount.Provider = "GOOGLE";
                        await _dbContext.AddAsync(addAccount);

                }
                await _dbContext.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                throw new BadRequestException("Failed to save ad accounts.");
            }
        }

    }
}
