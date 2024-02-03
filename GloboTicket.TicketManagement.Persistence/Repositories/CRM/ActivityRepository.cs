using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Activity.Queries.GetUserActivityReport;
using ERPCubes.Application.Features.Crm.UserActivity.Queries.GetUserActivity;
using ERPCubes.Application.Models.Mail;
using ERPCubes.Domain.Entities;
using ERPCubes.Identity;
using Microsoft.EntityFrameworkCore;
using System.ComponentModel.Design;
using System.Runtime.InteropServices;
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
                var activities = await (
                    from call in _dbContext.CrmCall.Where(a => a.TenantId == request.TenantId && a.IsDeleted == 0
                    && (request.ContactTypeId == -1 || a.ContactTypeId == request.ContactTypeId)
                    && (request.ContactId == -1 || a.Id == request.ContactId)
                    && (request.Id == "-1" || a.CreatedBy == request.Id))
                    join callUser in _dbContext.AppUser on call.CreatedBy equals callUser.Id into callUsers
                    from userCall in callUsers.DefaultIfEmpty()
                    select new GetUserActivityVm
                    {
                        ActivityId = call.CallId,
                        UserId = call.CreatedBy,
                        CreatedDate = call.CreatedDate,
                        Detail = call.Subject,
                        ActivityStatus = 1,
                        ActivityType = "Call",
                        Icon = "heroicons_outline:phone",
                        ActivityTypeId = 1,
                        UserName = userCall == null ? "User not found" : userCall.FirstName + " " + userCall.LastName
                    }).Union(
                        from email in _dbContext.CrmEmail.Where(b => b.TenantId == request.TenantId && b.IsDeleted == 0
                         && (request.ContactTypeId == -1 || b.ContactTypeId == request.ContactTypeId)
                         && (request.ContactId == -1 || b.Id == request.ContactId)
                         && (request.Id == "-1" || b.CreatedBy == request.Id))
                        join emailUser in _dbContext.AppUser on email.CreatedBy equals emailUser.Id into emailUsers
                        from userEmail in emailUsers.DefaultIfEmpty()
                        select new GetUserActivityVm
                        {
                            ActivityId = email.EmailId,
                            UserId = email.CreatedBy,
                            CreatedDate = email.CreatedDate,
                            Detail = email.Subject,
                            ActivityStatus = 1,
                            ActivityType = "Email",
                            Icon = "heroicons_outline:envelope",
                            ActivityTypeId = 2,
                            UserName = userEmail == null ? "User not found" : userEmail.FirstName + " " + userEmail.LastName
                        }
                    ).Union(
                        from meeting in _dbContext.CrmMeeting.Where(c => c.TenantId == request.TenantId && c.IsDeleted == 0
                         && (request.ContactTypeId == -1 || c.ContactTypeId == request.ContactTypeId)
                         && (request.ContactId == -1 || c.Id == request.ContactId)
                         && (request.Id == "-1" || c.CreatedBy == request.Id))
                        join meetingUser in _dbContext.AppUser on meeting.CreatedBy equals meetingUser.Id into meetingUsers
                        from userMeeting in meetingUsers.DefaultIfEmpty()
                        select new GetUserActivityVm
                        {
                            ActivityId = meeting.MeetingId,
                            UserId = meeting.CreatedBy,
                            CreatedDate = meeting.CreatedDate,
                            Detail = meeting.Subject,
                            ActivityStatus = 1,
                            ActivityType = "Meeting",
                            Icon = "heroicons_outline:user-group",
                            ActivityTypeId = 3,
                            UserName = userMeeting == null ? "User not found" : userMeeting.FirstName + " " + userMeeting.LastName
                        }
                    ).Union(
                        from task in _dbContext.CrmTask.Where(d => d.TenantId == request.TenantId && d.IsDeleted == 0
                        && (request.ContactTypeId == -1 || d.ContactTypeId == request.ContactTypeId)
                        && (request.ContactId == -1 || d.Id == request.ContactId)
                        && (request.Id == "-1" || d.CreatedBy == request.Id))
                        join taskUser in _dbContext.AppUser on task.CreatedBy equals taskUser.Id into taskUsers
                        from userTask in taskUsers.DefaultIfEmpty()
                        select new GetUserActivityVm
                        {
                            ActivityId = task.TaskId,
                            UserId = task.CreatedBy,
                            CreatedDate = task.CreatedDate,
                            Detail = task.Title,
                            ActivityStatus = 1,
                            ActivityType = "Task",
                            Icon = "heroicons_outline:pencil",
                            ActivityTypeId = 4,
                            UserName = userTask == null ? "User not found" : userTask.FirstName + " " + userTask.LastName
                        }
                    ).Union(
                        from note in _dbContext.CrmNote.Where(e => e.TenantId == request.TenantId && e.IsDeleted == 0
                         && (request.ContactTypeId == -1 || e.ContactTypeId == request.ContactTypeId)
                         && (request.ContactId == -1 || e.Id == request.ContactId)
                         && (request.Id == "-1" || e.CreatedBy == request.Id))
                        join noteUser in _dbContext.AppUser on note.CreatedBy equals noteUser.Id into noteUsers
                        from userNote in noteUsers.DefaultIfEmpty()
                        select new GetUserActivityVm
                        {
                            ActivityId = note.NoteId,
                            UserId = note.CreatedBy,
                            CreatedDate = note.CreatedDate,
                            Detail = note.NoteTitle,
                            ActivityStatus = 1,
                            ActivityType = "Note",
                            Icon = "heroicons_outline:briefcase",
                            ActivityTypeId = 5,
                            UserName = userNote == null ? "User not found" : userNote.FirstName + " " + userNote.LastName
                        }
                    ).OrderByDescending(activity => activity.CreatedDate).Take(request.Count * 10).ToListAsync();


                return activities;
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }
        public async Task<List<GetUserActivityReportVm>> GetUserActivityReport(GetUserActivityReportQuery obj)
        {
            try
            {
                var tenantIdParameter = new Npgsql.NpgsqlParameter("@p_tenantid", NpgsqlTypes.NpgsqlDbType.Integer)
                {
                    Value = obj.TenantId
                };

                var UserId = new Npgsql.NpgsqlParameter("@p_UserId", NpgsqlTypes.NpgsqlDbType.Varchar)
                {
                    Value = obj.Id
                };
                var ProjectIdPrm = new Npgsql.NpgsqlParameter("@p_ProjectId", NpgsqlTypes.NpgsqlDbType.Integer)
                {
                    Value = obj.ProjectId
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

                var results = await _dbContext.GetCrmUserActivity.FromSqlRaw(
                    "SELECT * FROM public.calculateleadevent({0},{1},{2},{3},{4},{5})", tenantIdParameter, startDatePrm, endDatePrm,ProductId, ProjectIdPrm, Status )
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
