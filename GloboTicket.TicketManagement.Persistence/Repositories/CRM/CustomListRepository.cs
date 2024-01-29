using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.CustomLists.Commands.DeleteCustomList;
using ERPCubes.Application.Features.Crm.CustomLists.Commands.SaveCustomList;
using ERPCubes.Application.Features.Crm.CustomLists.Commands.SaveCustomListFilters;
using ERPCubes.Application.Features.Crm.CustomLists.Queries.GetCustomLists;
using ERPCubes.Domain.Entities;
using ERPCubes.Identity;
using Microsoft.EntityFrameworkCore;

namespace ERPCubes.Persistence.Repositories.CRM
{
    public class CustomListRepository : BaseRepository<CrmLead>, IAsyncCustomListRepository
    {
        public CustomListRepository(ERPCubesDbContext dbContext, ERPCubesIdentityDbContext dbContextIdentity) : base(dbContext, dbContextIdentity)
        {
        }

        public async Task DeleteCustomList(DeleteCustomListCommand request)
        {
            try
            {
                CrmCustomLists? List = await (from a in _dbContext.CrmCustomLists.Where(a => a.ListId == request.ListId)
                                              select a).FirstOrDefaultAsync();
                if (List == null)
                {
                    throw new NotFoundException(request.ListTitle, request.ListId);
                }
                else
                {
                    List.IsDeleted = 1;
                    await _dbContext.SaveChangesAsync();
                }
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task<List<GetCustomListVm>> GetAllCustomLists(int TenantId, string Id, string Type)
        {
            try
            {
                List<GetCustomListVm> List = await (from a in _dbContext.CrmCustomLists.Where(a => a.IsDeleted == 0 && (a.CreatedBy == Id || a.IsPublic == 1) && a.Type == Type && a.TenantId == TenantId)
                                                    select new GetCustomListVm
                                                    {
                                                        ListId = a.ListId,
                                                        ListTitle = a.ListTitle,
                                                        Filter = a.Filter,
                                                    }).OrderBy(a=>a.ListId).ToListAsync();
                return List;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }

        }

        public async Task<CrmCustomLists> SaveCustomList(SaveCustomListCommand request)
        {
            try
            {
                DateTime localDateTime = DateTime.Now;

                if (request.ListId == -1)
                {
                    CrmCustomLists List = new CrmCustomLists();
                    List.ListTitle = request.ListTitle;
                    List.Type = request.Type;
                    List.TenantId = request.TenantId;
                    List.ListTitle = request.ListTitle;
                    List.IsPublic = request.IsPublic;
                    List.CreatedDate = localDateTime.ToUniversalTime();
                    List.CreatedBy = request.Id;
                    List.IsDeleted = 0;
                    await _dbContext.AddAsync(List);
                    await _dbContext.SaveChangesAsync();
                    return List;
                }
                else
                {
                    CrmCustomLists? List = await (from a in _dbContext.CrmCustomLists.Where(a => a.ListId == request.ListId)
                                                  select a).FirstOrDefaultAsync();
                    if (List == null)
                    {
                        throw new NotFoundException(request.ListTitle, request.ListId);
                    }
                    else
                    {
                        List.ListTitle = request.ListTitle;
                        List.Type = request.Type;
                        List.TenantId = request.TenantId;
                        List.ListTitle = request.ListTitle;
                        List.IsPublic = request.IsPublic;
                        List.LastModifiedDate = localDateTime.ToUniversalTime();
                        List.LastModifiedBy = request.Id;
                        await _dbContext.SaveChangesAsync();
                    }
                    return List;
                }
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task UpdateCustomListFilter(SaveCustomListFilterCommand request)
        {
            try
            {
                CrmCustomLists? List = await (from a in _dbContext.CrmCustomLists.Where(a => a.ListId == request.ListId)
                                              select a).FirstOrDefaultAsync();
                if (List == null)
                {
                    throw new NotFoundException(request.ListTitle, request.ListId);
                }
                else
                {
                    List.Filter = request.Filter;
                    await _dbContext.SaveChangesAsync();
                }
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
