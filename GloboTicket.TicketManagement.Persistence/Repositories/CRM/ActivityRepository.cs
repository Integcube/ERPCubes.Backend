using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Activity.Queries.GetUserActivityReport;
using ERPCubes.Application.Features.Crm.UserActivity.Queries.GetUserActivity;
using ERPCubes.Application.Models.Mail;
using ERPCubes.Domain.Entities;
using ERPCubes.Identity;
using Microsoft.EntityFrameworkCore;
using System.ComponentModel.Design;
using System.Security.Cryptography;

namespace ERPCubes.Persistence.Repositories.CRM
{
    public class ActivityRepository : BaseRepository<CrmUserActivityLog>, IAsyncUserActivityRepository
    {
        public ActivityRepository(ERPCubesDbContext dbContext, ERPCubesIdentityDbContext dbContextIdentity)
            : base(dbContext, dbContextIdentity) { }
        public async Task<List<GetUserActivityVm>> GetUserActivityListAsync(GetUserActivityQuery request)
        {
            try
            {
          var activities = (
                _dbContext.CrmCall.Where(a =>
                 a.TenantId == request.TenantId &&
                 a.IsDeleted == 0 &&
                 (request.LeadId == -1 || (a.Id == request.LeadId && a.IsLead == 1)) &&
                 (request.CompanyId == -1 || (a.Id == request.CompanyId && a.IsCompany == 1)) &&
                 (request.OpportunityId == -1 || (a.Id == request.OpportunityId && a.IsOpportunity == 1))
                ).Select(a => new GetUserActivityVm
                {
                 ActivityId = a.CallId,
                 UserId = a.CreatedBy,
                 CreatedDate = a.CreatedDate,
                 Detail = a.Subject,
                 ActivityStatus = 1,
                 ActivityType = "Call",
                 Icon = "heroicons_outline:phone",
                 ActivityTypeId = 1,
                })
                .Union(
                 _dbContext.CrmEmail.Where(b =>
                     b.TenantId == request.TenantId &&
                     b.IsDeleted == 0 &&
                     (request.LeadId == -1 || (b.Id == request.LeadId && b.IsLead == 1)) &&
                     (request.CompanyId == -1 || (b.Id == request.CompanyId && b.IsCompany == 1)) &&
                     (request.OpportunityId == -1 || (b.Id == request.OpportunityId && b.IsOpportunity == 1))
                 ).Select(b => new GetUserActivityVm
                 {
                     ActivityId = b.EmailId,
                     UserId = b.CreatedBy,
                     CreatedDate = b.CreatedDate,
                     Detail = b.Subject,
                     ActivityStatus = 1,
                     ActivityType = "Email",
                     Icon = "heroicons_outline:envelope",
                     ActivityTypeId = 2,
                 })
                )
                .Union(
                 _dbContext.CrmMeeting.Where(c =>
                     c.TenantId == request.TenantId &&
                     c.IsDeleted == 0 &&
                     (request.LeadId == -1 || (c.Id == request.LeadId && c.IsLead == 1)) &&
                     (request.CompanyId == -1 || (c.Id == request.CompanyId && c.IsCompany == 1)) &&
                     (request.OpportunityId == -1 || (c.Id == request.OpportunityId && c.IsOpportunity == 1))
                 ).Select(c => new GetUserActivityVm
                 {
                     ActivityId = c.MeetingId,
                     UserId = c.CreatedBy,
                     CreatedDate = c.CreatedDate,
                     Detail = c.Subject,
                     ActivityStatus = 1,
                     ActivityType = "Meeting",
                     Icon = "heroicons_outline:user-group",
                     ActivityTypeId = 3,
                 })
                )
                .Union(
                 _dbContext.CrmTask.Where(d =>
                     d.TenantId == request.TenantId &&
                     d.IsDeleted == 0 &&
                     (request.LeadId == -1 || (d.Id == request.LeadId && d.IsLead == 1)) &&
                     (request.CompanyId == -1 || (d.Id == request.CompanyId && d.IsCompany == 1)) &&
                     (request.OpportunityId == -1 || (d.Id == request.OpportunityId && d.IsOpportunity == 1))
                 ).Select(d => new GetUserActivityVm
                 {
                     ActivityId = d.TaskId,
                     UserId = d.CreatedBy,
                     CreatedDate = d.CreatedDate,
                     Detail = d.Title,
                     ActivityStatus = 1,
                     ActivityType = "Task",
                     Icon = "heroicons_outline:pencil",
                     ActivityTypeId = 4,
                 })
                )
                .Union(
                 _dbContext.CrmNote.Where(e =>
                     e.TenantId == request.TenantId &&
                     e.IsDeleted == 0 &&
                     (request.LeadId == -1 || (e.Id == request.LeadId && e.IsLead == 1)) &&
                     (request.CompanyId == -1 || (e.Id == request.CompanyId && e.IsCompany == 1)) &&
                     (request.OpportunityId == -1 || (e.Id == request.OpportunityId && e.IsOpportunity == 1))
                 ).Select(e => new GetUserActivityVm
                 {
                     ActivityId = e.NoteId,
                     UserId = e.CreatedBy,
                     CreatedDate = e.CreatedDate,
                     Detail = e.NoteTitle,
                     ActivityStatus = 1,
                     ActivityType = "Note",
                     Icon = "heroicons_outline:briefcase",
                     ActivityTypeId = 5, // Adjust this ActivityTypeId as needed
                 })
                )
                )
                .OrderByDescending(activity => activity.CreatedDate)
                .Take(request.Count * 10)
                .ToList();
                



                //var callActivitiesTask = (
                //    from a in _dbContext.CrmCall
                //    where a.TenantId == request.TenantId
                //        && a.IsDeleted == 0
                //        && (request.LeadId == -1 || (a.Id == request.LeadId && a.IsLead == 1))
                //        && (request.CompanyId == -1 || (a.Id == request.CompanyId && a.IsCompany == 1))
                //        && (request.OpportunityId == -1 || (a.Id == request.OpportunityId && a.IsOpportunity == 1))
                //    select new GetUserActivityVm
                //    {
                //        ActivityId = a.CallId,
                //        UserId = a.CreatedBy,
                //        CreatedDate = a.CreatedDate,
                //        Detail = a.Subject,
                //        ActivityStatus = 1,
                //        ActivityType = "Call",
                //        Icon = "heroicons_outline:phone",
                //        ActivityTypeId = 1,

                //    }
                //).ToListAsync();

                //var emailActivities = (
                //    from b in _dbContext.CrmEmail
                //    where b.TenantId == request.TenantId
                //        && b.IsDeleted == 0
                //        && (request.LeadId == -1 || (b.Id == request.LeadId && b.IsLead == 1))
                //        && (request.CompanyId == -1 || (b.Id == request.CompanyId && b.IsCompany == 1))
                //        && (request.OpportunityId == -1 || (b.Id == request.OpportunityId && b.IsOpportunity == 1))
                //    select new GetUserActivityVm
                //    {
                //        ActivityId = b.EmailId,
                //        UserId = b.CreatedBy,
                //        CreatedDate = b.CreatedDate,
                //        Detail = b.Subject,
                //        ActivityStatus = 1,
                //        ActivityType = "Email",
                //        Icon = "heroicons_outline:envelope",
                //        ActivityTypeId = 2,

                //    }
                //).ToListAsync();

                //var meetingActivities = (
                //     from b in _dbContext.CrmMeeting
                //     where b.TenantId == request.TenantId
                //         && b.IsDeleted == 0
                //         && (request.LeadId == -1 || (b.Id == request.LeadId && b.IsLead == 1))
                //         && (request.CompanyId == -1 || (b.Id == request.CompanyId && b.IsCompany == 1))
                //         && (request.OpportunityId == -1 || (b.Id == request.OpportunityId && b.IsOpportunity == 1))
                //     select new GetUserActivityVm
                //     {
                //         ActivityId = b.MeetingId,
                //         UserId = b.CreatedBy,
                //         CreatedDate = b.CreatedDate,
                //         Detail = b.Subject,
                //         ActivityStatus = 1,
                //         ActivityType = "Meeting",
                //         Icon = "heroicons_outline:user-group",
                //         ActivityTypeId = 3,
                //     }
                // ).ToListAsync();

                //var taskActivities = (
                //      from b in _dbContext.CrmTask
                //      where b.TenantId == request.TenantId
                //          && b.IsDeleted == 0
                //          && (request.LeadId == -1 || (b.Id == request.LeadId && b.IsLead == 1))
                //          && (request.CompanyId == -1 || (b.Id == request.CompanyId && b.IsCompany == 1))
                //          && (request.OpportunityId == -1 || (b.Id == request.OpportunityId && b.IsOpportunity == 1))
                //      select new GetUserActivityVm
                //      {
                //          ActivityId = b.TaskId,
                //          UserId = b.CreatedBy,
                //          CreatedDate = b.CreatedDate,
                //          Detail = b.Title,
                //          ActivityStatus = 1,
                //          ActivityType = "Task",
                //          Icon = "heroicons_outline:pencil",
                //          ActivityTypeId = 4,
                //      }
                //  ).ToListAsync();

                //var noteActivities = (
                //    from b in _dbContext.CrmNote
                //    where b.TenantId == request.TenantId
                //        && b.IsDeleted == 0
                //        && (request.LeadId == -1 || (b.Id == request.LeadId && b.IsLead == 1))
                //        && (request.CompanyId == -1 || (b.Id == request.CompanyId && b.IsCompany == 1))
                //        && (request.OpportunityId == -1 || (b.Id == request.OpportunityId && b.IsOpportunity == 1))
                //    select new GetUserActivityVm
                //    {
                //        ActivityId = b.NoteId,
                //        UserId = b.CreatedBy,
                //        CreatedDate = b.CreatedDate,
                //        Detail = b.NoteTitle,
                //        ActivityStatus = 1,
                //        ActivityType = "Note",
                //        Icon = "heroicons_outline:briefcase",
                //        ActivityTypeId = 4,
                //    }
                //    ).ToListAsync();

                //await Task.WhenAll(callActivitiesTask, emailActivities, meetingActivities, taskActivities, noteActivities);

                //var combinedActivities = callActivitiesTask.Result
                //    .Union(emailActivities.Result)
                //    .Union(meetingActivities.Result)
                //    .Union(taskActivities.Result)
                //    .Union(noteActivities.Result)
                //    .OrderByDescending(activity => activity.CreatedDate) // Order by CreatedDate descending
                //    .Take(request.Count * 10).ToList();

                //var Activitylist = await (
                //  from a in _dbContext.CrmUserActivityLog.Where(a => a.TenantId == request.TenantId && a.IsDeleted == 0 &&
                //  (a.UserId == request.Id || a.CreatedBy == request.Id) &&
                //  (request.LeadId == -1 || (a.Id == request.LeadId && a.IsLead == 1)) &&
                //  (request.CompanyId == -1 || (a.Id == request.CompanyId && a.IsCompany == 1)) &&
                //  (request.OpportunityId == -1 || (a.Id == request.OpportunityId && a.IsOpportunity == 1)))
                //  join b in _dbContext.CrmUserActivityType on a.ActivityType equals b.ActivityTypeId into all
                //  from c in all.DefaultIfEmpty()
                //  orderby a.CreatedDate descending
                //  select new GetUserActivityVm
                //  {
                //      ActivityId = a.ActivityId,
                //      UserId = a.UserId,
                //      ActivityStatus = a.ActivityStatus,
                //      Detail = a.Detail,
                //      CreatedDate = a.CreatedDate,
                //      CreatedBy = a.CreatedBy,
                //      ActivityType = c.ActivityTypeTitle,
                //      Icon = c.Icon,
                //      ActivityTypeId = c.ActivityTypeId
                //  }).Take(request.Count * 10).ToListAsync();


                return activities;
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }


        }
        public async Task<List<GetUserActivityReportVm>> GetUserActivityReport(string Id, int TenantId)
        {
            try
            {
                var tenantIdParameter = new Npgsql.NpgsqlParameter("@p_tenantid", NpgsqlTypes.NpgsqlDbType.Integer)
                {
                    Value = TenantId
                };

                var results = await _dbContext.GetCrmUserActivity.FromSqlRaw(
                    "SELECT * FROM public.calculateleadevent({0})", tenantIdParameter)
                    .ToListAsync();

                return results;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
