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

                        //addAccount.CreatedBy = ad.Id;
                        //existingAccount.CreatedDate = localDateTime.ToUniversalTime();
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
                DateTime localDateTime = DateTime.Now;

                foreach (var adAccount in ad.AdAccount)
                {
                    if (adAccount.AccountId == "-1")
                    {
                        CrmAdAccount addAccount = new CrmAdAccount();
                        addAccount.AccountId = $"{new Random().Next(1_000_000_000):000000000}{new Random().Next(1_000_000_000):000000000}";
                        addAccount.Title = adAccount.Title;
                        addAccount.SocialId = adAccount.SocialId;
                        addAccount.IsSelected = adAccount.IsSelected;
                        addAccount.CreatedDate = localDateTime.ToUniversalTime();
                        addAccount.TenantId = adAccount.TenantId;
                        addAccount.IsDeleted = 0;
                        addAccount.CreatedBy = adAccount.Id;
                        await _dbContext.AddAsync(addAccount);
                        await _dbContext.SaveChangesAsync();

                    }
                    else
                    {
                        var existingAccount = await (from a in _dbContext.CrmAdAccount.Where(a => a.AccountId == adAccount.AccountId)
                                                     select a).FirstAsync();
                        if (existingAccount == null)
                        {
                            throw new NotFoundException(adAccount.Title, adAccount.AccountId);
                        }
                        else
                        {
                            existingAccount.Title = adAccount.Title;
                            existingAccount.SocialId = adAccount.SocialId;

                            existingAccount.IsSelected = adAccount.IsSelected;

                            //addAccount.CreatedBy = ad.Id;
                            //existingAccount.CreatedDate = localDateTime.ToUniversalTime();
                            existingAccount.TenantId = adAccount.TenantId;
                            existingAccount.IsDeleted = 0;
                            existingAccount.LastModifiedBy = adAccount.Id;
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
