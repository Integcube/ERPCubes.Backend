using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Opportunity.Commands.RestoreBulkOpportunity;
using ERPCubes.Application.Features.Crm.Opportunity.Queries.GetDeletedOpportunity;
using ERPCubes.Application.Features.Crm.Opportunity.Commands.DeleteOpportunity;
using ERPCubes.Application.Features.Crm.Opportunity.Commands.RestoreOpportunity;
using ERPCubes.Application.Features.Crm.Opportunity.Commands.SaveOpportunity;
using ERPCubes.Application.Features.Crm.Opportunity.Queries.GetOpportunity;
using ERPCubes.Application.Features.Crm.Opportunity.Queries.GetOpportunityStatus;
using ERPCubes.Application.Features.Crm.Opportunity.Queries.GetOpportuntiySource;
using ERPCubes.Domain.Entities;
using ERPCubes.Identity;
using Microsoft.EntityFrameworkCore;
using ERPCubes.Application.Features.Crm.Opportunity.Queries.GetOpportunityAttachments;
using ERPCubes.Application.Features.Crm.Opportunity.Commands.ChangeOpportunityStatus;

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
                List<GetOpportunityVm> Opportunity = await (
                    from a in _dbContext.CrmOpportunity.Where(a => a.TenantId == request.TenantId && a.IsDeleted == 0)
                    //&& (CreatedDate == null || a.CreatedDate >= CreatedDate) && (ModifiedDate == null || a.LastModifiedDate >= ModifiedDate) && ((OwnerIds.Count == 0) || OwnerIds.Contains(a.OpportunityOwner)) && ((StatusIds.Count == 0) || StatusIds.Contains((int)a.Status))
                    join s in _dbContext.CrmOpportunityStatus.Where(a => a.TenantId == request.TenantId || a.TenantId == -1 && a.IsDeleted == 0) on a.StatusId equals s.StatusId
                    join i in _dbContext.CrmIndustry.Where(a => a.TenantId == request.TenantId || a.TenantId == -1 && a.IsDeleted == 0) on a.IndustryId equals i.IndustryId into all
                    from ii in all.DefaultIfEmpty()
                    join z in _dbContext.CrmLeadSource.Where(a => a.TenantId == request.TenantId || a.TenantId == -1 && a.IsDeleted == 0) on a.SourceId equals z.SourceId into all2
                    from zz in all2.DefaultIfEmpty()
                    join p in _dbContext.CrmProduct.Where(a => a.TenantId == request.TenantId || a.TenantId == -1 && a.IsDeleted == 0) on a.ProductId equals p.ProductId into all3
                    from pp in all3.DefaultIfEmpty()
                    select new GetOpportunityVm
                    {
                        OpportunityId = a.OpportunityId,
                        FirstName = a.FirstName,
                        LastName = a.LastName,
                        Email = a.Email,
                        StatusId = a.StatusId,
                        StatusTitle = s.StatusTitle,
                        OpportunityOwner = a.OpportunityOwner,
                        Mobile = a.Mobile,
                        Work = a.Work,
                        Address = a.Address,
                        Street = a.Street,
                        City = a.City,
                        Zip = a.Zip,
                        State = a.State,
                        Country = a.Country,
                        SourceId = a.SourceId,
                        SourceTitle = zz.SourceTitle,
                        IndustryId = (int)a.IndustryId,
                        IndustryTitle = ii.IndustryTitle,
                        ProductId = (int)a.ProductId,
                        ProductTitle = pp.ProductName,
                        CreatedDate = a.CreatedDate,
                        ModifiedDate = a.LastModifiedDate,
                    }
                    ).OrderByDescending(a => a.OpportunityId).ToListAsync();

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
                    from a in _dbContext.CrmLeadSource.Where(a => a.IsDeleted == 0)
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
        public async Task<List<GetOpportunityStatusVm>> GetOpportunityStatus(GetOpportunityStatusQuery request)
        {
            try
            {
                List<GetOpportunityStatusVm> OpportunityStatus = await (from a in _dbContext.CrmOpportunityStatus.Where(a => a.TenantId == -1 || a.TenantId == request.TenantId && a.IsDeleted == 0)
                                                                        select new GetOpportunityStatusVm
                                                                        {
                                                                            StatusId = a.StatusId,
                                                                            StatusTitle = a.StatusTitle,
                                                                            IsDeletable = a.IsDeletable,
                                                                            Order = a.Order,
                                                                        }
                                           ).ToListAsync();
                return OpportunityStatus;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }
        public async Task SaveOpportunity(SaveOpportunityCommand Opportunity)
        {
            try
            {
                DateTime localDateTime = DateTime.Now;
                if (Opportunity.dto.OpportunityId == -1)
                {
                    CrmOpportunity OpportunityObj = new CrmOpportunity();
                    OpportunityObj.FirstName = Opportunity.dto.FirstName;
                    OpportunityObj.LastName = Opportunity.dto.LastName;
                    OpportunityObj.Email = Opportunity.dto.Email;
                    OpportunityObj.StatusId = Opportunity.dto.StatusId;
                    OpportunityObj.OpportunityOwner = Opportunity.dto.OpportunityOwner;
                    OpportunityObj.Mobile = Opportunity.dto.Mobile;
                    OpportunityObj.Work = Opportunity.dto.Work;
                    OpportunityObj.Address = Opportunity.dto.Address;
                    OpportunityObj.Street = Opportunity.dto.Street;
                    OpportunityObj.City = Opportunity.dto.City;
                    OpportunityObj.Zip = Opportunity.dto.Zip;
                    OpportunityObj.State = Opportunity.dto.State;
                    OpportunityObj.Country = Opportunity.dto.Country;
                    OpportunityObj.SourceId = Opportunity.dto.SourceId;
                    OpportunityObj.IndustryId = Opportunity.dto.IndustryId;
                    OpportunityObj.ProductId = Opportunity.dto.ProductId;
                    OpportunityObj.CreatedBy = Opportunity.Id;
                    OpportunityObj.CreatedDate = localDateTime.ToUniversalTime();
                    OpportunityObj.IsDeleted = 0;
                    OpportunityObj.TenantId = Opportunity.TenantId;
                    await _dbContext.AddAsync(OpportunityObj);
                    await _dbContext.SaveChangesAsync();

                }
                else
                {
                    CrmOpportunity? OpportunityObj = await (from a in _dbContext.CrmOpportunity.Where(a => a.OpportunityId == Opportunity.dto.OpportunityId)
                                                            select a).FirstAsync();
                    if (OpportunityObj == null)
                    {
                        throw new NotFoundException("Error in Save Opportunity: ", "Could not find specified");
                    }
                    else
                    {
                        OpportunityObj.FirstName = Opportunity.dto.FirstName;
                        OpportunityObj.LastName = Opportunity.dto.LastName;
                        OpportunityObj.Email = Opportunity.dto.Email;
                        OpportunityObj.StatusId = Opportunity.dto.StatusId;
                        OpportunityObj.OpportunityOwner = Opportunity.dto.OpportunityOwner;
                        OpportunityObj.Mobile = Opportunity.dto.Mobile;
                        OpportunityObj.Work = Opportunity.dto.Work;
                        OpportunityObj.Address = Opportunity.dto.Address;
                        OpportunityObj.Street = Opportunity.dto.Street;
                        OpportunityObj.City = Opportunity.dto.City;
                        OpportunityObj.Zip = Opportunity.dto.Zip;
                        OpportunityObj.State = Opportunity.dto.State;
                        OpportunityObj.Country = Opportunity.dto.Country;
                        OpportunityObj.SourceId = Opportunity.dto.SourceId;
                        OpportunityObj.IndustryId = Opportunity.dto.IndustryId;
                        OpportunityObj.ProductId = Opportunity.dto.ProductId;
                        OpportunityObj.LastModifiedBy = Opportunity.Id;
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
        public async Task DeleteOpportunity(DeleteOpportunityCommand command)
        {
            try
            {
                CrmOpportunity? Opportunity = await (from a in _dbContext.CrmOpportunity.Where(a => a.OpportunityId == command.OpportunityId)
                                                     select a).FirstOrDefaultAsync();

                if (Opportunity == null)
                {
                    throw new NotFoundException("Opportunity not found", " ");
                }
                else
                {
                    DateTime localDateTime = DateTime.Now;
                    Opportunity.DeletedBy = command.Id;
                    Opportunity.DeletedDate = localDateTime.ToUniversalTime();
                    Opportunity.IsDeleted = 1;
                    await _dbContext.SaveChangesAsync();
                }
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }
        public async Task RestoreOpportunity(RestoreOpportunityCommand query)
        {
            try
            {
                var deletedOpportunity = await (
                    from a in _dbContext.CrmOpportunity.Where(a => a.OpportunityId == query.OpportunityId)
                    select a).FirstOrDefaultAsync();
                if (deletedOpportunity == null)
                {
                    throw new NotFoundException("OpportunityId", query);
                }
                else
                {
                    deletedOpportunity.DeletedBy = query.Id;
                    deletedOpportunity.IsDeleted = 0;
                    await _dbContext.SaveChangesAsync();
                }
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }
        public async Task<List<GetDeletedOpportunityVm>> GetDeletedOpportunity(int TenantId, string Id)
        {
            try
            {
                List<GetDeletedOpportunityVm> detail = await (from a in _dbContext.CrmOpportunity.Where(a => a.TenantId == TenantId && a.IsDeleted == 1)
                                                        join user in _dbContext.AppUser on a.DeletedBy equals user.Id
                                                        select new GetDeletedOpportunityVm
                                                        {
                                                            Id = a.OpportunityId,
                                                            Title = a.FirstName + " " + a.LastName,
                                                            DeletedBy = user.FirstName + " " + user.LastName,
                                                            DeletedDate = a.DeletedDate,
                                                        }).OrderBy(a => a.Title).ToListAsync();
                return detail;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }
        public async Task RestoreBulkOpportunity(RestoreBulkOpportunityCommand command)
        {
            try
            {
                foreach (var opportunityId in command.OpportunityId)
                {
                    var opportunity = await _dbContext.CrmOpportunity
                        .Where(p => p.OpportunityId == opportunityId && p.IsDeleted == 1)
                        .FirstOrDefaultAsync();

                    if (opportunity == null)
                    {
                        throw new NotFoundException(nameof(opportunityId), opportunityId);
                    }

                    opportunity.IsDeleted = 0;
                }

                await _dbContext.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }
        public async Task<List<GetOpportunityAttachmentsVm>> GetOpportunityAttachments(GetOpportunityAttachmentsQuery query)
        {
            try
            {
                List<GetOpportunityAttachmentsVm> attachments = await (
                    from a in _dbContext.DocumentLibrary
                    .Where(a => a.TenantId == query.TenantId && a.IsDeleted == 0 && a.ContactTypeId == query.ContactTypeId && a.Id == query.OpportunityId)
                    select new GetOpportunityAttachmentsVm
                    {
                        FileId = a.FileId,
                        Size = a.Size,
                        Path = a.Path,
                        FileName = a.FileName,
                        Description = a.Description,
                        Type = a.Type
                    }).ToListAsync();
                return attachments;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }
        public async Task ChangeOpportunityStatus(ChangeOpportunityStatusCommand obj)
        {
            try
            {
                CrmOpportunity? Opportunity = await (from a in _dbContext.CrmOpportunity.Where(a => a.OpportunityId == obj.OpportunityId) select a).FirstOrDefaultAsync();
                if (Opportunity == null)
                {
                    throw new NotFoundException("", obj.OpportunityId);
                }
                else
                {
                    Opportunity.StatusId = obj.StatusId;
                    Opportunity.LastModifiedBy = obj.UserId;
                    Opportunity.LastModifiedDate = DateTime.Now.ToUniversalTime();
                    await _dbContext.SaveChangesAsync();
                }
                int typeId = (int)CrmEnum.ContactEnum.Opportunity;
                string statusTitle = "Status Changed to " + obj.StausTitle;
                string details = "Opportunity Status Changed to " + obj.StausTitle;
                var result = _dbContext.Database.ExecuteSqlRaw(
                    "CALL public.insertstatuslog({0}, {1}, {2}, {3}, {4}, {5}, {6})",
                     details, typeId, statusTitle, obj.UserId, obj.OpportunityId, obj.TenantId, obj.StatusId);

                await _dbContext.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
