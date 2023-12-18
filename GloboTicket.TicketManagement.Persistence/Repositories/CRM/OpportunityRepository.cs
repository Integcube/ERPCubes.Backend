using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Opportunity.Commands.DeleteOpportunity;
using ERPCubes.Application.Features.Crm.Opportunity.Commands.SaveOpportunity;
using ERPCubes.Application.Features.Crm.Opportunity.Queries.GetOpportunity;
using ERPCubes.Application.Features.Crm.Opportunity.Queries.GetOpportuntiySource;
using ERPCubes.Domain.Entities;
using ERPCubes.Identity;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace ERPCubes.Persistence.Repositories.CRM
{
    public class OpportunityRepository : BaseRepository<CrmOpportunity>, IAsyncOpportunityRepository
    {
        public OpportunityRepository(ERPCubesDbContext dbContext, ERPCubesIdentityDbContext dbContextIdentity) : base(dbContext, dbContextIdentity)
        {
        }
        public async Task<List<GetOpportunityVm>> GetOpportunity(GetOpportunityQuery request)
        {
            try
            {
                List<GetOpportunityVm> Opportunity = await (from a in _dbContext.CrmOpportunity.Where(a => a.TenantId == request.TenantId && a.IsDeleted == 0)
                                                            select new GetOpportunityVm
                                                            {
                                                                OpportunityId = a.OpportunityId,
                                                                OpportunityTitle = a.OpportunityTitle,
                                                                OpportunitySource = a.OpportunitySource,
                                                                OpportunityDetail = a.OpportunityDetail
                                                            }).ToListAsync();

                if (Opportunity == null)
                {
                    throw new NotFoundException("Error in GetOpportunity", "");
                }
                else
                {
                    return Opportunity;
                }
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }
        public async Task<List<GetOpportunitySourceVm>> GetOpportunitySource(GetOpportunitySourceQuery request)
        {
            try
            {
                List<GetOpportunitySourceVm> OpportunitySource = await (
                    from a in _dbContext.CrmOpportunitySource.Where(a => a.IsDeleted == 0)
                    select new GetOpportunitySourceVm
                    {
                        SourceId = a.SourceId,
                        SourceTitle = a.SourceTitle
                    }).ToListAsync();
                if (OpportunitySource == null)
                {
                    throw new NotFoundException("Error in GetOpportunity", "");
                }
                else
                {
                    return OpportunitySource;
                }
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }
        public async Task SaveOpportunity(SaveOpportunityCommand request)
        {
            try
            {
                DateTime localDateTime = DateTime.Now;
                if (request.OpportunityId == -1)
                {
                    CrmOpportunity OpportunityObj = new CrmOpportunity();
                    OpportunityObj.OpportunityTitle = request.OpportunityTitle;
                    OpportunityObj.OpportunitySource = request.OpportunitySource;
                    OpportunityObj.OpportunityDetail = request.OpportunityDetail;
                    OpportunityObj.CreatedBy = request.Id;
                    OpportunityObj.CreatedDate = localDateTime.ToUniversalTime();
                    OpportunityObj.TenantId = request.TenantId;
                    await _dbContext.AddAsync(OpportunityObj);
                    await _dbContext.SaveChangesAsync();

                }
                else
                {
                    CrmOpportunity? OpportunityObj = await (from a in _dbContext.CrmOpportunity.Where(a => a.OpportunityId == request.OpportunityId)
                                                            select a).FirstAsync();
                    if (OpportunityObj == null)
                    {
                        throw new NotFoundException("Error in Save Opportunity: ", "Could not find specified");
                    }
                    else
                    {
                        OpportunityObj.OpportunityTitle = request.OpportunityTitle;
                        OpportunityObj.OpportunitySource = request.OpportunitySource;
                        OpportunityObj.OpportunityDetail = request.OpportunityDetail;
                        OpportunityObj.LastModifiedBy = request.Id;
                        OpportunityObj.LastModifiedDate = localDateTime.ToUniversalTime();
                        await _dbContext.SaveChangesAsync();
                    }

                }
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }
        public async Task DeleteOpportunity(DeleteOpportunityCommand request)
        {
            try
            {
                CrmOpportunity? Opportunity = await (from a in _dbContext.CrmOpportunity.Where(a => a.OpportunityId == request.OpportunityId)
                                                     select a).FirstOrDefaultAsync();

                if (Opportunity == null)
                {
                    throw new NotFoundException("Opportunity not found", " ");
                }
                else
                {
                    Opportunity.IsDeleted = 1;
                    await _dbContext.SaveChangesAsync();
                }
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

    }
}
