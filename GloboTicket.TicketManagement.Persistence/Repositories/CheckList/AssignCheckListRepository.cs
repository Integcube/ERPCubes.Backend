using ERPCubes.Application.Contracts.Persistence;
using ERPCubes.Application.Contracts.Persistence.CheckList;
using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.AppUser.Queries.GetUserList;
using ERPCubes.Application.Features.AppUser.Queries.LazyGetUserList;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Queries.GetCheckList;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Queries.GetCheckPoint;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Queries.LazyGetAssignCheckList;
using ERPCubes.Application.Features.Crm.Call.Commands.DeleteCall;
using ERPCubes.Application.Features.Crm.Call.Commands.SaveCall;
using ERPCubes.Application.Features.Crm.Call.Queries.GetCallList;
using ERPCubes.Application.Features.Crm.Call.Queries.GetCallScenariosList;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadList;
using ERPCubes.Application.Models.Mail;
using ERPCubes.Domain.Common;
using ERPCubes.Domain.Entities;
using ERPCubes.Identity;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.ComponentModel.Design;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;
using static ERPCubes.Persistence.Repositories.CRM.CrmEnum;

namespace ERPCubes.Persistence.Repositories.CRM
{
    public class AssignCheckListRepository : IAsyncAssignCheckListRepository
    {
        protected readonly ERPCubesDbContext _dbContext;

        public AssignCheckListRepository(ERPCubesDbContext dbContext)
        {
            _dbContext = dbContext;

        }

        public async Task<List<GetCheckListVm>> GetCheckList(GetCheckListQuery request)
        {
            try
            {
                var chk = await (from a in _dbContext.CkCheckList.Where(a => a.TenantId == request.TenantId && a.IsDeleted == 0)
                                 select new GetCheckListVm
                                 {
                                     Title = a.Title,
                                     CLId = a.CLId
                                 }).OrderBy(A => A.Title).ToListAsync();
                return chk;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task<List<GetCheckPointVm>> GetCheckPoint(GetCheckPointQuery request)
        {

            try
            {
                var chp = await (from a in _dbContext.CkCheckList.Where(a => a.TenantId == request.TenantId && a.IsDeleted == 0 && a.CLId == request.CLId)
                                 join b in _dbContext.CKCheckPoint on a.CLId equals b.CLId
                                 join c in _dbContext.CKExecCheckList.Where(a => a.ExecId == request.ExecId) on a.CLId equals c.CLId into abc
                                 from c2 in abc.DefaultIfEmpty()
                                 join cp in _dbContext.CkUserCheckPoint.Where(a => a.ExecId == request.ExecId) on c2.ExecId equals cp.ExecId into CHP
                                 from cp2 in CHP.DefaultIfEmpty()
                                 select new GetCheckPointVm
                                 {
                                     Title = b.Title,
                                     CLId = a.CLId,
                                     DueDays = b.DueDays,
                                     IsRequired = b.IsRequired,
                                     AssignTo= cp2==null ? "-1" : cp2.AssignTo,
                                     ExecId= c2==null?-1: c2.ExecId
                                 }).OrderBy(A => A.Title).ToListAsync();

                return chp;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task<LazyGetAssignCheckListVm> LazyGetAssignCheckList(LazyGetAssignCheckListQuery request)
        {

            try
            {
                var query = (from a in _dbContext.CKExecCheckList
                             where a.TenantId == request.TenantId && a.IsDeleted == 0
                             join b in _dbContext.CkCheckList on a.CLId equals b.CLId
                             join c in _dbContext.AppUser on a.CreatedBy equals c.Id
                             select new LazyGetAssignCheckList
                             {
                                 CLId = a.CLId,
                                 ExecId = a.ExecId,
                                 Remarks = a.Remarks,
                                 CheckList = b.Title,
                                 CreatedBy = a.CreatedBy,
                                 CreatedDate = a.CreatedDate,
                                 CreatedByName = c.FirstName + " " + c.LastName
                             });


                if (!string.IsNullOrEmpty(request.Search))
                {
                    var searchTerm = request.Search.ToLower();
                    query = query.Where(a =>
                        a.CheckList.ToLower().Contains(searchTerm) ||
                        a.Remarks.ToLower().Contains(searchTerm)
                    );
                }

                if (string.IsNullOrEmpty(request.Sort))
                {
                    query = query.OrderByDescending(a => a.CreatedDate);
                }
                else
                {
                    switch (request.Sort.ToLower())
                    {
                        case "checkList":
                            query = request.Order.ToLower() == "desc" ? query.OrderByDescending(a => a.CheckList) : query.OrderBy(a => a.CheckList);
                            break;
                        case "remarks":
                            query = request.Order.ToLower() == "desc" ? query.OrderByDescending(a => a.Remarks) : query.OrderBy(a => a.Remarks);
                            break;
                        case "createdDate":
                            query = request.Order.ToLower() == "desc" ? query.OrderByDescending(a => a.CreatedDate) : query.OrderBy(a => a.CreatedDate);
                            break;


                    }
                }


                int leadLength = query.Count();

                int begin = request.Page * request.Size;
                int end = Math.Min((request.Size * (request.Page + 1)), leadLength);
                int lastPage = Math.Max((int)Math.Ceiling((double)leadLength / request.Size), 1);


                List<LazyGetAssignCheckList> querylist = await query.Skip(begin).Take(end - begin).ToListAsync();


                PaginationVm pagination = new PaginationVm
                {
                    Length = leadLength,
                    Size = request.Size,
                    Page = request.Page,
                    LastPage = lastPage,
                    StartIndex = begin,
                    EndIndex = end - 1
                };

                LazyGetAssignCheckListVm response = new LazyGetAssignCheckListVm
                {
                    List = querylist,
                    PaginationVm = pagination
                };

                return response;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }

        }
    }
}
