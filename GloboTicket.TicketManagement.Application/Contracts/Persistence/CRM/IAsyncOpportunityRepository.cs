using ERPCubes.Application.Features.Crm.Lead.Queries.GetDeletedLeads;
using ERPCubes.Application.Features.Crm.Opportunity.Commands.ChangeOpportunityStatus;
using ERPCubes.Application.Features.Crm.Opportunity.Commands.DeleteOpportunity;
using ERPCubes.Application.Features.Crm.Opportunity.Commands.RestoreBulkOpportunity;
using ERPCubes.Application.Features.Crm.Opportunity.Commands.RestoreOpportunity;
using ERPCubes.Application.Features.Crm.Opportunity.Commands.SaveOpportunity;
using ERPCubes.Application.Features.Crm.Opportunity.Queries.GetDeletedOpportunity;
using ERPCubes.Application.Features.Crm.Opportunity.Queries.GetOpportunity;
using ERPCubes.Application.Features.Crm.Opportunity.Queries.GetOpportunityAttachments;
using ERPCubes.Application.Features.Crm.Opportunity.Queries.GetOpportunityStatus;
using ERPCubes.Application.Features.Crm.Opportunity.Queries.GetOpportuntiySource;
using ERPCubes.Domain.Entities;
using MediatR;
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
        Task<List<GetOpportunityStatusVm>> GetOpportunityStatus(GetOpportunityStatusQuery query);
        Task SaveOpportunity(SaveOpportunityCommand command);
        Task DeleteOpportunity(DeleteOpportunityCommand query);
        Task RestoreOpportunity(RestoreOpportunityCommand command);
        Task<List<GetDeletedOpportunityVm>> GetDeletedOpportunity(int TenantId, string Id);
        Task RestoreBulkOpportunity(RestoreBulkOpportunityCommand command);
        Task<List<GetOpportunityAttachmentsVm>> GetOpportunityAttachments(GetOpportunityAttachmentsQuery request);
        Task ChangeOpportunityStatus(ChangeOpportunityStatusCommand request);
    }
}
