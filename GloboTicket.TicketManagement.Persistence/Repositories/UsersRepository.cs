using ERPCubes.Application.Contracts.Persistence;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.AppUser.Commands.BulkRestoreUser;
using ERPCubes.Application.Features.AppUser.Commands.DeleteUser;
using ERPCubes.Application.Features.AppUser.Commands.RestoreUser;
using ERPCubes.Application.Features.AppUser.Commands.UpdateUser;
using ERPCubes.Application.Features.AppUser.Queries.GetDeletedUserList;
using ERPCubes.Application.Features.AppUser.Queries.GetUserList;
using ERPCubes.Application.Features.Crm.Product.Queries.GetDeletedProductList;
using ERPCubes.Domain.Entities;
using ERPCubes.Identity;
using ERPCubes.Identity.Models;
using Microsoft.EntityFrameworkCore;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory.Database;

namespace ERPCubes.Persistence.Repositories
{
    public class UsersRepository : BaseRepository<GetUserListVm>, IAsyncUserRepository
    {
        public UsersRepository(ERPCubesDbContext dbContext, ERPCubesIdentityDbContext dbContextIdentity) : base(dbContext, dbContextIdentity)
        {
        }

        public async Task<List<GetUserListVm>> GetUserList(int TenantId, string Id)
        {
            try
            {
                var users = await (from a in _dbContextIdentity.ApplicationUsers.Where(a => a.TenantId == TenantId && a.IsActive == 0)
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
                existingUser.ModifiedOn= DateTime.Now.ToUniversalTime();
                existingUser.ModifiedBy = cm.Id;

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
        

                var users = (from a in _dbContextIdentity.ApplicationUsers.Where(a=>a.IsActive==1 && a.TenantId == TenantId)
                             join b in _dbContextIdentity.ApplicationUsers on a.DeletedBy equals b.Id
                             select new GetDeletedUserListVm

                             {
                                 Id= a.Id,
                                 UserName = a.UserName,
                                 DeletedBy = b.FirstName + " " + b.LastName,
                                 DeletedDate = a.DeletedDate,
                             })
                             .OrderBy(a => a.UserName)
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
                var restoreUser = await (from a in _dbContextIdentity.ApplicationUsers.Where(a => a.TenantId == user.TenantId && a.Id == user.UserId)
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
                if (command.UserId == null)
                {
                    throw new BadRequestException("No user IDs provided for bulk restore.");
                }

                foreach (var userId in command.UserId)
                {
                    await RestoreUser(new RestoreUserCommand
                    {
                        TenantId = command.TenantId, 
                        UserId = userId
                    });
                }
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }





        //public async Task RestoreBulkUser(RestoreBulkUserCommand user)
        //{
        //    try
        //    {
        //        foreach (var userId in user.UserId)
        //        {
        //            var userRestore = await (from a in _dbContextIdentity.ApplicationUsers.Where(a => a.TenantId == user.TenantId && a.Id == userId && a.IsActive == 1)
        //                                     select a)
        //                .FirstOrDefaultAsync();

        //            if (userRestore == null)
        //            {
        //                throw new NotFoundException(nameof(userId), userId);
        //            }

        //            userRestore.IsActive = 0;
        //        }

        //        await _dbContext.SaveChangesAsync();
        //    }
        //    catch (Exception ex)
        //    {
        //        throw new BadRequestException(ex.Message);
        //    }
        //}
    }
}
