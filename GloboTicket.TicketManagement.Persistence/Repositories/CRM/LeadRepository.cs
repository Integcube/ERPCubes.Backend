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
using ERPCubes.Application.Features.Crm.Lead.Queries.GetScoreListQuery;
using MediatR;
using ERPCubes.Application.Features.Crm.Lead.Commands.SaveLeadScore;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetCalculateleadScore;
using System.Linq;
using ERPCubes.Application.Features.Crm.Product.Queries.GetDeletedProductList;
using ERPCubes.Application.Features.Crm.Lead.Commands.BulkRestoreLeads;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory.Database;
using ERPCubes.Application.Features.Crm.Lead.Commands.DeleteLead;
using ERPCubes.Application.Features.Crm.Lead.Commands.SaveLeadScoreQuestion;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadScoreQuestions;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadAttachments;
using ERPCubes.Application.Features.Crm.Lead.Commands.SaveCopyQuestion;
using System.Net.NetworkInformation;
using System.Globalization;

namespace ERPCubes.Persistence.Repositories.CRM
{
    public class LeadRepository : BaseRepository<CrmLead>, IAsyncLeadRepository
    {
        public LeadRepository(ERPCubesDbContext dbContext, ERPCubesIdentityDbContext dbContextIdentity) : base(dbContext, dbContextIdentity)
        {
        }

        public async Task DeleteLead(DeleteLeadCommand leadId)
        {
            try
            {
                DateTime localDateTime = DateTime.Now;
                var deleteLead = await (from a in _dbContext.CrmLead.Where(a => a.LeadId == leadId.LeadId)
                                        select a).FirstOrDefaultAsync();
                if (deleteLead == null)
                {
                    throw new NotFoundException("leadId", leadId);
                }


                else
                {
                    deleteLead.DeletedBy = leadId.Id;
                    deleteLead.DeletedDate = localDateTime.ToUniversalTime();
                    deleteLead.IsDeleted = 1;
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

                List<GetLeadVm> Leads = await (
    from a in _dbContext.CrmLead
        .Where(a => a.TenantId == TenantId && a.IsDeleted == 0)
    join s in _dbContext.CrmLeadStatus
        .Where(a => a.TenantId == TenantId || a.TenantId == -1 && a.IsDeleted == 0)
        on a.Status equals s.StatusId
    join i in _dbContext.CrmIndustry
        .Where(a => a.TenantId == TenantId || a.TenantId == -1 && a.IsDeleted == 0)
        on a.IndustryId equals i.IndustryId into all
    from ii in all.DefaultIfEmpty()
    join z in _dbContext.CrmLeadSource
        .Where(a => a.TenantId == TenantId || a.TenantId == -1 && a.IsDeleted == 0)
        on a.SourceId equals z.SourceId into all2
    from zz in all2.DefaultIfEmpty()
    join p in _dbContext.CrmProduct
        .Where(a => a.TenantId == TenantId || a.TenantId == -1 && a.IsDeleted == 0)
        on a.ProductId equals p.ProductId into all3
    from pp in all3.DefaultIfEmpty()
    join c in _dbContext.CrmCampaign
        .Where(a => a.TenantId == TenantId || a.TenantId == -1 && a.IsDeleted == 0)
        on a.CampaignId equals c.CampaignId into all4
    from cc in all4.DefaultIfEmpty()
    join user in _dbContext.AppUser on a.LeadOwner equals user.Id into userss
    from us in userss.DefaultIfEmpty()
    join scro in _dbContext.CrmLeadScore on a.LeadId equals scro.LeadId into absc
    from sc in absc.DefaultIfEmpty()
    join ques in _dbContext.CrmIScoringQuestion on sc.QuestionId equals ques.QuestionId into QUS
    from question in QUS.DefaultIfEmpty()
    orderby a.LeadId descending
    group new { a, s, ii, zz, pp, cc, us, sc, question } by a.LeadId into grouped
    select new GetLeadVm
    {
        LeadId = grouped.Key,
        FirstName = grouped.First().a.FirstName,
        LastName = grouped.First().a.LastName,
        Email = grouped.First().a.Email,
        Status = grouped.First().a.Status,
        StatusTitle = grouped.First().s.StatusTitle,
        LeadOwner = grouped.First().a.LeadOwner,
        Mobile = grouped.First().a.Mobile,
        Work = grouped.First().a.Work,
        Address = grouped.First().a.Address,
        Street = grouped.First().a.Street,
        City = grouped.First().a.City,
        Zip = grouped.First().a.Zip,
        State = grouped.First().a.State,
        Country = grouped.First().a.Country,
        SourceId = grouped.First().a.SourceId,
        SourceTitle = grouped.First().zz.SourceTitle,
        IndustryId = grouped.First().a.IndustryId,
        IndustryTitle = grouped.First().ii.IndustryTitle,
        ProductId = grouped.First().a.ProductId,
        ProductTitle = grouped.First().pp.ProductName,
        CampaignId = grouped.First().a.CampaignId,
        CampaignTitle = grouped.First().cc.Title,
        CreatedDate = grouped.First().a.CreatedDate,
        ModifiedDate = grouped.First().a.LastModifiedDate,
        LeadOwnerName = grouped.First().us.FirstName + " " + grouped.First().us.LastName,
        Rating = grouped.Sum(ls => ls.sc.Rating * ls.question.Weightage) / (grouped.Sum(ls => ls.question.Weightage) == 0 ? 1 : grouped.Sum(ls => ls.question.Weightage)),
        Remarks= grouped.First().a.Remarks
    }
).ToListAsync();
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

        public async Task<List<GetLeadByMonthListVm>> GetLeadByMonth(int TenantId, string Id, int ProductId, int SourceId, string UserId, string Year)
        {
            try
            {
                int year = Convert.ToInt32(Year);
                var tenantIdPrm = new Npgsql.NpgsqlParameter("@p_tenantid", NpgsqlTypes.NpgsqlDbType.Integer)
                {
                    Value = TenantId
                };
                var productidPrm = new Npgsql.NpgsqlParameter("@p_productid", NpgsqlTypes.NpgsqlDbType.Integer)
                {
                    Value = ProductId
                };
                var p_sourceIdPrm = new Npgsql.NpgsqlParameter("@p_sourceId", NpgsqlTypes.NpgsqlDbType.Integer)
                {
                    Value = SourceId
                };
                var p_userIdPrm = new Npgsql.NpgsqlParameter("@p_userId", NpgsqlTypes.NpgsqlDbType.Varchar)
                {
                    Value = UserId
                };
                var p_yearPrm = new Npgsql.NpgsqlParameter("@p_year", NpgsqlTypes.NpgsqlDbType.Integer)
                {
                    Value = year
                };
       
                var results = await _dbContext.GetLeadByMonthListVm.FromSqlRaw(
                    "SELECT * FROM public.\"CRMLeadMonthlyStatusWise\" ({0},{1},{2},{3},{4})", tenantIdPrm, productidPrm, p_sourceIdPrm, p_userIdPrm, p_yearPrm)
                    .ToListAsync();




                var MonthTotal = results.GroupBy(a => new { a.Month}).Select(s => new GetLeadByMonthListVm
                {
                    Month= s.FirstOrDefault().Month,
                    LeadStatusTitle="Total Leads",
                    LeadStatusId = 99999,
                    Count = s.Sum(rr => rr.Count)
                }).ToList();
           
                results.AddRange(MonthTotal);


                var YearTotal = results.GroupBy(a => new { a.LeadStatusId }).Select(s => new GetLeadByMonthListVm
                {
                    Month = 99999,
                    MonthName = "Total",
                    LeadStatusTitle = s.FirstOrDefault().LeadStatusTitle,
                    LeadStatusId = s.FirstOrDefault().LeadStatusId,
                    Count = s.Sum(rr => rr.Count)
                }).ToList();


                results.AddRange(YearTotal);

                return results;

            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }

        }
        public static string GetMonthName(int monthNumber)
        {
            if (monthNumber < 1 || monthNumber > 12)
            {
                return "Total";
            }

            CultureInfo culture = CultureInfo.CurrentCulture;
            string monthName = culture.DateTimeFormat.GetMonthName(monthNumber);

            return monthName;
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

        public async Task<List<GetLeadAttachmentsVm>> GetLeadAttachments(int TenantId, string Id, int LeadId, int ContactTypeId)
        {
            try
            {
                List<GetLeadAttachmentsVm> attachments = await (
                    from a in _dbContext.DocumentLibrary
                    .Where(a => a.TenantId == TenantId && a.IsDeleted == 0 && a.ContactTypeId == ContactTypeId && a.Id == LeadId)
                    select new GetLeadAttachmentsVm
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
            catch(Exception ex)
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
                        LeadObj.Remarks = Lead.Remarks;
                        
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
                    LeadObj.Remarks = Lead.Remarks;
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
                    LeadObj.Mobile= Lead.Mobile;
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

        public async Task RestoreDeletedLeads(RestoreDeletedLeadsCommand request)
        {
            try
            {
                var deleteLead = await (from a in _dbContext.CrmLead.Where(a => a.LeadId == request.LeadId)
                                        select a).FirstOrDefaultAsync();
                if (deleteLead == null)
                {
                    throw new NotFoundException("leadId", request);
                }
                else
                {
                    deleteLead.DeletedBy = request.Id;

                    deleteLead.IsDeleted = 0;
                    await _dbContext.SaveChangesAsync();
                }
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

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
                    "SELECT * FROM public.crmleadstagewiserpt({0},{1},{2},{3},{4},{5})", tenantIdPrm, SourceIdPrm, Status, startDatePrm, endDatePrm, ProductId)
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
                    Lead.Status = obj.statusId;
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
                                                                        Leads = (from b in _dbContext.CrmLead.Where(b => b.Status == a.StatusId && b.IsDeleted == 0 && b.TenantId == request.TenantId)
                                                                                 select new GetStatusWiseLeadsDto
                                                                                 {
                                                                                     LeadId = b.LeadId,
                                                                                     LeadOwner = b.LeadOwner,
                                                                                     FirstName = b.FirstName,
                                                                                     LastName = b.LastName,
                                                                                     Email = b.Email,
                                                                                     Status = b.Status,
                                                                                     Mobile = b.Mobile,
                                                                                 }).OrderByDescending(a => a.LeadId).ToList()
                                                                    }).ToListAsync();
                return leadsWithStatus;

            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }


        public async Task<List<GetDeletedLeadsVm>> GetDeletedLeads(int TenantId, string Id)
        {
            try
            {
                List<GetDeletedLeadsVm> detail = await(from a in _dbContext.CrmLead.Where(a => a.TenantId == TenantId && a.IsDeleted == 1)
                                                                join user in _dbContext.AppUser on a.DeletedBy equals user.Id
                                                                select new GetDeletedLeadsVm
                                                                {
                                                                    Id = a.LeadId,
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

        public async Task<List<GetScoreListVm>> GetleadScoreList(int TenantId, int LeadId)
        {
            try
            {
                List<GetScoreListVm> LeadStatus = await (from a in _dbContext.CrmIScoringQuestion.Where(a => a.TenantId == -1 || a.TenantId == TenantId && a.IsDeleted == 0)
                                                         join led in _dbContext.CrmLead.Where(a => a.LeadId == LeadId) on a.ProductId equals led.ProductId
                                                         join ledsc in _dbContext.CrmLeadScore.Where(a => a.LeadId == LeadId) on a.QuestionId equals ledsc.QuestionId into ab
                                                         from scor in ab.DefaultIfEmpty()

                                                         select new GetScoreListVm
                                                         {
                                                             QuestionId = a.QuestionId,
                                                             Title = a.Title,
                                                             Code = a.Code,
                                                             Order = a.Order,
                                                             Rating = scor == null ? 0 : scor.Rating,
                                                             Weightage = a.Weightage,

                                                         }
                                           ).OrderBy(a => a.Order).ToListAsync();
                return LeadStatus;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task SaveleadScore(SaveLeadScoreCommand Leads)
        {
            try
            {

                var deleteSql = $"DELETE FROM \"CrmLeadScore\" WHERE \"LeadId\" = {Leads.leadId}";
                await _dbContext.Database.ExecuteSqlRawAsync(deleteSql);

                DateTime localDateTime = DateTime.Now;
                foreach (var lead in Leads.Leads)
                {
                    CrmLeadScore LeadObj = new CrmLeadScore();
                    LeadObj.LeadId = Leads.leadId;
                    LeadObj.QuestionId = lead.QuestionId;
                    LeadObj.Rating = lead.Rating;
                    LeadObj.CreatedDate = DateTime.Now.ToUniversalTime();
                    LeadObj.CreatedBy = Leads.Id;
                    await _dbContext.AddAsync(LeadObj);
                    await _dbContext.SaveChangesAsync();
                }
            }
            catch (Exception e)
            {
                throw new BadRequestException(e.Message);
            }
        }

        public async Task<GetCalculateleadScoreListVm> GetCalculateleadScore(GetCalculateleadScoreQuery obj)
        {


            try
            {
                var groupedLeadStatus = await _dbContext.CrmLeadScore.Where(ledsc => ledsc.LeadId == obj.LeadId).Join(
                                      _dbContext.CrmIScoringQuestion,
                                       ledsc => ledsc.QuestionId,
                                        qus => qus.QuestionId,
                                      (ledsc, qus) => new { ledsc.LeadId, ledsc.QuestionId, ledsc.Rating, qus.Weightage }).GroupBy(ls => ls.LeadId)
                                      .Select(group => new GetCalculateleadScoreListVm
                                      {
                                          LeadId = group.Key,
                                          Rating = group.Sum(ls => ls.Rating * ls.Weightage) / (group.Sum(ls => ls.Weightage) == 0 ? 1 : group.Sum(ls => ls.Weightage)),
                                      }).FirstOrDefaultAsync();
                if (groupedLeadStatus == null)
                {
                    return new GetCalculateleadScoreListVm
                    {
                        LeadId = obj.LeadId,
                        Rating = 0
                    };
                }

                return groupedLeadStatus;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }


        }

        public async Task RestoreBulkLead(RestoreBulkLeadCommand command)
        {
            try
            {
                foreach (var leadId in command.LeadId)
                {
                    var lead = await _dbContext.CrmLead
                        .Where(p => p.LeadId == leadId && p.IsDeleted == 1)
                        .FirstOrDefaultAsync();

                    if (lead == null)
                    {
                        throw new NotFoundException(nameof(leadId), leadId);
                    }

                    lead.IsDeleted = 0;
                }

                await _dbContext.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }
       
        public async Task<List<GetLeadScoreQuestionsVm>> GetLeadScoreQuestions(int TenantId, int ProductId)
        {
            try
            {
                var questions = await (
                    from a in _dbContext.CrmIScoringQuestion.Where(a => a.TenantId == TenantId && a.IsDeleted == 0 && a.ProductId == ProductId)
                    select new GetLeadScoreQuestionsVm
                    {
                        QuestionId = a.QuestionId,
                        Title = a.Title,
                        Code = a.Code,
                        Order = a.Order,
                        ProductId = a.ProductId,
                        Weightage = a.Weightage,
                        CreatedDate = a.CreatedDate,
                        TenantId = a.TenantId,
                        IsChecked = true,
                    }).OrderBy(a => a.CreatedDate).ToListAsync();
                return questions;
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        public async Task SaveLeadScoreQuestion(SaveLeadScoreQuestionCommand request)
        {
            try
            {
                DateTime localDateTime = DateTime.Now;
                if (request.Question.QuestionId == -1)
                {
                    CrmIScoringQuestion NewQuestion = new CrmIScoringQuestion();
                    NewQuestion.TenantId = request.TenantId;
                    NewQuestion.Title = request.Question.Title;
                    NewQuestion.Code = request.Question.Code;
                    NewQuestion.Order = request.Question.Order;
                    NewQuestion.ProductId = request.Question.ProductId;
                    NewQuestion.Weightage = request.Question.Weightage;
                    NewQuestion.CreatedBy = request.Id;
                    NewQuestion.CreatedDate = localDateTime.ToUniversalTime();
                    await _dbContext.AddAsync(NewQuestion);
                    await _dbContext.SaveChangesAsync();
                }
                else
                {
                    CrmIScoringQuestion existingQuestion = await (
                        from q in _dbContext.CrmIScoringQuestion.Where(q => q.TenantId == request.TenantId && q.QuestionId == request.Question.QuestionId)
                        select q).FirstOrDefaultAsync();
                    existingQuestion.Title = request.Question.Title;
                    existingQuestion.Code = request.Question.Code;
                    existingQuestion.Order = request.Question.Order;
                    existingQuestion.Weightage = request.Question.Weightage;
                    existingQuestion.LastModifiedBy = request.Id;
                    existingQuestion.LastModifiedDate = localDateTime.ToUniversalTime();
                    await _dbContext.SaveChangesAsync();
                }
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }



        public async Task SaveCopyQuestion(SaveCopyQuestionCommand request)
        {
            try
            {
                DateTime localDateTime = DateTime.Now;
                foreach (var questionDto in request.Questions)
                {
                    if (questionDto.IsChecked == true)
                    {
                        CrmIScoringQuestion newQuestion = new CrmIScoringQuestion();
                        newQuestion.TenantId = request.TenantId;
                        newQuestion.Title = questionDto.Title;
                        newQuestion.Code = questionDto.Code;
                        newQuestion.Order = questionDto.Order;
                        newQuestion.ProductId = request.ProductId;
                        newQuestion.Weightage = questionDto.Weightage;
                        newQuestion.CreatedBy = request.Id;
                        newQuestion.CreatedDate = localDateTime.ToUniversalTime();
                        await _dbContext.AddAsync(newQuestion);
                    }
                    await _dbContext.SaveChangesAsync();

                }
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }
        public async Task DeleteLeadScoreQuestion(int TenantId, int QuestionId)
        {
            try
            {
                var question = await (
                    from a in _dbContext.CrmIScoringQuestion.Where(a => a.TenantId == TenantId && a.QuestionId == QuestionId)
                    select a).FirstOrDefaultAsync();
                question.IsDeleted = 1;
                await _dbContext.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }
    }
}
