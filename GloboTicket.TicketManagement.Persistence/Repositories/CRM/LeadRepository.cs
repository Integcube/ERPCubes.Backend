using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Lead.Commands.BulkSaveLead;
using ERPCubes.Application.Features.Crm.Lead.Commands.SaveLead;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadByMonth;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadList;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetleadPiplineReport;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadOwnerWiseReport;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadReport;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadSource;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadSourceWiseReport;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadStatus;
using ERPCubes.Domain.Entities;
using ERPCubes.Identity;
using Microsoft.EntityFrameworkCore;
using ERPCubes.Application.Features.Crm.Lead.Commands.ChangeLeadStatus;
using System;
using static System.Net.Mime.MediaTypeNames;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetStatusWiseLeads;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetDeletedLeads;
using ERPCubes.Application.Features.Crm.Lead.Commands.RestoreDeletedLeads;
using System.Collections.Generic;
using System.Xml.Linq;

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
                CrmLead? Lead = await (from a in _dbContext.CrmLead.Where(a => a.LeadId == LeadId)
                                       select a
                                           ).FirstOrDefaultAsync();
                if (Lead == null)
                {
                    throw new NotFoundException(Name, LeadId);
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
        public async Task<List<GetLeadVm>> GetAllLeads(int TenantId, string Id) 
        {
            try

            {

                List<GetLeadVm> Leads = await (from a in _dbContext.CrmLead.Where(a => a.TenantId == TenantId && a.IsDeleted == 0
                                               //&& (CreatedDate == null || a.CreatedDate >= CreatedDate) && (ModifiedDate == null || a.LastModifiedDate >= ModifiedDate) && ((OwnerIds.Count == 0) || OwnerIds.Contains(a.LeadOwner)) && ((StatusIds.Count == 0) || StatusIds.Contains((int)a.Status))
                                               )
                                               join s in _dbContext.CrmLeadStatus.Where(a => a.TenantId == TenantId || a.TenantId == -1 && a.IsDeleted == 0) on a.Status equals s.StatusId
                                               join i in _dbContext.CrmIndustry.Where(a => a.TenantId == TenantId || a.TenantId == -1 && a.IsDeleted == 0) on a.IndustryId equals i.IndustryId into all
                                               from ii in all.DefaultIfEmpty()
                                               join z in _dbContext.CrmLeadSource.Where(a => a.TenantId == TenantId || a.TenantId == -1 && a.IsDeleted == 0) on a.SourceId equals z.SourceId into all2
                                               from zz in all2.DefaultIfEmpty()
                                               join p in _dbContext.CrmProduct.Where(a => a.TenantId == TenantId || a.TenantId == -1 && a.IsDeleted == 0) on a.ProductId equals p.ProductId into all3
                                               from pp in all3.DefaultIfEmpty()
                                               join c in _dbContext.CrmCampaign.Where(a => a.TenantId == TenantId || a.TenantId == -1 && a.IsDeleted == 0) on a.CampaignId equals c.CampaignId into all4
                                               from cc in all4.DefaultIfEmpty()
                                               join user in _dbContext.AppUser on a.LeadOwner equals user.Id
                                              
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
                                                   CampaignId = a.CampaignId,
                                                   CampaignTitle = cc.Title,
                                                   CreatedDate = a.CreatedDate,
                                                   ModifiedDate = a.LastModifiedDate,
                                                   LeadOwnerName= user.FirstName+" "+ user.LastName
                                               }
                                              ).OrderByDescending(a => a.LeadId).ToListAsync();
                return Leads;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }
        //public async Task<List<GetDeletedLeadsVm>> GetDeletedLeads(int TenantId, string Id)
        //    {
        //    try
        //    {
        //        List<GetDeletedLeadsVm> dLeads = await (
        //            from a in _dbContext.CrmLead.Where(a => a.TenantId == TenantId && a.IsDeleted == 1)
        //            join s in _dbContext.CrmLeadStatus.Where(a => a.TenantId == TenantId || a.TenantId == -1 && a.IsDeleted == 0) on a.Status equals s.StatusId
        //            join p in _dbContext.CrmProduct.Where(a => a.TenantId == TenantId || a.TenantId == -1 && a.IsDeleted == 0) on a.ProductId equals p.ProductId into all3
        //            from pp in all3.DefaultIfEmpty()
        //            join c in _dbContext.CrmCampaign.Where(a => a.TenantId == TenantId || a.TenantId == -1 && a.IsDeleted == 0) on a.CampaignId equals c.CampaignId into all4
        //            from cc in all4.DefaultIfEmpty()
        //            join user in _dbContext.AppUser on a.LeadOwner equals user.Id
        //            select new GetDeletedLeadsVm
        //            {
        //                LeadId = a.LeadId,
        //                Name = a.FirstName + " " + a.LastName,
        //                Status = a.Status,
        //                StatusTitle = s.StatusTitle,
        //                LeadOwner = a.LeadOwner,
        //                LeadOwnerName = user.FirstName + " " + user.LastName,
        //                ProductId = pp.ProductId == null?-1 : pp.ProductId,
        //                ProductTitle = pp.ProductName,
        //                CampaignId = cc.CampaignId,
        //                CampaignTitle = cc.Title,
        //                CreatedDate = a.CreatedDate
        //            }).OrderByDescending(a => a.LeadId).ToListAsync();

        //        return dLeads;

        //    }
        //    catch (Exception ex)
        //    {
        //        throw new BadRequestException(ex.Message);
        //    }
            
        //}
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

        public async Task<List<GetLeadByMonthListVm>> GetLeadByMonth(int TenantId, string Id, int ProductId, int SourceId, string UserId, string Year)
        {
            try
            {
                int.TryParse(Year, out int year);
                DateTime localStartDateTime = new DateTime(year, 1,1,0,0,0,DateTimeKind.Utc);
                DateTime localEndDateTime = new DateTime(year, 12, 31, 23, 59, 59, DateTimeKind.Utc);
                var groupedLeads = await (
                    from a in _dbContext.CrmLead.Where(lead => (ProductId == -1 || lead.ProductId == ProductId) && (SourceId == -1 || lead.SourceId == SourceId) && (UserId == "-1" || lead.LeadOwner == UserId) && (lead.CreatedDate > localStartDateTime) && (lead.CreatedDate < localEndDateTime))
                    where (a.TenantId == -1 || a.TenantId == TenantId) && a.IsDeleted == 0
                    group a by new { a.CreatedDate.Month } into g
                    select new GetLeadByMonthListVm
                    {
                        Year = year,
                        Month = g.Key.Month,
                        TotalLeads = g.Count(),
                        LeadStatusList = new List<GetLeadStatusListVm>() // Initialize an empty list
                    }
                ).ToListAsync();

                foreach (var leadByMonth in groupedLeads)
                {
                    leadByMonth.LeadStatusList = await (
                        from l in _dbContext.CrmLeadStatus
                        where l.TenantId == -1 || l.TenantId == TenantId && l.IsDeleted == 0
                        select new GetLeadStatusListVm
                        {
                            StatusId = l.StatusId,
                            StatusTitle = l.StatusTitle,
                            IsDeletable = l.IsDeletable,
                            Order = l.Order,
                            Count = _dbContext.CrmLead.Count(lead => lead.Status == l.StatusId && lead.CreatedDate.Month == leadByMonth.Month && (ProductId == -1 || lead.ProductId == ProductId) && (SourceId == -1 || lead.SourceId == SourceId) && (UserId == "-1" || lead.LeadOwner == UserId) && (lead.CreatedDate > localStartDateTime) && (lead.CreatedDate < localEndDateTime))
                        }
                    ).ToListAsync();
                }

                return groupedLeads;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }

        }

        public async Task<List<GetLeadOwnerWiseVm>> GetLeadOwnerWise(int TenantId, string Id, DateTime startDate, DateTime endDate, string leadOwner, int sourceId, int status)
        {
            try
            {
                var tenantIdPrm = new Npgsql.NpgsqlParameter("@p_tenantid", NpgsqlTypes.NpgsqlDbType.Integer)
                {
                    Value = TenantId
                };
                var startDatePrm = new Npgsql.NpgsqlParameter("@p_startdate", NpgsqlTypes.NpgsqlDbType.Date)
                {
                    Value = startDate
                };
                var endDatePrm = new Npgsql.NpgsqlParameter("@p_enddate", NpgsqlTypes.NpgsqlDbType.Date)
                {
                    Value = endDate
                };
                var leadOwnerPrm = new Npgsql.NpgsqlParameter("@p_leadowner", NpgsqlTypes.NpgsqlDbType.Varchar)
                {
                    Value = leadOwner
                };
                var sourceIdPrm = new Npgsql.NpgsqlParameter("@p_sourceid", NpgsqlTypes.NpgsqlDbType.Integer)
                {
                    Value = sourceId
                };
                var statusPrm = new Npgsql.NpgsqlParameter("@p_status", NpgsqlTypes.NpgsqlDbType.Integer)
                {
                    Value = status
                };
                var results = await _dbContext.GetCrmLeadOwnerWise.FromSqlRaw(
                    "SELECT * FROM public.crmleadownerwiserpt({0},{1},{2},{3},{4},{5})", tenantIdPrm, sourceIdPrm, leadOwnerPrm, statusPrm, startDatePrm, endDatePrm)
                    .ToListAsync();

                return results;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task<List<GetLeadReportVm>> GetLeadReport(int TenantId, string Id, DateTime startDate, DateTime endDate, int prodId)
        {
            try
            {
                var tenantIdPrm = new Npgsql.NpgsqlParameter("@p_tenantid", NpgsqlTypes.NpgsqlDbType.Integer)
                {
                    Value = TenantId
                };
                var startDatePrm = new Npgsql.NpgsqlParameter("@p_startdate", NpgsqlTypes.NpgsqlDbType.Date)
                {
                    Value = startDate
                };
                var endDatePrm = new Npgsql.NpgsqlParameter("@p_enddate", NpgsqlTypes.NpgsqlDbType.Date)
                {
                    Value = endDate
                };
                var prodIdPrm = new Npgsql.NpgsqlParameter("@p_productid", NpgsqlTypes.NpgsqlDbType.Integer)
                {
                    Value = prodId
                };
                var results = await _dbContext.GetCrmLeads.FromSqlRaw(
                    "SELECT * FROM public.leadownerstatuswise({0},{1},{2},{3})", tenantIdPrm, startDatePrm, endDatePrm, prodIdPrm)
                    .ToListAsync();

                return results;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task<List<GetLeadSourceWiseVm>> GetLeadSourceWise(int TenantId, string Id, DateTime startDate, DateTime endDate, int sourceId)
        {
            try
            {
                var tenantIdPrm = new Npgsql.NpgsqlParameter("@p_tenantid", NpgsqlTypes.NpgsqlDbType.Integer)
                {
                    Value = TenantId
                };
                var startDatePrm = new Npgsql.NpgsqlParameter("@p_startdate", NpgsqlTypes.NpgsqlDbType.Date)
                {
                    Value = startDate
                };
                var endDatePrm = new Npgsql.NpgsqlParameter("@p_enddate", NpgsqlTypes.NpgsqlDbType.Date)
                {
                    Value = endDate
                };
                var sourceIdPrm = new Npgsql.NpgsqlParameter("@p_sourceid", NpgsqlTypes.NpgsqlDbType.Integer)
                {
                    Value = sourceId
                };
                var results = await _dbContext.GetCrmLeadSourceWise.FromSqlRaw(
                    "SELECT * FROM public.crmleadsourcewiserpt({0},{1},{2},{3})", tenantIdPrm, sourceIdPrm, startDatePrm, endDatePrm)
                    .ToListAsync();

                return results;
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
                        throw new NotFoundException(Lead.FirstName + " " + Lead.LastName, Lead.LeadId);
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
                        LeadObj.CampaignId = Lead.CampaignId;
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
                    LeadObj.CampaignId = Lead.CampaignId;
                    LeadObj.CreatedBy = Id;
                    LeadObj.CreatedDate = localDateTime.ToUniversalTime();
                    LeadObj.IsDeleted = 0;
                    LeadObj.TenantId = TenantId;
                    await _dbContext.AddAsync(LeadObj);
                    await _dbContext.SaveChangesAsync();

                }
            }
            catch (Exception e)
            {
                throw new BadRequestException(e.Message);
            }
        }

        public async Task SaveLeadBulk(SaveBulkLeadCommand request)
        {
            try
            {
                DateTime localDateTime = DateTime.Now;
                foreach (var Lead in request.Lead)
                {
                    CrmLead LeadObj = new CrmLead();
                    LeadObj.FirstName = Lead.FirstName;
                    LeadObj.LastName = Lead.LastName;
                    LeadObj.Email = Lead.Email;
                    LeadObj.Status = 1;
                    LeadObj.LeadOwner = request.Id;
                    LeadObj.City = Lead.City;
                    LeadObj.Address = Lead.Address;
                    LeadObj.Country = Lead.Country;
                    LeadObj.Street = Lead.Street;
                    LeadObj.Zip = Lead.Zip;
                    LeadObj.ProductId = Lead.ProductId;
                    LeadObj.CreatedBy = request.Id;
                    LeadObj.CreatedDate = localDateTime.ToUniversalTime();
                    LeadObj.IsDeleted = 0;
                    LeadObj.TenantId = request.TenantId;
                    await _dbContext.AddAsync(LeadObj);
                    await _dbContext.SaveChangesAsync();
                }


            }
            catch (Exception e)
            {
                throw new BadRequestException(e.Message);
            }
        }

        //public async Task RestoreDeletedLeads(RestoreDeletedLeadsCommand request)
        //{
        //    try
        //    {
        //        DateTime localDateTime = DateTime.Now;
        //        foreach (var Lead in request.deletedleads)
        //        {
        //            var deletedLead = await (
        //                from a in _dbContext.CrmLead.Where(lead => lead.TenantId == request.TenantId && lead.IsDeleted == 1 && lead.LeadId == Lead.LeadId) select a)?.FirstOrDefaultAsync();
        //            if (deletedLead == null)
        //            {
        //                throw new NotFoundException(request.Id, Lead.LeadId);
        //            }
        //            else
        //            {
        //                deletedLead.IsDeleted = 0;
        //                deletedLead.LastModifiedBy = request.Id;
        //                deletedLead.LastModifiedDate = localDateTime.ToUniversalTime();
        //                await _dbContext.SaveChangesAsync();
        //            }
        //        }

        //    }
        //    catch (Exception e)
        //    {
        //        throw new BadRequestException(e.Message);
        //    }
        //}

        public async Task<List<GetleadPiplineReportVm>> GetleadPiplineReport(GetleadPiplineReportQuery obj)
        {
            try
            {
                var tenantIdPrm = new Npgsql.NpgsqlParameter("@TenantId", NpgsqlTypes.NpgsqlDbType.Integer)
                {
                    Value = obj.TenantId
                };
                var SourceIdPrm = new Npgsql.NpgsqlParameter("@p_SourceId", NpgsqlTypes.NpgsqlDbType.Integer)
                {
                    Value = obj.SourceId
                };
                var Status = new Npgsql.NpgsqlParameter("@Status", NpgsqlTypes.NpgsqlDbType.Integer)
                {
                    Value = obj.Status
                };

                var startDatePrm = new Npgsql.NpgsqlParameter("@SourceId", NpgsqlTypes.NpgsqlDbType.Date)
                {
                    Value = obj.StartDate
                };
                var endDatePrm = new Npgsql.NpgsqlParameter("@EndDate", NpgsqlTypes.NpgsqlDbType.Date)
                {
                    Value = obj.EndDate
                };
                var ProductId = new Npgsql.NpgsqlParameter("@ProductId", NpgsqlTypes.NpgsqlDbType.Integer)
                {
                    Value = obj.ProductId
                };
                
                var results = await _dbContext.GetleadPiplineReportVm.FromSqlRaw(
                    "SELECT * FROM public.crmleadstagewiserpt({0},{1},{2},{3},{4},{5})", tenantIdPrm, SourceIdPrm, Status, startDatePrm,endDatePrm, ProductId)
                    .ToListAsync();

                return results;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task ChangeLeadStatus(ChangeLeadStatusCommand obj)
        {
            try
            {
                CrmLead? Lead = await (from a in _dbContext.CrmLead.Where(a => a.LeadId == obj.LeadId) select a).FirstOrDefaultAsync();
                if (Lead == null)
                {
                    throw new NotFoundException("", obj.LeadId);
                }
                else
                {
                    Lead.Status= obj.statusId;
                    Lead.LastModifiedBy = obj.userId;
                    Lead.LastModifiedDate = DateTime.Now.ToUniversalTime();
                    await _dbContext.SaveChangesAsync();
                }
                int typeId = (int)CrmEnum.ContactEnum.Lead;
                string statusTitle = "Status Changed to " + obj.StausTitle;
                string details = "Lead Status Changed to " + obj.StausTitle;
                var result = _dbContext.Database.ExecuteSqlRaw(
                    "CALL public.insertstatuslog({0}, {1}, {2}, {3}, {4}, {5}, {6})",
                     details, typeId, statusTitle, obj.userId, obj.LeadId, obj.TenantId, obj.statusId);

                await _dbContext.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task<List<GetStatusWiseLeadsVm>> GetStatusWiseLeads(GetStatusWiseLeadsQuery request)
        {
            try
            {
                List<GetStatusWiseLeadsVm> leadsWithStatus = await (from a in _dbContext.CrmLeadStatus.Where(a => a.IsDeleted == 0)
                                                                    select new GetStatusWiseLeadsVm
                                                                    {
                                                                        StatusId = a.StatusId,
                                                                        StatusTitle = a.StatusTitle,
                                                                        Order = a.Order,
                                                                        Leads = (from b in _dbContext.CrmLead.Where(b => b.IsDeleted == 0 && b.Status == a.StatusId && a.TenantId == request.TenantId)
                                                                                 select new GetStatusWiseLeadsDto
                                                                                 {
                                                                                     LeadId = b.LeadId,
                                                                                     LeadOwner = b.LeadOwner,
                                                                                     FirstName = b.FirstName,
                                                                                     LastName = b.LastName,
                                                                                     Email = b.Email,
                                                                                     Status = b.Status,
                                                                                     Mobile = b.Mobile,
                                                                                 }).OrderByDescending(a=>a.LeadId).ToList()
                                                                    }).ToListAsync();
                return leadsWithStatus;

            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public Task RestoreDeletedLeads(RestoreDeletedLeadsCommand request)
        {
            throw new NotImplementedException();
        }

        public Task<List<GetDeletedLeadsVm>> GetDeletedLeads(int TenantId, string Id)
        {
            throw new NotImplementedException();
        }
    }
}
