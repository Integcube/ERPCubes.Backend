using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Email.Queries.GetEmailList;
using ERPCubes.Application.Features.Crm.Meeting.Commands.DeleteMeeting;
using ERPCubes.Application.Features.Crm.Meeting.Commands.SaveMeeting;
using ERPCubes.Application.Features.Crm.Meeting.Queries.GetMeetingList;
using ERPCubes.Application.Models.Mail;
using ERPCubes.Domain.Entities;
using ERPCubes.Identity;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.ComponentModel.Design;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Persistence.Repositories.CRM
{
    public class MeetingRepository : BaseRepository<CrmMeeting>, IAsyncMeetingRepository
    {
        public MeetingRepository(ERPCubesDbContext dbContext, ERPCubesIdentityDbContext dbContextIdentity) : base(dbContext, dbContextIdentity)
        {
        }
        public async Task<List<GetMeetingVm>> GetAllList(string Id, int TenantId, int LeadId, int CompanyId, int OpportunityId)
        {
            try
            {
                List<GetMeetingVm> Meeting = await (
                    from a in _dbContext.CrmMeeting.Where(a => a.IsDeleted == 0 && a.TenantId == TenantId &&
                    (Id == "-1" || a.CreatedBy == Id) &&
                    (LeadId == -1 || (a.Id == LeadId && a.IsLead == 1)) &&
                    (CompanyId == -1 || (a.Id == CompanyId && a.IsCompany == 1)) &&
                    (OpportunityId == -1 || (a.Id == OpportunityId && a.IsOpportunity == 1)))
                    select new GetMeetingVm
                    {
                        MeetingId = a.MeetingId,
                        Subject = a.Subject,
                        Note = a.Note,
                        StartTime = a.StartTime,
                        EndTime = a.EndTime,
                        CreatedBy = a.CreatedBy,
                        CreatedDate = a.CreatedDate

                    }).OrderByDescending(a => a.CreatedDate).ToListAsync();

                return Meeting;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task DeleteMeeting(DeleteMeetingCommand meetingId)
        {
            try
            {
                var deleteMeeting = await (from a in _dbContext.CrmMeeting.Where(a => a.MeetingId == meetingId.MeetingId)
                                           select a).FirstOrDefaultAsync();
                if (deleteMeeting == null)
                {
                    throw new NotFoundException("meetingId", meetingId);
                }
                else
                {
                    deleteMeeting.IsDeleted = 1;
                    await _dbContext.SaveChangesAsync();
                }
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }
        public async Task SaveMeeting(SaveMeetingCommand meeting)
        {
            {
                try
                {
                    DateTime localDateTime = DateTime.Now;

                    if (meeting.MeetingId == -1)
                    {
                        CrmMeeting addMeeting = new CrmMeeting();
                        addMeeting.Subject = meeting.Subject;
                        addMeeting.Note = meeting.Note;
                        addMeeting.StartTime = meeting.StartTime.ToUniversalTime();
                        addMeeting.EndTime = meeting.EndTime.ToUniversalTime();
                        addMeeting.TenantId = meeting.TenantId;
                        addMeeting.CreatedBy = meeting.Id;
                        addMeeting.CreatedDate = localDateTime.ToUniversalTime();
                        if (meeting.CompanyId == -1)
                        {
                            addMeeting.IsCompany = -1;
                        }
                        else
                        {
                            addMeeting.IsCompany = 1;
                            addMeeting.Id = meeting.CompanyId;
                        }
                        if (meeting.LeadId == -1)
                        {
                            addMeeting.IsLead = -1;
                        }
                        else
                        {
                            addMeeting.IsLead = 1;
                            addMeeting.Id = meeting.LeadId;
                        }
                        if (meeting.OpportunityId == -1)
                        {
                            addMeeting.IsOpportunity = -1;
                        }
                        else
                        {
                            addMeeting.IsOpportunity = 1;
                            addMeeting.Id = meeting.OpportunityId;
                        }
                        if (meeting.LeadId == -1 && meeting.CompanyId == -1 && meeting.OpportunityId == -1)
                        {
                            addMeeting.Id = -1;
                        }
                        await _dbContext.AddAsync(addMeeting);
                        await _dbContext.SaveChangesAsync();

                        CrmUserActivityLog ActivityObj = new CrmUserActivityLog();
                        ActivityObj.UserId = addMeeting.CreatedBy;
                        ActivityObj.Detail = addMeeting.Subject;
                        ActivityObj.ActivityType = 3;
                        ActivityObj.ActivityStatus = 1;
                        ActivityObj.TenantId = addMeeting.TenantId;
                        if (meeting.CompanyId == -1)
                        {
                            ActivityObj.IsCompany = -1;
                        }
                        else
                        {
                            ActivityObj.IsCompany = 1;
                            ActivityObj.Id = meeting.CompanyId;
                        }
                        if (meeting.LeadId == -1)
                        {
                            ActivityObj.IsLead = -1;
                        }
                        else
                        {
                            ActivityObj.IsLead = 1;
                            ActivityObj.Id = meeting.LeadId;
                        }
                        if (meeting.OpportunityId == -1)
                        {
                            ActivityObj.IsOpportunity = -1;
                        }
                        else
                        {
                            ActivityObj.IsOpportunity = 1;
                            ActivityObj.Id = meeting.OpportunityId;
                        }
                        if (meeting.LeadId == -1 && meeting.CompanyId == -1 && meeting.OpportunityId == -1)
                        {
                            ActivityObj.Id = -1;
                        }
                        ActivityObj.CreatedBy = meeting.Id;
                        ActivityObj.CreatedDate = localDateTime.ToUniversalTime();
                        await _dbContext.CrmUserActivityLog.AddAsync(ActivityObj);
                        await _dbContext.SaveChangesAsync();
                    }
                    else
                    {
                        var existingMeeting = await (from a in _dbContext.CrmMeeting.Where(a => a.MeetingId == meeting.MeetingId)
                                                     select a).FirstAsync();
                        if (existingMeeting == null)
                        {
                            throw new NotFoundException(meeting.Subject, meeting.MeetingId);
                        }
                        else
                        {
                            existingMeeting.Subject = meeting.Subject;
                            existingMeeting.Note = meeting.Note;
                            existingMeeting.StartTime = meeting.StartTime.ToUniversalTime();
                            existingMeeting.LastModifiedBy = meeting.Id;
                            existingMeeting.EndTime = meeting.EndTime.ToUniversalTime();
                            existingMeeting.LastModifiedDate = localDateTime.ToUniversalTime();
                            await _dbContext.SaveChangesAsync();
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
}

