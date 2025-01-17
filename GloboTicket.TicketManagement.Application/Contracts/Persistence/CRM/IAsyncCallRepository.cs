using ERPCubes.Application.Features.Crm.Call.Commands.DeleteCall;
using ERPCubes.Application.Features.Crm.Call.Commands.SaveCall;
using ERPCubes.Application.Features.Crm.Call.Queries.GetCallList;
using ERPCubes.Application.Features.Crm.Call.Queries.GetCallScenariosList;
using ERPCubes.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Contracts.Persistence.CRM
{
    public interface IAsyncCallRepository : IAsyncRepository<CrmCall>
    {
        Task<List<GetCallVm>> GetAllList(string Id, int TenantId, int ContactTypeId, int ContactId);
        Task DeleteCall(DeleteCallCommand callId);
        Task SaveCall(SaveCallCommand call);
        Task<List<GetCallScenariosVm>> ScenariosList();
        
    }
}
