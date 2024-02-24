using ERPCubes.Application.Features.Crm.Call.Commands.Delete;
using ERPCubes.Application.Features.Crm.FormBuilder.Commands.RestoreBulkForm;
using ERPCubes.Application.Features.Crm.FormBuilder.Commands.RestoreForm;
using ERPCubes.Application.Features.Crm.FormBuilder.Commands.SaveForm;
using ERPCubes.Application.Features.Crm.FormBuilder.Commands.SaveFormFields;
using ERPCubes.Application.Features.Crm.FormBuilder.Commands.SaveFormResult;
using ERPCubes.Application.Features.Crm.FormBuilder.Queries.GetDeletedForms;
using ERPCubes.Application.Features.Crm.FormBuilder.Queries.GetFieldTypes;
using ERPCubes.Application.Features.Crm.FormBuilder.Queries.GetFormFields;
using ERPCubes.Application.Features.Crm.FormBuilder.Queries.GetForms;
using ERPCubes.Domain.Entities;

namespace ERPCubes.Application.Contracts.Persistence.CRM
{
    public interface IAsyncFormsRepository: IAsyncRepository<CrmForm>
    {
        Task<List<GetFieldTypesVm>> GetAllFieldTypes();
        Task<List<GetFormsListVm>> GetAllForms(int TenantId);
        Task<List<GetFormFieldsVm>> GetFormFields(int FormId, string TenantGuid);
        Task SaveForm(SaveFormCommand request);
        Task SaveFormFields(SaveFormFieldsCommand request);
        Task SaveFormResult(SaveFormResultCommand request);
        Task Delete(DeleteCommand request);
        Task<List<GetDeletedFormVm>> GetDeletedForms(int TenantId, string Id);
        Task RestoreForm(RestoreFormCommand form);
        Task RestoreBulkForm(ResotreBulkFormCommand form);

    }
}
