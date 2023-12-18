using ERPCubes.Application.Features.Crm.Opportunity.Commands.DeleteOpportunity;
using ERPCubes.Application.Features.Crm.Opportunity.Commands.SaveOpportunity;
using ERPCubes.Application.Features.Crm.Opportunity.Queries.GetOpportunity;
using ERPCubes.Application.Features.Crm.Opportunity.Queries.GetOpportuntiySource;
using ERPCubes.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Contracts.Persistence.CRM
{
    public interface IAsyncOpportunityRepository : IAsyncRepository<CrmOpportunity>
    {
        Task<List<GetOpportunityVm>> GetOpportunity(GetOpportunityQuery query);
        Task<List<GetOpportunitySourceVm>> GetOpportunitySource(GetOpportunitySourceQuery query);
        Task SaveOpportunity(SaveOpportunityCommand command);
        Task DeleteOpportunity(DeleteOpportunityCommand query);
    }
}
