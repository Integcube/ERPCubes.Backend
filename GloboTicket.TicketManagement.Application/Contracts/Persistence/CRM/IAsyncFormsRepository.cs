using ERPCubes.Application.Features.Crm.FormBuilder.Commands.SaveForm;
using ERPCubes.Application.Features.Crm.FormBuilder.Commands.SaveFormFields;
using ERPCubes.Application.Features.Crm.FormBuilder.Commands.SaveFormResult;
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
        Task<List<GetFormFieldsVm>> GetFormFields(int FormId, int TenantId);
        Task SaveForm(SaveFormCommand request);
        Task SaveFormFields(SaveFormFieldsCommand request);
        Task SaveFormResult(SaveFormResultCommand request);
    }
}
