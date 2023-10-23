using AutoMapper;
using ERPCubes.Application.Features.AppMenu.Queries.GetMenuList;
using ERPCubes.Application.Features.Lead.Queries.GetLeadList;
using ERPCubes.Domain.Entities;

namespace ERPCubes.Application.Profiles
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {
            CreateMap<AppMenus, AppMenuVm>()
              .ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Code));
            CreateMap<Leads, LeadVm>();
        }
    }
}
