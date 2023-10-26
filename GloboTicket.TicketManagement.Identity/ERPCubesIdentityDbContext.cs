using ERPCubes.Identity.Models;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace ERPCubes.Identity
{
    public class ERPCubesIdentityDbContext : IdentityDbContext<ApplicationUser>
    {
        public ERPCubesIdentityDbContext()
        {

        }

        public ERPCubesIdentityDbContext(DbContextOptions<ERPCubesIdentityDbContext> options) : base(options)
        {
        }
    }
}
