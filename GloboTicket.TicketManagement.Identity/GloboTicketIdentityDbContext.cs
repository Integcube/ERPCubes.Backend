using ERPCubes.Identity.Models;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace ERPCubes.Identity
{
    public class GloboTicketIdentityDbContext : IdentityDbContext<ApplicationUser>
    {
        public GloboTicketIdentityDbContext()
        {

        }

        public GloboTicketIdentityDbContext(DbContextOptions<GloboTicketIdentityDbContext> options) : base(options)
        {
        }
    }
}
