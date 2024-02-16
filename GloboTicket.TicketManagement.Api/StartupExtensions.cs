using ERPCubes.Api.Middleware;
using ERPCubes.Api.Services;
using ERPCubes.Api.Utility;
using ERPCubes.Application;
using ERPCubes.Application.Contracts;
using ERPCubes.Identity;
using ERPCubes.Infrastructure;
using ERPCubes.Persistence;
using ERPCubesApi.Hubs;
using ERPCubesApi.Services;
using Microsoft.OpenApi.Models;
using System.Text.Json;
//using Serilog;

namespace ERPCubes.Api
{
    public static class StartupExtensions
    {
        public static WebApplication ConfigureServices(
        this WebApplicationBuilder builder)
        {
            AddSwagger(builder.Services);

            builder.Services.AddApplicationServices();
            builder.Services.AddInfrastructureServices(builder.Configuration);
            builder.Services.AddPersistenceServices(builder.Configuration);
            builder.Services.AddIdentityServices(builder.Configuration);

            builder.Services.AddScoped<ILoggedInUserService, LoggedInUserService>();
            //builder.Services.AddScoped<FileServerService>();
            builder.Services.AddHttpContextAccessor();
            builder.Services.AddControllers().AddJsonOptions(options =>
            {
                options.JsonSerializerOptions.PropertyNamingPolicy = JsonNamingPolicy.CamelCase;
            });
            builder.Services.AddCors(options =>
            {
                options.AddPolicy("Open", builder => builder
                    .AllowAnyOrigin()
                    .AllowAnyHeader()
                    .AllowAnyMethod()
                    );
            });
           
      
            builder.Services.AddSignalR(o => o.EnableDetailedErrors = true);

            return builder.Build();

        }

        public static WebApplication ConfigurePipeline(this WebApplication app)
        {

            if (app.Environment.IsDevelopment())
            {
                app.UseSwagger();
                app.UseSwaggerUI(c =>
                {
                    c.SwaggerEndpoint("/swagger/v1/swagger.json", "ERPCubes API");
                });
            }

            app.UseHttpsRedirection();

            app.UseCors("Open");
            app.UseAuthentication();

            app.UseCustomExceptionHandler();



            app.UseAuthorization();


            app.MapControllers();

            app.MapHub<TicketHub>("/ticketHub").RequireCors("Open");
            //app.MapHub<ChatHub>("/chatHub").RequireCors("Open");

            return app;

        }

        private static void AddSwagger(IServiceCollection services)
        {
            services.AddSwaggerGen(c =>
            {
                c.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
                {
                    Description = @"JWT Authorization header using the Bearer scheme. \r\n\r\n 
                      Enter 'Bearer' [space] and then your token in the text input below.
                      \r\n\r\nExample: 'Bearer 12345abcdef'",
                    Name = "Authorization",
                    In = ParameterLocation.Header,
                    Type = SecuritySchemeType.ApiKey,
                    Scheme = "Bearer"
                });

                c.AddSecurityRequirement(new OpenApiSecurityRequirement()
                  {
                    {
                      new OpenApiSecurityScheme
                      {
                        Reference = new OpenApiReference
                          {
                            Type = ReferenceType.SecurityScheme,
                            Id = "Bearer"
                          },
                          Scheme = "oauth2",
                          Name = "Bearer",
                          In = ParameterLocation.Header,

                        },
                        new List<string>()
                      }
                    });

                c.SwaggerDoc("v1", new OpenApiInfo
                {
                    Version = "v1",
                    Title = "ERPCubes API",

                });

                c.OperationFilter<FileResultContentTypeOperationFilter>();
            });
        }
    }
}