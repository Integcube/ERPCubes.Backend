using ERPCubes.Application.Features.Crm.Calender.Commands.DeleteCalendarEvent;
using ERPCubes.Application.Features.Crm.Calender.Commands.SaveCalendarEvent;
using ERPCubes.Application.Features.Crm.Calender.Queries.GetCalendarTypeList;
using ERPCubes.Application.Features.Crm.Calender.Queries.GetCalenderList;
using ERPCubes.Application.Features.Crm.Company.Queries.GetCompanyList;
using ERPCubes.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Contracts.Persistence.CRM
{
    public interface IAsyncCalenderRepository : IAsyncRepository<CrmCalenderEvents>
    {
        Task<List<GetCalenderListVm>> GetAllList(string Id, int TenantId);
        Task<List<GetCalendarTypeListVm>> GetCalendarEventType(GetCalendarTypeListQuery request);
        Task DeleteCalendarEvent(DeleteCalendarEventCommand request);
        Task SaveCalendarEvent(SaveCalendarEventCommand request);
    }
}
