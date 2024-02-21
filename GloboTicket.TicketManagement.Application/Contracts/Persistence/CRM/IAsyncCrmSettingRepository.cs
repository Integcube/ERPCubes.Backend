
using ERPCubes.Application.Features.Crm.Setting.Commands.Save;
using ERPCubes.Application.Features.Crm.Setting.Queries.GetChatBotSetting;
using ERPCubes.Domain.Entities;
using MediatR;
namespace ERPCubes.Application.Contracts.Persistence.CRM
{
    public interface IAsyncCrmSettingRepository 
    {
        Task SaveChatbotSetting(SaveChatbotCommand chatbot);
        Task<GetChatBotSettingQueryVm> GetChatbotSetting(int TenantId);
    }
}
