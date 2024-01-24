using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Calender.Commands.DeleteCalendarEvent;
using ERPCubes.Application.Features.Crm.Calender.Commands.SaveCalendarEvent;
using ERPCubes.Application.Features.Crm.Calender.Queries.GetCalendarTypeList;
using ERPCubes.Application.Features.Crm.Calender.Queries.GetCalenderList;
using ERPCubes.Application.Models.Mail;
using ERPCubes.Domain.Entities;
using ERPCubes.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.ComponentModel.Design;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Persistence.Repositories.CRM
{
    public class CalenderRepository : BaseRepository<CrmCalenderEvents>, IAsyncCalenderRepository
    {
        public CalenderRepository(ERPCubesDbContext dbContext, ERPCubesIdentityDbContext dbContextIdentity) : base(dbContext, dbContextIdentity) { }

        public async Task DeleteCalendarEvent(DeleteCalendarEventCommand request)
        {
            try
            {
                CrmCalenderEvents? calenderDetail = await(from a in _dbContext.CrmCalenderEvents.Where(a => (a.EventId == request.EventId))
                                                               select a).OrderByDescending(a => a.Id).FirstOrDefaultAsync();
                if (calenderDetail == null)
                {
                    throw new NotFoundException(request.Title, request.EventId);
                }
                else
                {
                    calenderDetail.IsDeleted = 1;
                    await _dbContext.SaveChangesAsync();
                }
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task<List<GetCalenderListVm>> GetAllList(string Id, int TenantId)
        {
            try
            {
                List<GetCalenderListVm> calenderDetail = await (from a in _dbContext.CrmCalenderEvents.Where(a => (a.TenantId == TenantId) && (a.IsDeleted == 0) && (a.UserId == Id) && (a.CreatedBy == Id))
                                                                select new GetCalenderListVm
                                                                {
                                                                    Id = a.EventId,
                                                                    UserId = a.UserId,
                                                                    Title = a.Description,
                                                                    Type = a.Type,
                                                                    End = a.EndTime,
                                                                    Start = a.StartTime,
                                                                    AllDay = a.AllDay,
                                                                }).OrderByDescending(a => a.Id).ToListAsync();
                return calenderDetail;
            }
            catch(Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task<List<GetCalendarTypeListVm>> GetCalendarEventType(GetCalendarTypeListQuery request)
        {
            try
            {
                List<GetCalendarTypeListVm> calenderDetail = await(from a in _dbContext.CrmCalendarEventsType.Where(a => a.IsDeleted == 0)
                                                               select new GetCalendarTypeListVm
                                                               {
                                                                   TypeId = a.TypeId,
                                                                   TypeTitle = a.TypeTitle,
                                                                  
                                                               }).OrderBy(a => a.TypeTitle).ToListAsync();
                return calenderDetail;

            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task SaveCalendarEvent(SaveCalendarEventCommand request)
        {
            try
            {
                DateTime localDateTime = DateTime.Now;

                if (request.Event.Id == -1)
                {
                    CrmCalenderEvents events = new CrmCalenderEvents();
                    events.AllDay = request.Event.AllDay;
                    events.StartTime = request.Event.Start.ToUniversalTime();
                    events.Description = request.Event.Title;
                    events.EndTime = request.Event.End.ToUniversalTime();
                    events.Type = request.Event.Type;
                    events.CreatedBy = request.Id;
                    events.CreatedDate = localDateTime.ToUniversalTime();
                    events.TenantId = request.TenantId;
                    events.IsDeleted = 0;
                    events.UserId = request.Id;
                    events.ContactTypeId = request.ContactTypeId;
                    events.ActivityId = request.ActivityId;
                    // for calendar hardcoded to -1
                    events.Id = -1 ;
                    //if (request.CompanyId == -1)
                    //{
                    //    events.IsCompany = -1;
                    //}
                    //else
                    //{
                    //    events.IsCompany = 1;
                    //    events.Id = request.CompanyId;
                    //}
                    //if (request.LeadId == -1)
                    //{
                    //    events.IsLead = -1;
                    //}
                    //else
                    //{
                    //    events.IsLead = 1;
                    //    events.Id = request.LeadId;
                    //}
                    //if (request.OpportunityId == -1)
                    //{
                    //    events.IsOpportunity = -1;
                    //}
                    //else
                    //{
                    //    events.IsOpportunity = 1;
                    //    events.Id = request.OpportunityId;
                    //}
                    //if (request.LeadId == -1 && request.CompanyId == -1 && request.OpportunityId == -1)
                    //{
                    //    events.Id = -1;
                    //}
                    await _dbContext.AddAsync(events);
                    await _dbContext.SaveChangesAsync();

                }
                else
                {
                    CrmCalenderEvents? events = await (from a in _dbContext.CrmCalenderEvents.Where(a => (a.EventId == request.Event.Id))
                                                               select a).OrderByDescending(a => a.Id).FirstOrDefaultAsync();
                    if (events == null)
                    {
                        throw new NotFoundException(request.Event.Title, request.Event.Id);
                    }
                    else
                    {
                        events.AllDay = request.Event.AllDay;
                        events.StartTime = request.Event.Start.ToUniversalTime();
                        events.Description = request.Event.Title;
                        events.EndTime = request.Event.End.ToUniversalTime();
                        events.Type = request.Event.Type;
                        events.LastModifiedBy = request.Id;
                        events.LastModifiedDate = localDateTime.ToUniversalTime();
                        //if (request.CompanyId == -1)
                        //{
                        //    events.IsCompany = -1;
                        //}
                        //else
                        //{
                        //    events.IsCompany = 1;
                        //    events.Id = request.CompanyId;
                        //}
                        //if (request.LeadId == -1)
                        //{
                        //    events.IsLead = -1;
                        //}
                        //else
                        //{
                        //    events.IsLead = 1;
                        //    events.Id = request.LeadId;
                        //}
                        //if (request.OpportunityId == -1)
                        //{
                        //    events.IsOpportunity = -1;
                        //}
                        //else
                        //{
                        //    events.IsOpportunity = 1;
                        //    events.Id = request.OpportunityId;
                        //}
                        //if (request.LeadId == -1 && request.CompanyId == -1 && request.OpportunityId == -1)
                        //{
                        //    events.Id = -1;
                        //}
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
