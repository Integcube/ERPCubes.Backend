using ERPCubes.Application.Contracts.Persistence;
using ERPCubes.Persistence.Repositories;
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

            //services.AddScoped<ICategoryRepository, CategoryRepository>();
            //services.AddScoped<IEventRepository, EventRepository>();
            //services.AddScoped<IOrderRepository, OrderRepository>();

            return services;    
        }
    }
}
