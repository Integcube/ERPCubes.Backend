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
        public async Task<List<GetMeetingVm>> GetAllList(string Id, int TenantId, int ContactTypeId, int ContactId)
        {
            try
            {
                List<GetMeetingVm> Meeting = await (
                    from a in _dbContext.CrmMeeting.Where(a => a.IsDeleted == 0 
                    && a.TenantId == TenantId 
                    && (Id == "-1" || a.CreatedBy == Id)
                    && (a.Id == ContactId)
                    && (a.ContactTypeId == ContactTypeId))
                    join uer in _dbContext.AppUser on a.CreatedBy equals uer.Id into all
                    from user in all.DefaultIfEmpty()
                    select new GetMeetingVm
                    {
                        MeetingId = a.MeetingId,
                        Subject = a.Subject,
                        Note = a.Note,
                        StartTime = a.StartTime,
                        EndTime = a.EndTime,
                        CreatedBy = a.CreatedBy,
                        CreatedDate = a.CreatedDate,
                        CreatedByName = user == null ? "User Not Found" : user.FirstName + " " + user.LastName,
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
                        addMeeting.ContactTypeId = meeting.ContactTypeId;
                        addMeeting.Id = meeting.ContactId;
                        await _dbContext.AddAsync(addMeeting);
                        await _dbContext.SaveChangesAsync();
                        var result = _dbContext.Database.ExecuteSqlRaw(
                                    "CALL public.InsertCrmUserActivityLog({0}, {1}, {2}, {3}, {4}, {5}, {6}, {7}, {8},{9})",
                                       meeting.Id, (int)CrmEnum.UserActivityEnum.Meeting, 1, meeting.Subject, meeting.Id, meeting.TenantId, meeting.ContactTypeId, addMeeting.MeetingId, "Insertion", meeting.ContactId);
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
                            
                            var result = _dbContext.Database.ExecuteSqlRaw(
                                                                "CALL public.InsertCrmUserActivityLog({0}, {1}, {2}, {3}, {4}, {5}, {6}, {7}, {8},{9})",
                                                                   meeting.Id, (int)CrmEnum.UserActivityEnum.Meeting, 1, meeting.Subject, meeting.Id, meeting.TenantId, meeting.ContactTypeId, meeting.MeetingId, "Update", meeting.ContactId);
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

