using System;
using System.Linq;
using System.Threading.Tasks;
using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Setting.Commands.Save;
using ERPCubes.Application.Features.Crm.Setting.Queries.GetChatBotSetting;
using ERPCubes.Domain.Entities;
using ERPCubes.Identity;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace ERPCubes.Persistence.Repositories.CRM
{
    public class CrmSettingRepository : IAsyncCrmSettingRepository
    {
        private readonly ERPCubesDbContext _dbContext;
        private readonly ERPCubesIdentityDbContext _dbContextIdentity;

        public CrmSettingRepository(ERPCubesDbContext dbContext, ERPCubesIdentityDbContext dbContextIdentity)
        {
            _dbContext = dbContext;
            _dbContextIdentity = dbContextIdentity;
        }
        public async Task<GetChatBotSettingQueryVm> GetChatbotSetting(int tenantId)
        {
            try
            {
                GetChatBotSettingQueryVm chatbotSetting = await _dbContext.CrmChatbotSetting.Where(c => c.TenantId == tenantId)
            .Select(a => new GetChatBotSettingQueryVm
            {
                
                TenantId = a.TenantId,
                Id = a.Id,
                PrimaryColor= a.PrimaryColor,
                Title= a.Title,

               
            }).FirstOrDefaultAsync();

                return chatbotSetting;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }
        public async Task SaveChatbotSetting(SaveChatbotCommand chatbot)
        {
            try
            {
                DateTime localDateTime = DateTime.Now;
                if (chatbot.Id == -1 || chatbot.Id == 0)
                {
                    CrmChatbotSetting chat = new CrmChatbotSetting
                    {
                        TenantId = chatbot.TenantId,
                        Title = chatbot.Title,
                        CreatedBy = chatbot.UserId,
                        PrimaryColor = chatbot.PrimaryColor,
                        CreatedDate = localDateTime.ToUniversalTime()
                    };
                    await _dbContext.AddAsync(chat);
                    await _dbContext.SaveChangesAsync();
                }
                else
                {
                    var existingChatbot = await _dbContext.CrmChatbotSetting
                        .Where(c => c.Id == chatbot.Id)
                        .FirstOrDefaultAsync();

                    if (existingChatbot == null)
                    {
                        throw new NotFoundException($"Chatbot with ID {chatbot.Id} not found.", chatbot.Id);
                    }
                    else
                    {
                        existingChatbot.Title = chatbot.Title;
                        existingChatbot.PrimaryColor = chatbot.PrimaryColor;
                        existingChatbot.LastModifiedBy = chatbot.UserId;
                        existingChatbot.LastModifiedDate = localDateTime.ToUniversalTime();
                        await _dbContext.SaveChangesAsync();
                    }
                }
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
