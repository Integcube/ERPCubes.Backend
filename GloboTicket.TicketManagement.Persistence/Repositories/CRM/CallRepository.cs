using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Call.Commands.DeleteCall;
using ERPCubes.Application.Features.Crm.Call.Commands.SaveCall;
using ERPCubes.Application.Features.Crm.Call.Queries.GetCallList;
using ERPCubes.Domain.Entities;
using ERPCubes.Identity;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Persistence.Repositories.CRM
{
    public class CallRepository : BaseRepository<CrmCall>, IAsyncCallRepository
    {
        public CallRepository(ERPCubesDbContext dbContext, ERPCubesIdentityDbContext dbContextIdentity) : base(dbContext, dbContextIdentity)
        {
        }

        public async Task DeleteCall(DeleteCallCommand callId)
        {
            try
            {
                var deleteCall = await(from a in _dbContext.CrmCall.Where(a => a.CallId == callId.CallId)
                                        select a).FirstOrDefaultAsync();
                if (deleteCall == null)
                {
                    throw new NotFoundException("callId", callId);
                }
                else
                {
                    deleteCall.IsDeleted = 1;
                    await _dbContext.SaveChangesAsync();
                }
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task<List<GetCallVm>> GetAllList(string Id, int TenantId)
        {
            try
            {
                List<GetCallVm> Call = await (from a in _dbContext.CrmCall.Where(a => a.IsDeleted == 0 && a.TenantId == TenantId)
                                               select new GetCallVm
                                               {
                                                   CallId = a.CallId,
                                                   Subject = a.Subject,
                                                   Response = a.Response,
                                                   StartTime= a.StartTime,
                                                   EndTime= a.EndTime,
                                                   CreatedBy = a.CreatedBy,
                                                   CreatedDate=a.CreatedDate

                                               }).ToListAsync();

                return Call;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task SaveCall(SaveCallCommand call)
        {
            try
            {
                DateTime localDateTime = DateTime.Now;

                if (call.CallId == -1)
                {
                    CrmCall addCall = new CrmCall();
                    addCall.Subject = call.Subject;
                    addCall.Response = call.Response;
                    addCall.StartTime = call.StartTime;
                    addCall.EndTime = call.EndTime;
                    //addCall.CreatedBy = call.Id;
                    addCall.CreatedDate = localDateTime.ToUniversalTime();

                    if (call.CompanyId == -1)
                    {
                        addCall.IsCompany = -1;
                    }
                    else
                    {
                        addCall.IsCompany = 1;
                        addCall.Id = call.CompanyId;
                    }
                    if (call.LeadId == -1)
                    {
                        addCall.IsLead = -1;
                    }
                    else
                    {
                        addCall.IsLead = 1;
                        addCall.Id = call.LeadId;
                    }
                    if (call.LeadId == -1 && call.CompanyId == -1)
                    {
                        call.CompanyId = -1;
                    }

                    await _dbContext.AddAsync(addCall);
                    await _dbContext.SaveChangesAsync();
                }
                else
                {
                    var existingCall = await(from a in _dbContext.CrmCall.Where(a => a.CallId == call.CallId)
                                              select a).FirstAsync();
                    if (existingCall == null)
                    {
                        throw new NotFoundException(call.Subject, call.CallId);
                    }
                    else
                    {
                        existingCall.Subject = call.Subject;
                        existingCall.Response = call.Response;
                        existingCall.StartTime = call.StartTime;
                        existingCall.EndTime = call.EndTime;
                        //existingCall.CreatedBy = call.Id;
                        existingCall.CreatedDate = localDateTime.ToUniversalTime();

                        if (call.CompanyId == -1)
                        {
                            existingCall.IsCompany = -1;
                        }
                        else
                        {
                            existingCall.IsCompany = 1;
                            existingCall.Id = call.CompanyId;
                        }
                        if (call.LeadId == -1)
                        {
                            existingCall.IsLead = -1;
                        }
                        else
                        {
                            existingCall.IsLead = 1;
                            existingCall.Id = call.LeadId;
                        }
                        if (call.LeadId == -1 && call.CompanyId == -1)
                        {
                            call.CompanyId = -1;
                        }
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
