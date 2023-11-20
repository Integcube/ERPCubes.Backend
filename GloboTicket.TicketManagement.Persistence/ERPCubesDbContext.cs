using ERPCubes.Application.Contracts;
using ERPCubes.Domain.Common;
using ERPCubes.Domain.Entities;
using Microsoft.EntityFrameworkCore;

namespace ERPCubes.Persistence
{
    public class ERPCubesDbContext: DbContext
    {
        private readonly ILoggedInUserService? _loggedInUserService;

        public ERPCubesDbContext(DbContextOptions<ERPCubesDbContext> options, ILoggedInUserService loggedInUserService)
            : base(options)
        {
            _loggedInUserService = loggedInUserService;
        }

        public DbSet<AppMenus> AppMenus { get; set; }
        public DbSet<CrmLead> CrmLead { get; set; }
        public DbSet<CrmCompany> CrmCompany { get; set; }
        public DbSet<CrmIndustry> CrmIndustry { get; set; }
        public DbSet<CrmTags> CrmTags { get; set; }
        public DbSet<CrmLeadStatus> CrmLeadStatus { get; set; }
        public DbSet<CrmLeadSource> CrmLeadSource { get; set; }
        public DbSet<CrmProduct> CrmProduct { get; set; }
        public DbSet<CrmNote> CrmNote { get; set; }
        public DbSet<CrmNoteTags> CrmNoteTags { get; set; }
        public DbSet<CrmNoteTasks> CrmNoteTasks { get; set; }
        public DbSet<CrmTask> CrmTask { get; set; }
        public DbSet<CrmTaskTags> CrmTaskTags { get; set; }
        public DbSet<CrmTaskPriority> CrmTaskPriority { get; set; }
        public DbSet<CrmTaskStatus> CrmTaskStatus { get; set; }

    }
}
