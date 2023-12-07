using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Lead.Commands.SaveLead;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadList;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadSource;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadStatus;
using ERPCubes.Domain.Entities;
using ERPCubes.Identity;
using Microsoft.EntityFrameworkCore;

namespace ERPCubes.Persistence.Repositories.CRM
{
    public class LeadRepository : BaseRepository<CrmLead>, IAsyncLeadRepository
    {
        public LeadRepository(ERPCubesDbContext dbContext, ERPCubesIdentityDbContext dbContextIdentity) : base(dbContext, dbContextIdentity)
        {
        }

        public async Task DeleteLead(string Id, int TenantId, int LeadId, string Name)
        {
            try
            {
                CrmLead? Lead = await(from a in _dbContext.CrmLead.Where(a => a.LeadId == LeadId)
                                                             select a
                                           ).FirstOrDefaultAsync();
                if (Lead == null)
                {
                    throw new NotFoundException(Name,LeadId);
                }
                else
                {
                    Lead.IsDeleted = 1;
                    await _dbContext.SaveChangesAsync();
                }
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task<List<GetLeadVm>> GetAllLeads(int TenantId, string Id, DateTime? CreatedDate, DateTime? ModifiedDate, string? LeadOwner, string? LeadStatus)
        {
            try
            
            {
                List<int> StatusIds = new List<int>();
                if (!string.IsNullOrEmpty(LeadStatus))
                    StatusIds = (LeadStatus.Split(',').Select(Int32.Parse).ToList());
                List<string> OwnerIds = new List<string>();
                if (!string.IsNullOrEmpty(LeadOwner))
                {
                    OwnerIds = LeadOwner.Split(',')
                                        .Select(owner => owner.Trim())
                                        .ToList();
                }
                List<GetLeadVm> Leads = await (from a in _dbContext.CrmLead.Where(a => a.TenantId == TenantId && a.IsDeleted == 0 && (CreatedDate == null || a.CreatedDate>=CreatedDate) && (ModifiedDate == null || a.LastModifiedDate >= ModifiedDate) && ((OwnerIds.Count == 0) || OwnerIds.Contains(a.LeadOwner)) && ((StatusIds.Count == 0) || StatusIds.Contains((int)a.Status)))
                                               join s in _dbContext.CrmLeadStatus.Where(a => a.TenantId == TenantId || a.TenantId == -1 && a.IsDeleted == 0) on a.Status equals s.StatusId
                                               join i in _dbContext.CrmIndustry.Where(a => a.TenantId == TenantId || a.TenantId == -1 && a.IsDeleted == 0) on a.IndustryId equals i.IndustryId into all
                                               from ii in all.DefaultIfEmpty()
                                               join z in _dbContext.CrmLeadSource.Where(a => a.TenantId == TenantId || a.TenantId == -1 && a.IsDeleted == 0) on a.SourceId equals z.SourceId into all2
                                               from zz in all2.DefaultIfEmpty()
                                               join p in _dbContext.CrmProduct.Where(a => a.TenantId == TenantId || a.TenantId == -1 && a.IsDeleted == 0) on a.ProductId equals p.ProductId into all3
                                               from pp in all3.DefaultIfEmpty()
                                               select new GetLeadVm
                                               {
                                                   LeadId = a.LeadId,
                                                   FirstName = a.FirstName,
                                                   LastName = a.LastName,
                                                   Email = a.Email,
                                                   Status = a.Status,
                                                   StatusTitle = s.StatusTitle,
                                                   LeadOwner = a.LeadOwner,
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
                                                   IndustryId = a.IndustryId,
                                                   IndustryTitle = ii.IndustryTitle,
                                                   ProductId = a.ProductId,
                                                   ProductTitle = pp.ProductName,
                                                   CreatedDate = a.CreatedDate,
                                                   ModifiedDate = a.LastModifiedDate,
                                               }
                                              ).OrderByDescending(a => a.LeadId).ToListAsync();
                return Leads;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task<List<GetLeadSourceListVm>> GetAllLeadSource(int TenantId, string Id)
        {
            try
            {
                List<GetLeadSourceListVm> LeadStatus = await (from a in _dbContext.CrmLeadSource.Where(a => a.TenantId == -1 || a.TenantId == TenantId && a.IsDeleted == 0)
                                                             select new GetLeadSourceListVm
                                                             {
                                                                 SourceId = a.SourceId,
                                                                 SourceTitle = a.SourceTitle
                                                             }
                                           ).ToListAsync();
                return LeadStatus;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task<List<GetLeadStatusListVm>> GetAllLeadStatus(int TenantId, string Id)
        {
            try
            {
                List<GetLeadStatusListVm> LeadStatus = await (from a in _dbContext.CrmLeadStatus.Where(a => a.TenantId == -1 || a.TenantId == TenantId && a.IsDeleted == 0)
                                                              select new GetLeadStatusListVm
                                                              {
                                                                  StatusId = a.StatusId,
                                                                  StatusTitle = a.StatusTitle,
                                                                  IsDeletable = a.IsDeletable,
                                                                  Order = a.Order,
                                                              }
                                           ).ToListAsync();
                return LeadStatus;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task SaveLead(string Id, int TenantId, SaveLeadDto Lead)
        {
            try
            {
                DateTime localDateTime = DateTime.Now;
                if (Lead.LeadId != -1)
                {
                    CrmLead? LeadObj = await (from a in _dbContext.CrmLead.Where(a => a.LeadId == Lead.LeadId)
                                             select a).FirstAsync();
                    if (LeadObj == null)
                    {
                        throw new NotFoundException(Lead.FirstName+" "+Lead.LastName, Lead.LeadId);
                    }
                    else
                    {
                        LeadObj.FirstName = Lead.FirstName;
                        LeadObj.LastName = Lead.LastName;
                        LeadObj.Email = Lead.Email;
                        LeadObj.Status = Lead.Status;
                        LeadObj.LeadOwner = Lead.LeadOwner;
                        LeadObj.Mobile = Lead.Mobile;
                        LeadObj.Work = Lead.Work;
                        LeadObj.Address = Lead.Address;
                        LeadObj.Street = Lead.Street;
                        LeadObj.City = Lead.City;
                        LeadObj.Zip = Lead.Zip;
                        LeadObj.State = Lead.State;
                        LeadObj.Country = Lead.Country;
                        LeadObj.SourceId = Lead.SourceId;
                        LeadObj.IndustryId = Lead.IndustryId;
                        LeadObj.ProductId = Lead.ProductId;
                        LeadObj.LastModifiedBy = Id;
                        LeadObj.LastModifiedDate = localDateTime.ToUniversalTime();
                        await _dbContext.SaveChangesAsync();
                    }

                }
                else
                {
                    CrmLead LeadObj = new CrmLead();
                    LeadObj.FirstName = Lead.FirstName;
                    LeadObj.LastName = Lead.LastName;
                    LeadObj.Email = Lead.Email;
                    LeadObj.Status = Lead.Status;
                    LeadObj.LeadOwner = Lead.LeadOwner;
                    LeadObj.Mobile = Lead.Mobile;
                    LeadObj.Work = Lead.Work;
                    LeadObj.Address = Lead.Address;
                    LeadObj.Street = Lead.Street;
                    LeadObj.City = Lead.City;
                    LeadObj.Zip = Lead.Zip;
                    LeadObj.State = Lead.State;
                    LeadObj.Country = Lead.Country;
                    LeadObj.SourceId = Lead.SourceId;
                    LeadObj.IndustryId = Lead.IndustryId;
                    LeadObj.ProductId = Lead.ProductId;
                    LeadObj.CreatedBy = Id;
                    LeadObj.CreatedDate = localDateTime.ToUniversalTime();
                    LeadObj.IsDeleted = 0;
                    LeadObj.TenantId = TenantId;
                    await _dbContext.AddAsync(LeadObj);
                    await _dbContext.SaveChangesAsync();

                    CrmCalenderEvents CalenderObj = new CrmCalenderEvents();
                    CalenderObj.UserId = LeadObj.LeadOwner;
                    CalenderObj.Description = "You are tasked to call " + LeadObj.FirstName + " " + LeadObj.LastName;
                    CalenderObj.Type = 6;
                    CalenderObj.CreatedBy = LeadObj.CreatedBy;
                    CalenderObj.CreatedDate = LeadObj.CreatedDate;
                    CalenderObj.StartTime = localDateTime.ToUniversalTime().AddDays(3);
                    CalenderObj.EndTime = localDateTime.ToUniversalTime().AddDays(3);
                    CalenderObj.TenantId = TenantId;
                    CalenderObj.Id = LeadObj.LeadId;
                    CalenderObj.IsCompany = -1;
                    CalenderObj.IsLead = 1;
                    CalenderObj.AllDay = false;
                    await _dbContext.CrmCalenderEvents.AddAsync(CalenderObj);
                    await _dbContext.SaveChangesAsync();

                    CrmUserActivityLog ActivityObj = new CrmUserActivityLog();
                    ActivityObj.UserId = LeadObj.LeadOwner;
                    ActivityObj.Detail = "You are tasked to call" + LeadObj.FirstName + " " + LeadObj.LastName;
                    ActivityObj.ActivityType = 1;
                    ActivityObj.ActivityStatus = 1;
                    ActivityObj.TenantId = LeadObj.TenantId;
                    ActivityObj.Id = LeadObj.LeadId;
                    ActivityObj.IsCompany = -1;
                    ActivityObj.IsLead = 1;
                    ActivityObj.CreatedBy = LeadObj.CreatedBy;
                    ActivityObj.CreatedDate = LeadObj.CreatedDate;
                    await _dbContext.CrmUserActivityLog.AddAsync(ActivityObj);
                    await _dbContext.SaveChangesAsync();
                }
            }
            catch (Exception e)
            {
                throw new BadRequestException(e.Message);
            }
        }
    }
}
