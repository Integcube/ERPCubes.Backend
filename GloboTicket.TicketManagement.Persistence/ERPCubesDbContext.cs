using ERPCubes.Application.Contracts;
using ERPCubes.Application.Features.Crm.Activity.Queries.GetUserActivityReport;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadReport;
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
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<GetLeadReportVm>().HasNoKey().ToView("get_crmleads");
            modelBuilder.Entity<GetUserActivityReportVm>().HasNoKey().ToView("calculateleadevent");
            base.OnModelCreating(modelBuilder);
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
        public DbSet<CrmCustomLists> CrmCustomLists { get; set; }
        public DbSet<CrmCalenderEvents> CrmCalenderEvents { get; set; }
        public DbSet<CrmCalendarEventsType> CrmCalendarEventsType { get; set; }
        public DbSet<CrmTeam> CrmTeam { get; set; }
        public DbSet<CrmTeamMember> CrmTeamMember { get; set; }
        public DbSet<CrmUserActivityLog> CrmUserActivityLog { get; set; }
        public DbSet<CrmUserActivityType> CrmUserActivityType { get; set; }
        public DbSet<CrmEmail> CrmEmail { get; set; }
        public DbSet<CrmCall> CrmCall { get; set; }
        public DbSet<CrmMeeting> CrmMeeting { get; set; }
        public DbSet<GetLeadReportVm> GetCrmLeads { get; set; }
        public DbSet<CrmAdAccount> CrmAdAccount { get; set; }
        public DbSet<GetUserActivityReportVm> GetCrmUserActivity {  get; set; }
    }
}
