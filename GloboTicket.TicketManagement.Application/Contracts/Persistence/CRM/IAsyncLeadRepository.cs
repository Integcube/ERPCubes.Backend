using ERPCubes.Application.Features.Crm.Company.Commands.SaveCompany;
using ERPCubes.Application.Features.Crm.Lead.Commands.BulkAssignLeads;
using ERPCubes.Application.Features.Crm.Lead.Commands.BulkRestoreLeads;
using ERPCubes.Application.Features.Crm.Lead.Commands.BulkSaveLead;
using ERPCubes.Application.Features.Crm.Lead.Commands.ChangeBulkLeadStatus;
using ERPCubes.Application.Features.Crm.Lead.Commands.ChangeLeadStatus;
using ERPCubes.Application.Features.Crm.Lead.Commands.DeleteBulkLeads;
using ERPCubes.Application.Features.Crm.Lead.Commands.DeleteLead;
using ERPCubes.Application.Features.Crm.Lead.Commands.RestoreDeletedLeads;
using ERPCubes.Application.Features.Crm.Lead.Commands.SaveCopyQuestion;
using ERPCubes.Application.Features.Crm.Lead.Commands.SaveLead;
using ERPCubes.Application.Features.Crm.Lead.Commands.SaveLeadScore;
using ERPCubes.Application.Features.Crm.Lead.Commands.SaveLeadScoreQuestion;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetCalculateleadScore;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetDeletedLeads;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadAttachments;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadByMonth;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadList;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadOwnerWiseReport;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetleadPiplineReport;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadReport;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadScoreQuestions;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadSource;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadSourceWiseReport;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadStatus;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetScoreListQuery;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetStatusWiseLeads;
using ERPCubes.Application.Features.Tags.Queries.GetTagsList;
using ERPCubes.Domain.Entities;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Contracts.Persistence.CRM
{
    public interface IAsyncLeadRepository:IAsyncRepository<CrmLead>
    {
        Task<List<GetLeadVm>> GetAllLeads(int TenantId, string Id);
        Task<List<GetDeletedLeadsVm>> GetDeletedLeads(int TenantId, string Id);
        Task<List<GetLeadStatusListVm>> GetAllLeadStatus(int TenantId, string Id);
        Task<List<GetLeadSourceListVm>> GetAllLeadSource(int TenantId, string Id);
        Task<List<GetLeadReportVm>> GetLeadReport(int TenantId, string Id, DateTime startDate, DateTime endDate, int prodId);
        Task<List<GetLeadAttachmentsVm>> GetLeadAttachments(int TenantId, string Id, int LeadId, int ContactTypeId);
        Task DeleteLead(DeleteLeadCommand leadId);
        Task DeleteBulkLead(DeleteBulkLeadsCommand leadIds);
        
        Task SaveLead(string Id, int TenantId, SaveLeadDto Lead);
        Task RestoreDeletedLeads(RestoreDeletedLeadsCommand request);
        Task<List<GetLeadByMonthListVm>> GetLeadByMonth(int TenantId, string Id, int ProductId, int SourceId, string UserId, string Year);
        Task SaveLeadBulk(SaveBulkLeadCommand request);
        Task<List<GetleadPiplineReportVm>> GetleadPiplineReport(GetleadPiplineReportQuery obj);
        Task<List<GetLeadSourceWiseVm>> GetLeadSourceWise(int TenantId, string Id, DateTime startDate, DateTime endDate, int sourceId);
        Task<List<GetLeadOwnerWiseVm>> GetLeadOwnerWise(int TenantId, string Id, DateTime startDate, DateTime endDate, string leadOwner, int sourceId, int status);
        Task ChangeLeadStatus(ChangeLeadStatusCommand oj);
        Task ChangeBulkLeadStatus(ChangeBulkLeadStatusCommand oj);
        Task<List<GetStatusWiseLeadsVm>> GetStatusWiseLeads(GetStatusWiseLeadsQuery request);
        Task<List<GetScoreListVm>> GetleadScoreList(int TenantId, int LeadId);
        Task SaveleadScore(SaveLeadScoreCommand Leads);
        Task<GetCalculateleadScoreListVm> GetCalculateleadScore(GetCalculateleadScoreQuery obj);
        Task RestoreBulkLead(RestoreBulkLeadCommand leadId);
        Task BulkAssignLeads(BulkAssignLeadsCommand oj);

        Task<List<GetLeadScoreQuestionsVm>> GetLeadScoreQuestions(int TenantId, int ProductId);
        Task SaveLeadScoreQuestion(SaveLeadScoreQuestionCommand request);
        Task DeleteLeadScoreQuestion(int TenantId, int QuestionId);
        Task SaveCopyQuestion(SaveCopyQuestionCommand request);
    }
}
