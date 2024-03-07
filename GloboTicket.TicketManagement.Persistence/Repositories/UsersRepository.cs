using ERPCubes.Application.Contracts.Persistence;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.AppUser.Commands.BulkRestoreUser;
using ERPCubes.Application.Features.AppUser.Commands.DeleteUser;
using ERPCubes.Application.Features.AppUser.Commands.RestoreUser;
using ERPCubes.Application.Features.AppUser.Commands.UpdateUser;
using ERPCubes.Application.Features.AppUser.Queries.GetDeletedUserList;
using ERPCubes.Application.Features.AppUser.Queries.LazyGetUserList;
using ERPCubes.Application.Features.AppUser.Queries.GetUserList;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadList;
using ERPCubes.Application.Features.Crm.Product.Queries.GetDeletedProductList;
using ERPCubes.Domain.Common;
using ERPCubes.Domain.Entities;
using ERPCubes.Identity;
using ERPCubes.Identity.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory.Database;

namespace ERPCubes.Persistence.Repositories
{
    public class UsersRepository : BaseRepository<GetUserListVm>, IAsyncUserRepository
    {
        public UsersRepository(ERPCubesDbContext dbContext, ERPCubesIdentityDbContext dbContextIdentity) : base(dbContext, dbContextIdentity)
        {
        }
        public async Task<List<GetUserListVm>> GetUserList (GetUserListQuery request)
        {
            try
            {
                var users = await(from a in _dbContextIdentity.ApplicationUsers.Where(a => a.TenantId == request.TenantId && a.IsActive == 0)
                                  select new GetUserListVm
                                  {
                                      Id = a.Id,
                                      FirstName = a.FirstName,
                                      LastName = a.LastName,
                                      Email = a.Email,
                                      UserName = a.UserName,
                                      PhoneNumber = a.PhoneNumber,
                                      Name = a.FirstName + " " + a.LastName,
                                      IsActive = a.IsActive,
                                  }).OrderBy(A => A.FirstName).ToListAsync();
                return users;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }


        public async Task<LazyGetUserListVm> LazyGetUserList(LazyGetUserListQuery obj)
        {
            try
            {
                var query = _dbContextIdentity.ApplicationUsers
                             .Where(a => a.TenantId == obj.TenantId && a.IsActive == 0)
                             .Select(a => new LazyGetUserList
                             {
                                 Id = a.Id,
                                 FirstName = a.FirstName,
                                 LastName = a.LastName,
                                 Email = a.Email,
                                 UserName = a.UserName,
                                 PhoneNumber = a.PhoneNumber,
                                 Name = a.FirstName + " " + a.LastName,
                                 IsActive = a.IsActive,
                             });


                if (!string.IsNullOrEmpty(obj.Search))
                {
                    var searchTerm = obj.Search.ToLower();
                    query = query.Where(a =>
                        a.FirstName.ToLower().Contains(searchTerm) ||
                        a.LastName.ToLower().Contains(searchTerm) ||
                        a.Email.ToLower().Contains(searchTerm) ||
                        a.UserName.ToLower().Contains(searchTerm) ||
                        a.PhoneNumber.ToLower().Contains(searchTerm)
                    );
                }

                if (string.IsNullOrEmpty(obj.Sort))
                {
                    query = obj.Order.ToLower() == "desc" ? query.OrderByDescending(a => a.FirstName) : query.OrderBy(a => a.FirstName);
                }
                else { 
                    switch (obj.Sort.ToLower())
                    {
                        case "firstname":
                            query = obj.Order.ToLower() == "desc" ? query.OrderByDescending(a => a.FirstName) : query.OrderBy(a => a.FirstName);
                            break;
                        case "lastname":
                            query = obj.Order.ToLower() == "desc" ? query.OrderByDescending(a => a.LastName) : query.OrderBy(a => a.LastName);
                            break;
                        case "email":
                            query = obj.Order.ToLower() == "desc" ? query.OrderByDescending(a => a.Email) : query.OrderBy(a => a.Email);
                            break;
                        case "username":
                            query = obj.Order.ToLower() == "desc" ? query.OrderByDescending(a => a.UserName) : query.OrderBy(a => a.UserName);
                            break;
                        case "phonenumber":
                            query = obj.Order.ToLower() == "desc" ? query.OrderByDescending(a => a.PhoneNumber) : query.OrderBy(a => a.PhoneNumber);
                            break;

                    }
            }


                int leadLength = query.Count();

            int begin = obj.Page * obj.Size;
            int end = Math.Min((obj.Size * (obj.Page + 1)), leadLength);
            int lastPage = Math.Max((int)Math.Ceiling((double)leadLength / obj.Size), 1);


            List<LazyGetUserList> querylist = await query.Skip(begin).Take(end - begin).ToListAsync();


            PaginationVm pagination = new PaginationVm
            {
                Length = leadLength,
                Size = obj.Size,
                Page = obj.Page,
                LastPage = lastPage,
                StartIndex = begin,
                EndIndex = end - 1
            };

              LazyGetUserListVm response = new LazyGetUserListVm
                {
                UserList = querylist,
                PaginationVm = pagination
            };

            return response;
        }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
    }

}

public async Task UpdateUser(UpdateUserCommand updateUser)
{
    try
    {
        var existingUser = await (from a in _dbContextIdentity.ApplicationUsers.Where(a => a.TenantId == updateUser.TenantId && a.Id == updateUser.Id)
                                  select a).FirstOrDefaultAsync();
        existingUser.FirstName = updateUser.FirstName;
        existingUser.LastName = updateUser.LastName;
        existingUser.UserName = updateUser.UserName;
        existingUser.Email = updateUser.Email;
        existingUser.PhoneNumber = updateUser.PhoneNumber;
        await _dbContextIdentity.SaveChangesAsync();
    }
    catch (Exception ex)
    {
        throw new BadRequestException(ex.Message);
    }
}

public async Task DeleteUser(DeleteUserCommand cm)
{
    try
    {
        var existingUser = await (from a in _dbContextIdentity.ApplicationUsers.Where(a => a.TenantId == cm.TenantId && a.Id == cm.UserId)
                                  select a).FirstOrDefaultAsync();

        existingUser.IsActive = 1;
        existingUser.ModifiedOn = DateTime.Now.ToUniversalTime();
        existingUser.ModifiedBy = cm.Id;
        existingUser.DeletedBy = cm.Id;
        existingUser.DeletedDate = DateTime.Now.ToUniversalTime();

        await _dbContextIdentity.SaveChangesAsync();

    }
    catch (Exception ex)
    {
        throw new BadRequestException(ex.Message);
    }
}

public async Task<List<GetDeletedUserListVm>> GetDeletedUsers(int TenantId, string Id)
{
    try
    {


        var users = (from a in _dbContextIdentity.ApplicationUsers.Where(a => a.IsActive == 1 && a.TenantId == TenantId)
                     join b in _dbContextIdentity.ApplicationUsers on a.DeletedBy equals b.Id
                     select new GetDeletedUserListVm

                     {
                         Id = a.Id,
                         Title = a.FirstName + " " + a.LastName,
                         DeletedBy = b.FirstName + " " + b.LastName,
                         DeletedDate = a.DeletedDate,
                     })
                     .OrderBy(a => a.Title)
                     .ToList();

        return users;
    }
    catch (Exception ex)
    {
        throw new BadRequestException(ex.Message);
    }
}


public async Task RestoreUser(RestoreUserCommand user)
{
    try
    {
        var restoreUser = await (from a in _dbContextIdentity.ApplicationUsers.Where(a => a.TenantId == user.User.TenantId && a.Id == user.User.Id)
                                 select a).FirstOrDefaultAsync();
        restoreUser.IsActive = 0;


        await _dbContextIdentity.SaveChangesAsync();
    }
    catch (Exception ex)
    {
        throw new BadRequestException(ex.Message);
    }
}

public async Task RestoreBulkUser(RestoreBulkUserCommand command)
{
    try
    {

        foreach (var userId in command.User.Id)
        {
            var product = await _dbContextIdentity.ApplicationUsers
               .Where(p => p.Id == userId && p.IsActive == 1)
               .FirstOrDefaultAsync();

            if (product == null)
            {
                throw new NotFoundException(nameof(userId), userId);
            }

            product.IsActive = 0;
        }

        await _dbContextIdentity.SaveChangesAsync();
    }
    catch (Exception ex)
    {
        throw new BadRequestException(ex.Message);
    }
}
    }
}
