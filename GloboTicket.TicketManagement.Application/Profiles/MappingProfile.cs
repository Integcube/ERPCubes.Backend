using AutoMapper;
using ERPCubes.Application.Features.AppMenu.Queries.GetMenuList;
using ERPCubes.Application.Features.Crm.Company.Queries.GetCompanyList;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadList;
using ERPCubes.Application.Features.Notification.Commands.SaveNotification;
using ERPCubes.Application.Features.Tickets.Commands.SendMessage;
using ERPCubes.Application.Features.Tickets.Queries.GetAllTickets;
using ERPCubes.Domain.Entities;

namespace ERPCubes.Application.Profiles
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {
            CreateMap<AppMenus, AppMenuVm>()
              .ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Code));
            CreateMap<CrmLead, GetLeadVm>();
            CreateMap<CrmCompany, GetCompanyVm>();
            CreateMap<Notification, SaveNotificationVm>();
            CreateMap<GetAllTicketsVm, SendMessageCommand>();
        }
    }
}
