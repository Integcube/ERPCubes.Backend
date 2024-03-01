using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Campaign.Commands.DeleteCampaign;
using ERPCubes.Application.Features.Crm.Campaign.Commands.RestoreBulkCampiagn;
using ERPCubes.Application.Features.Crm.Campaign.Commands.RestoreCampaign;
using ERPCubes.Application.Features.Crm.Campaign.Commands.SaveCampaign;
using ERPCubes.Application.Features.Crm.Campaign.Queries.GetCampaign;
using ERPCubes.Application.Features.Crm.Campaign.Queries.GetCampaignSource;
using ERPCubes.Application.Features.Crm.Campaign.Queries.GetDeletedCampaigns;
using ERPCubes.Application.Features.Crm.Product.Commands.BulkRestoreProduct;
using ERPCubes.Application.Features.Crm.Product.Commands.RestoreProduct;
using ERPCubes.Application.Features.Crm.Product.Queries.GetDeletedProductList;
using ERPCubes.Domain.Entities;
using ERPCubes.Identity;
using MediatR;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory.Database;

namespace ERPCubes.Persistence.Repositories.CRM
{
    public class CampaignRepository : BaseRepository<CrmCampaign>, IAsyncCampaignRepository
    {
        private const long V = 1_000_000_000_000_000_00;

        public CampaignRepository(ERPCubesDbContext dbContext, ERPCubesIdentityDbContext dbContextIdentity) : base(dbContext, dbContextIdentity)
        {
        }
        public async Task SaveBulkCampaigns(SaveBulkCampaignCommand campaigns)
        {
            try
            {
                DateTime localDateTime = DateTime.Now;

                foreach (var campaign in campaigns.Campaign)
                {
                    if (campaign.CampaignId == "-1")
                    {
                        CrmCampaign addCampaign = new CrmCampaign();
                        addCampaign.CampaignId = $"{new Random().Next(1_000_000_000):000000000}{new Random().Next(1_000_000_000):000000000}";
                        addCampaign.AdAccountId = campaign.AdAccountId;
                        addCampaign.Title = campaign.Title;
                        addCampaign.ProductId = campaign.ProductId;
                        addCampaign.SourceId = campaign.SourceId;
                        addCampaign.Budget = campaign.Budget;
                        addCampaign.CreatedBy = campaign.Id;
                        addCampaign.CreatedDate = localDateTime.ToUniversalTime();
                        addCampaign.TenantId = campaign.TenantId;
                        addCampaign.IsDeleted = 0;
                        await _dbContext.AddAsync(addCampaign);
                    }
                    else
                    {
                        var existingCampaign = await _dbContext.CrmCampaign
                            .Where(a => a.CampaignId == campaign.CampaignId)
                            .FirstOrDefaultAsync();

                        if (existingCampaign == null)
                        {
                            throw new NotFoundException(campaign.Title, campaign.CampaignId);
                        }
                        else
                        {
                            existingCampaign.Title = campaign.Title;
                            existingCampaign.SourceId = campaign.SourceId;
                            existingCampaign.Budget = campaign.Budget;
                            existingCampaign.TenantId = campaign.TenantId;
                            existingCampaign.IsDeleted = 0;
                            existingCampaign.LastModifiedBy = campaign.Id;
                            existingCampaign.LastModifiedDate = localDateTime.ToUniversalTime();
                        }
                    }
                }

                await _dbContext.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task SaveCampaign(SaveCampaignCommand campaign)
        {
            try
            {
                DateTime localDateTime = DateTime.Now;
                {
                    if (campaign.CampaignId == "-1")
                    {
                        CrmCampaign addCampaign = new CrmCampaign();
                        addCampaign.CampaignId = $"{new Random().Next(1_000_000_000):000000000}{new Random().Next(1_000_000_000):000000000}";
                        addCampaign.AdAccountId = campaign.AdAccountId;
                        addCampaign.Title = campaign.Title;
                        addCampaign.ProductId = campaign.ProductId;
                        addCampaign.SourceId = campaign.SourceId;
                        addCampaign.Budget = campaign.Budget;
                        addCampaign.CreatedBy = campaign.Id;
                        addCampaign.CreatedDate = localDateTime.ToUniversalTime();
                        addCampaign.TenantId = campaign.TenantId;
                        addCampaign.IsDeleted = 0;
                        await _dbContext.AddAsync(addCampaign);
                    }
                    else
                    {
                        var existingCampaign = await _dbContext.CrmCampaign
                            .Where(a => a.CampaignId == campaign.CampaignId)
                            .FirstOrDefaultAsync();

                        if (existingCampaign == null)
                        {
                            throw new NotFoundException(campaign.Title, campaign.CampaignId);
                        }
                        else
                        {
                            existingCampaign.Title = campaign.Title;
                            existingCampaign.SourceId = campaign.SourceId;
                            existingCampaign.Budget = campaign.Budget;
                            existingCampaign.TenantId = campaign.TenantId;
                            existingCampaign.IsDeleted = 0;
                            existingCampaign.LastModifiedBy = campaign.Id;
                            existingCampaign.LastModifiedDate = localDateTime.ToUniversalTime();
                        }
                    }
                }

                await _dbContext.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }
        
        public async Task<List<GetCampaignVm>> GetCampaign(GetCampaignQuery campaign)
        {
            try
            {
                List<GetCampaignVm> getCampaigns = await (
                    from a in _dbContext.CrmCampaign.Where(a => a.TenantId == campaign.TenantId && a.IsDeleted == 0) orderby a.CreatedDate
                    //join b in _dbContext.CrmCampaignSource on a.SourceId equals b.SourceId
                    //join c in _dbContext.CrmProduct on a.ProductId equals c.ProductId
                    select new GetCampaignVm
                    {
                        CampaignId = a.CampaignId,
                        AdAccountId = a.AdAccountId,
                        Title = a.Title,
                        ProductId = a.ProductId,
                        //ProductName = c.ProductName,
                        SourceId = a.SourceId,
                        //SourceTitle = b.SourceTitle,
                        Budget = a.Budget,
                    }).ToListAsync();
                return getCampaigns;
            }
            catch (Exception ex) 
            {
                throw new Exception(ex.Message);
            }
        }
        
        public async Task DeleteCampaign(DeleteCampaignCommand campaign)
        {
            try
            {
                CrmCampaign? deleteCampaign = await (
                    from a in _dbContext.CrmCampaign.Where(a => a.TenantId == campaign.TenantId && a.CampaignId == campaign.CampaignId)
                    select a).FirstOrDefaultAsync();
                if (deleteCampaign == null)
                {
                    throw new NotFoundException("Campaign not found", campaign.CampaignId);
                }
                else
                {
                    deleteCampaign.IsDeleted = 1;
                    deleteCampaign.DeletedBy = campaign.Id;
                    deleteCampaign.DeletedDate = DateTime.Now.ToUniversalTime();
                    await _dbContext.SaveChangesAsync();
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }
        public async Task<List<GetCampaignSourceVm>> GetCampaignSource(GetCampaignSourceQuery campaignSource)
        {
            List<GetCampaignSourceVm> sources = new List<GetCampaignSourceVm>();
            try
            {
                sources = await(from a in _dbContext.CrmLeadSource.Where(a => a.IsDeleted == 0)
                                select new GetCampaignSourceVm
                                {
                                    SourceId = a.SourceId,
                                    SourceTitle = a.SourceTitle,
                                }).ToListAsync();
                return sources;
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        public async Task<List<GetDeletedCampaignVm>> GetDeletedCampaigns(int TenantId, string Id)
        {
            try
            {
                List<GetDeletedCampaignVm> campaignDetail = await(from a in _dbContext.CrmCampaign.Where(a => a.TenantId == TenantId && a.IsDeleted == 1)
                                                                join user in _dbContext.AppUser on a.DeletedBy equals user.Id
                                                                select new GetDeletedCampaignVm
                                                                {
                                                                    Id = a.CampaignId,
                                                                    Title = a.Title,
                                                                    DeletedBy = user.FirstName + " " + user.LastName,
                                                                    DeletedDate = a.DeletedDate,
                                                                }).OrderBy(a => a.Title).ToListAsync();
                return campaignDetail;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task RestoreCampaign(RestoreCampaignCommand campaign)
        {
            try
            {
                var restoreCampaign = await(from a in _dbContext.CrmCampaign.Where(a => a.CampaignId == campaign.CampaignId)
                                           select a).FirstOrDefaultAsync();
                if (restoreCampaign == null)
                {
                    throw new NotFoundException("campaign", campaign);
                }
                else
                {
                    restoreCampaign.IsDeleted = 0;
                    await _dbContext.SaveChangesAsync();
                }
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task RestoreBulkCampaign(RestoreBulkCampaignCommand campaign)
        {
            try
            {
                foreach (var campaignId in campaign.CampaignId)
                {
                    var campaignDetail = await _dbContext.CrmCampaign
                        .Where(p => p.CampaignId == campaignId && p.IsDeleted == 1)
                        .FirstOrDefaultAsync();

                    if (campaignDetail == null)
                    {
                        throw new NotFoundException(nameof(campaignId), campaignId);
                    }

                    campaignDetail.IsDeleted = 0;
                }

                await _dbContext.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
