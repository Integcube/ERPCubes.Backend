using AutoMapper;
using ERPCubes.Application.Contracts.Persistence;
using ERPCubes.Domain.Entities;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.AppMenu.Queries.GetMenuList
{
    public class GetMenuListQueryHandler : IRequestHandler<GetAppMenuListQuery, AppMenuDto>
    {
        private readonly IAsyncRepository<AppMenus> _appMenuRepository;
        private readonly IMapper _mapper;

        public GetMenuListQueryHandler(IAsyncRepository<AppMenus> appMenuRepository, IMapper mapper)
        {
            _appMenuRepository = appMenuRepository;
            _mapper = mapper;
        }

        public async Task<AppMenuDto> Handle(GetAppMenuListQuery request, CancellationToken cancellationToken)
        {
            var allMenuList = await _appMenuRepository.ListAllAsync();
            var allMenu = _mapper.Map<List<AppMenuVm>>(allMenuList.Where(a => a.ParentId == 0));
            List<AppMenuVm> defaultList = new List<AppMenuVm>();
            foreach (var m in allMenuList)
            {
                if (m.ParentId == 0)
                {
                    AppMenuVm menu = new AppMenuVm();
                    menu.MenuId = m.MenuId;
                    menu.Id = m.Code;
                    menu.Title = m.Title;
                    menu.Subtitle = m.Subtitle;
                    menu.Type = m.Type;
                    menu.Icon = m.Icon;
                    menu.Link = m.Link;
                    menu.Children = new List<AppMenuVm>();
                    foreach (var mc in allMenuList)
                    {
                        if (mc.ParentId == menu.MenuId)
                        {
                            AppMenuVm children = new AppMenuVm();
                            children.MenuId = mc.MenuId;
                            children.Id = mc.Code;
                            children.Title = mc.Title;
                            children.Subtitle = mc.Subtitle;
                            children.Type = mc.Type;
                            children.Icon = mc.Icon;
                            children.Link = mc.Link;
                            children.Children = new List<AppMenuVm>();
                            menu.Children.Add(children);
                            foreach (var mcc in allMenuList)
                            {
                                if (mcc.ParentId == children.MenuId)
                                {
                                    AppMenuVm children2 = new AppMenuVm();
                                    children2.MenuId = mcc.MenuId;
                                    children2.Id = mcc.Code;
                                    children2.Title = mcc.Title;
                                    children2.Subtitle = mcc.Subtitle;
                                    children2.Type = mcc.Type;
                                    children2.Icon = mcc.Icon;
                                    children2.Link = mcc.Link;
                                    children.Children.Add(children2);
                                }
                            }
                        }
                    }
                    defaultList.Add(menu);
                }
            }
            var obj = new AppMenuDto();
            obj.defaultList = defaultList;
            obj.allMenu = (List<AppMenuVm>?)allMenu;
            return obj;
        }


    }
}
