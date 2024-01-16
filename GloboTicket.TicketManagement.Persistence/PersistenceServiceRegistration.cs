using ERPCubes.Application.Contracts.Facebook;
using ERPCubes.Application.Contracts.Notifications;
using ERPCubes.Application.Contracts.Persistence;
using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Persistence.Repositories;
using ERPCubes.Persistence.Repositories.CRM;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace ERPCubes.Persistence
{
    public static class PersistenceServiceRegistration
    {
        public static IServiceCollection AddPersistenceServices(this IServiceCollection services, IConfiguration configuration)
        {
            services.AddDbContext<ERPCubesDbContext>(options =>
                options.UseNpgsql(configuration.GetConnectionString("GloboTicketTicketManagementConnectionString")));

            services.AddScoped(typeof(IAsyncRepository<>), typeof(BaseRepository<>));
            services.AddScoped<IAsyncCompanyRepository, CompanyRepository>();
            services.AddScoped<IAsyncIndustryRepository, IndustryRepository>();
            services.AddScoped<IAsyncUserRepository, UsersRepository>();
            services.AddScoped<IAsyncSocialRepository, SocialRepository>();
            services.AddScoped<IAsyncTagsRepository, TagsRepository>();
            services.AddScoped<IAsyncLeadRepository, LeadRepository>();
            services.AddScoped<IAsyncProductRepository, ProductRepository>();
            services.AddScoped<IAsyncNoteRepository, NoteRepository>();
            services.AddScoped<IAsyncTaskRepository, TaskRepository>();
            services.AddScoped<IAsyncCustomListRepository, CustomListRepository>();
            services.AddScoped<IAsyncCalenderRepository, CalenderRepository>();
            services.AddScoped<IAsyncTeamRepository, TeamRepository>();
            services.AddScoped<IAsyncUserActivityRepository, ActivityRepository>();
            services.AddScoped<IAsyncEmailRepository, EmailRepository>();
            services.AddScoped<IAsyncCallRepository, CallRepository>();
            services.AddScoped<IAsyncMeetingRepository, MeetingRepository>();
            services.AddScoped<IAsyncOpportunityRepository, OpportunityRepository>();

            services.AddScoped<IAsyncAdAccountRepository, AdAccountRepository>();
            services.AddScoped<IAsyncCampaignRepository, CampaignRepository>();
            services.AddScoped<IAsyncProjectRepository, ProjectRepository>();
            services.AddScoped<IAsyncReportsRepository, ReportsRepository>();
            services.AddScoped<IAsyncNotificationRepository, NotificationRepository>();

            return services;    
        }
    }
}
