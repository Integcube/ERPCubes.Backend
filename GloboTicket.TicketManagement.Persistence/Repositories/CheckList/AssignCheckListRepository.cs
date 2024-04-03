using ERPCubes.Application.Contracts.Persistence;
using ERPCubes.Application.Contracts.Persistence.CheckList;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Commands.AssignCheckPoint;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Commands.AssigntToLeadsCheckPoint;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Commands.DeleteAssignCheckPoint;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Queries.GetCheckList;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Queries.GetCheckPoint;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Queries.GetExcutedCheckListbyId;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Queries.LazyGetAssignCheckList;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadList;
using ERPCubes.Application.Models.Mail;
using ERPCubes.Domain.Common;
using ERPCubes.Domain.Entities;
using Microsoft.EntityFrameworkCore;


namespace ERPCubes.Persistence.Repositories.CRM
{
    public class AssignCheckListRepository : IAsyncAssignCheckListRepository
    {
        protected readonly ERPCubesDbContext _dbContext;

        public AssignCheckListRepository(ERPCubesDbContext dbContext)
        {
            _dbContext = dbContext;

        }

        public async Task AssignCheckList(AssignCheckPointCommand request)
        {
            try
            {
                if (request.ExecId == -1)
                {


                    CKExecCheckList chkL = new CKExecCheckList();

                    chkL.CreatedDate = DateTime.Now.ToUniversalTime();
                    chkL.TenantId = request.TenantId;
                    chkL.IsDeleted = 0;
                    chkL.CreatedBy = request.Id;
                    chkL.CLId = request.CLId;
                    chkL.Remarks = request.Remarks;
                    chkL.Referenceno = request.Referenceno;
                    await _dbContext.AddAsync(chkL);
                    await _dbContext.SaveChangesAsync();
                    chkL.Code = "0000" + chkL.ExecId.ToString();



                    foreach (var checkpoint in request.List)
                    {

                        CkUserCheckPoint add = new CkUserCheckPoint();
                        add.ExecId = chkL.ExecId;
                        add.CLId = chkL.CLId;
                        add.CPId = checkpoint.CPId;
                        add.AssignTo = checkpoint.AssignTo;
                        add.DueDate = DateTime.Now.ToUniversalTime().AddDays(checkpoint.DueDays);
                        add.CreatedDate = DateTime.Now.ToUniversalTime();
                        add.TenantId = request.TenantId;
                        add.IsDeleted = 0;
                        add.CreatedBy = request.Id;
                        await _dbContext.AddAsync(add);
                        await _dbContext.SaveChangesAsync();

                    }
                }
                else
                {
                    var existingCheckList = await _dbContext.CKExecCheckList.FirstOrDefaultAsync(c => c.ExecId == request.ExecId);
                    if (existingCheckList != null)
                    {
                        existingCheckList.Remarks = request.Remarks;
                        existingCheckList.Referenceno = request.Referenceno;

                        _dbContext.CKExecCheckList.Update(existingCheckList);
                        await _dbContext.SaveChangesAsync();
                        foreach (var checkpoint in request.List)
                        {
                            var existingUserCheckPoint = await _dbContext.CkUserCheckPoint.FirstOrDefaultAsync(c => c.ExecId == request.ExecId && c.CPId == checkpoint.CPId);
                            if (existingUserCheckPoint != null)
                            {
                                existingUserCheckPoint.AssignTo = checkpoint.AssignTo;
                                existingUserCheckPoint.DueDate = DateTime.Now.ToUniversalTime().AddDays(checkpoint.DueDays);
                                _dbContext.CkUserCheckPoint.Update(existingUserCheckPoint);
                            }
                            await _dbContext.SaveChangesAsync();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task AssignToLeads(AssigntToLeadsCheckPointCommand request)
        {

            var obj = await (from a in _dbContext.CkContactCheckList.Where(a => a.CLId == request.CLId)
                             select a).FirstOrDefaultAsync();
            if (obj == null)
            {
                CkContactCheckList chkL = new CkContactCheckList();
                chkL.CreatedDate = DateTime.Now.ToUniversalTime();
                chkL.TenantId = request.TenantId;
                chkL.IsDeleted = 0;
                chkL.CreatedBy = request.Id;
                chkL.CLId = request.CLId;
                chkL.ContactTypeId = 1;
                chkL.StatusId = 1;
                await _dbContext.AddAsync(chkL);
                await _dbContext.SaveChangesAsync();
            }
            else
            {
                if (obj.IsDeleted == 1)
                    request.IAssign = 0;
                else
                    request.IAssign = 1;
                obj.LastModifiedDate = DateTime.Now.ToUniversalTime();
                obj.LastModifiedBy = request.Id;
                obj.IsDeleted = request.IAssign;
                await _dbContext.SaveChangesAsync();

            }
        }

        public async Task Delete(DeleteAssignCheckPointCommand request)
        {
            try
            {
                var obj = await (from a in _dbContext.CKExecCheckList.Where(a => a.ExecId == request.ExecId)
                                 select a).FirstOrDefaultAsync();
                if (obj == null)
                {
                    throw new NotFoundException("ExecId", request.ExecId);
                }
                else
                {
                    obj.IsDeleted = 1;

                    var deleteSql = $"DELETE FROM \"CkUserCheckPoint\" WHERE \"ExecId\" = {request.ExecId}";
                    await _dbContext.Database.ExecuteSqlRawAsync(deleteSql);
                    await _dbContext.SaveChangesAsync();
                }
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
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
                if (request.ExecId == -1)
                {
                    var chp2 = await (from a in _dbContext.CKCheckPoint.Where(a => a.TenantId == request.TenantId && a.IsDeleted == 0 && a.CLId == request.CLId)
                                      select new GetCheckPointVm
                                      {
                                          Title = a.Title,
                                          CLId = a.CLId,
                                          CPId = a.CPId,
                                          Description = a.Description,
                                          DueDays = a.DueDays,
                                          IsRequired = a.IsRequired,
                                          AssignTo = request.userId,
                                          ExecId = -1,
                                          DueDate = DateTimeOffset.UtcNow.AddDays(a.DueDays)
                                      }).OrderBy(A => A.CPId).ToListAsync();
                    return chp2;
                }
                else
                {
                    var chp = await (from c in _dbContext.CKExecCheckList.Where(a => a.TenantId == request.TenantId && a.IsDeleted == 0 && a.ExecId == request.ExecId)
                                     join cp in _dbContext.CkUserCheckPoint on c.ExecId equals cp.ExecId
                                     join a in _dbContext.CKCheckPoint on cp.CPId equals a.CPId
                                     select new GetCheckPointVm
                                     {
                                         Title = a.Title,
                                         CLId = a.CLId,
                                         CPId = a.CPId,
                                         DueDays = a.DueDays,
                                         IsRequired = a.IsRequired,
                                         AssignTo = cp.AssignTo == "-1" ? request.userId : cp.AssignTo,
                                         ExecId = cp.ExecId,
                                         DueDate = cp.DueDate
                                     }).OrderBy(A => A.CPId).ToListAsync();
                    return chp;
                }
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task<GetExcutedCheckListbyIdVm> GetExcutedCheckListbyId(GetExcutedCheckListbyIdQuery request)
        {
            var query = await _dbContext.CKExecCheckList.Where(a => a.TenantId == request.TenantId && a.ExecId == request.ExecId)
                            .Select(a => new GetExcutedCheckListbyIdVm
                            {
                                ExecId = a.ExecId,
                                CLId = a.CLId,
                                Remarks = a.Remarks,
                                TenantId = a.TenantId,
                                Code = a.Code,
                                Referenceno = a.Referenceno
                            }).FirstOrDefaultAsync();

            return query;
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
                                 CreatedByName = c.FirstName + " " + c.LastName,
                                 Code = a.Code,
                                 Referenceno = a.Referenceno,

                             });


                if (!string.IsNullOrEmpty(request.Search))
                {
                    var searchTerm = request.Search.ToLower();
                    query = query.Where(a =>
                        a.CheckList.ToLower().Contains(searchTerm) ||
                        a.Remarks.ToLower().Contains(searchTerm) ||
                        a.Code.ToLower().Contains(searchTerm)

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
                        case "code":
                            query = request.Order.ToLower() == "desc" ? query.OrderByDescending(a => a.Code) : query.OrderBy(a => a.Code);
                            break;
                        case "referenceno":
                            query = request.Order.ToLower() == "desc" ? query.OrderByDescending(a => a.Referenceno) : query.OrderBy(a => a.Referenceno);
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
