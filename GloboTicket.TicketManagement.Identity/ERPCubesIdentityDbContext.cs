using ERPCubes.Identity.Models;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace ERPCubes.Identity
{
    public class ERPCubesIdentityDbContext : IdentityDbContext<ApplicationUser>
    {


        public ERPCubesIdentityDbContext(DbContextOptions<ERPCubesIdentityDbContext> options) : base(options)
        {
        }
        public DbSet<ApplicationUser> ApplicationUsers { get; set; }
        public DbSet<SocialUsers> SocialUsers { get; set; }
        public DbSet<SocialUserTokens> SocialUserTokens { get; set; }
        public DbSet<Tenant> Tenant { get; set; }

    }
}
