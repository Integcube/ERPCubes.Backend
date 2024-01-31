using ERPCubes.Application.Contracts.Persistence;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.AppUser.Commands.DeleteUser;
using ERPCubes.Application.Features.AppUser.Commands.UpdateUser;
using ERPCubes.Application.Features.AppUser.Queries.GetUserList;
using ERPCubes.Domain.Entities;
using ERPCubes.Identity;
using Microsoft.EntityFrameworkCore;

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
    }
}
