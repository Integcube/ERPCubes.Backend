using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Campaign.Commands.SaveCampaign;
using ERPCubes.Domain.Entities;
using ERPCubes.Identity;
using MediatR;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Persistence.Repositories.CRM
{
    public class CampaignRepository : BaseRepository<CrmCampaign>, IAsyncCampaignRepository
    {
        public CampaignRepository(ERPCubesDbContext dbContext, ERPCubesIdentityDbContext dbContextIdentity) : base(dbContext, dbContextIdentity)
        {
        }
        public async Task SaveCampaigns(List<SaveCampaignCommand> campaigns)
        {
            try
            {
                DateTime localDateTime = DateTime.Now;

                foreach (var campaign in campaigns )
                {
                    if (campaign.CampaignId == "-1")
                    {
                        CrmCampaign addCampaign = new CrmCampaign();
                        addCampaign.AdAccountId = campaign.AdAccountId;
                        addCampaign.Title = campaign.Title;
                        addCampaign.ProductId = campaign.ProductId;
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
                            existingCampaign.TenantId = campaign.TenantId;
                            existingCampaign.IsDeleted = 0;
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


    }
}
