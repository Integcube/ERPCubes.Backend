using ERPCubes.Application.Contracts;
using ERPCubes.Application.Features.CheckList.ChecklistReports.Queries.ExecutedLeadChecklistReport;
using ERPCubes.Application.Features.Crm.Activity.Queries.GetUserActivityReport;
using ERPCubes.Application.Features.Crm.Call.Queries.GetCallScenariosList;
using ERPCubes.Application.Features.Crm.Checklist.Queries.CheckListReport;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadByMonth;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadCountByMonth;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadCountByOwner;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadCountSummary;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadOwnerWiseReport;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetleadPiplineReport;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadReport;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadSourceByCount;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadSourceWiseReport;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadStatus;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetTotalLeadCount;
using ERPCubes.Application.Features.Crm.Reports.Queries.GetCampaigWiseReport;
using ERPCubes.Domain.Common;
using ERPCubes.Domain.Entities;
using Microsoft.EntityFrameworkCore;

namespace ERPCubes.Persistence
{
    public class ERPCubesDbContext: DbContext
    {
        private readonly ILoggedInUserService _loggedInUserService;

        public ERPCubesDbContext(DbContextOptions<ERPCubesDbContext> options, ILoggedInUserService loggedInUserService)
            : base(options)
        {
            _loggedInUserService = loggedInUserService;
        }
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<GetLeadReportVm>().HasNoKey().ToView("leadstatusfn");
            modelBuilder.Entity<GetleadPiplineReportVm>().HasNoKey().ToView("crmleadstagewiserpt");
            modelBuilder.Entity<GetLeadSourceWiseVm>().HasNoKey().ToView("crmleadsourcewiserpt");
            modelBuilder.Entity<GetUserActivityReportVm>().HasNoKey().ToView("calculateleadevent");
            modelBuilder.Entity<GetLeadOwnerWiseVm>().HasNoKey().ToView("crmleadownerwiserpt");
            modelBuilder.Entity<GetCampaigWiseReportQueryVm>().HasNoKey().ToView("crmcampaignwiserpt");
            modelBuilder.Entity<GetLeadByMonthListVm>().HasNoKey().ToView("CRMLeadMonthlyStatusWise");
            modelBuilder.Entity<GetLeadCountByOwnerVm>().HasNoKey().ToView("CrmLeadCountByOwnerGrph");
            modelBuilder.Entity<GetLeadCountByMonthVm>().HasNoKey().ToView("CrmLeadByMonthCountGrph");
            modelBuilder.Entity<GetLeadSourceByCountVm>().HasNoKey().ToView("CrmLeadSourceCountGrph");
            modelBuilder.Entity<GetTotalLeadCountVm>().HasNoKey().ToView("CrmCountleadsGrp");
            modelBuilder.Entity<GetLeadCountSummaryVm>().HasNoKey().ToView("CrmTotalLeadSummaryGrph");
            modelBuilder.Entity<CheckListReportVm>().HasNoKey().ToView("CkCheckListReport");
            modelBuilder.Entity<ExecutedLeadChecklistReportVm>().HasNoKey().ToView("CkExcutedCheckListLeadWiseRpt");





            base.OnModelCreating(modelBuilder);
        }
        public DbSet<AppMenus> AppMenus { get; set; }
        public DbSet<AppUser> AppUser { get; set; }
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
        public DbSet<CrmOpportunity> CrmOpportunity { get; set; }
        public DbSet<CrmOpportunitySource> CrmOpportunitySource { get; set; }
        public DbSet<CrmOpportunityStatus> CrmOpportunityStatus { get; set; }
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
        public DbSet<GetCallScenariosVm> GetCallScenariosVm { get; set; }
        public DbSet<CrmMeeting> CrmMeeting { get; set; }
        public DbSet<GetLeadReportVm> GetCrmLeads { get; set; }
        public DbSet<CrmAdAccount> CrmAdAccount { get; set; }
        public DbSet<GetUserActivityReportVm> GetCrmUserActivity {  get; set; }
        public DbSet<CrmCampaign> CrmCampaign { get; set; }
        public DbSet<GetleadPiplineReportVm> GetleadPiplineReportVm { get; set; }
        public DbSet<CrmProject> CrmProject { get; set; }
        public DbSet<GetLeadSourceWiseVm> GetCrmLeadSourceWise { get; set; }
        public DbSet<GetLeadOwnerWiseVm> GetCrmLeadOwnerWise { get; set; }
        public DbSet<GetCampaigWiseReportQueryVm> GetCampaigWiseReportQueryVm { get; set; }
        public DbSet<Notification> Notification { get; set; }
        public DbSet<CrmForm> CrmForm { get; set; }
        public DbSet<CrmFormFields> CrmFormFields { get; set; }
        public DbSet<CrmFormFieldTypes> CrmFormFieldTypes { get; set; }
        public DbSet<CrmFormResults> CrmFormResults { get; set; }
        public DbSet<Ticket> Ticket { get; set; }
        public DbSet<Conversation> Conversation { get; set; }
        public DbSet<TicketPriority> TicketPriority { get; set; }
        public DbSet<TicketStatus> TicketStatus { get; set; }
        public DbSet<TicketType> TicketType { get; set; }
        public DbSet<DocumentLibrary> DocumentLibrary { get; set; }
        public DbSet<CrmLeadScore> CrmLeadScore { get; set; }

        public DbSet<CrmIScoringQuestion> CrmIScoringQuestion { get; set; }
        public DbSet<CrmChatbotSetting> CrmChatbotSetting { get; set; }
        public DbSet<GetLeadByMonthListVm> GetLeadByMonthListVm { get; set; }

        public DbSet<GetLeadCountByOwnerVm> GetLeadCountByOwner { get; set; }
        public DbSet<GetLeadCountByMonthVm> GetLeadCountByMonth { get; set; }
        public DbSet<GetLeadSourceByCountVm> GetLeadSourceByCount { get; set; }
        public DbSet<GetTotalLeadCountVm> GetTotalLeadCount { get; set; }
        public DbSet<GetLeadCountSummaryVm> GetLeadCountSummary { get; set; }
        public DbSet<CrmDashboard> CrmDashboard { get; set; }
        public DbSet<CKExecCheckList> CKExecCheckList { get; set; }
        public DbSet<CKCheckPoint> CKCheckPoint { get; set; }
        public DbSet<CkCheckList> CkCheckList { get; set; }
        public DbSet<CkUserCheckPoint> CkUserCheckPoint { get; set; }
        public DbSet<CkUserCheckPointExec> CkUserCheckPointExec { get; set; }
        public DbSet<CkContactCheckList> CkContactCheckList { get; set; }
        public DbSet<CkContactCheckListExec> CkContactCheckListExec { get; set; }
        public DbSet<CheckListReportVm> CheckListReportVm { get; set; }
        public DbSet<ExecutedLeadChecklistReportVm> ExecutedLeadChecklistReport { get; set; }


    }
}
