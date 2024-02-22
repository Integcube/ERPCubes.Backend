using AutoMapper;
using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Call.Commands.Delete;
using ERPCubes.Application.Features.Crm.Call.Commands.DeleteCall;
using ERPCubes.Application.Features.Crm.FormBuilder.Commands.RestoreBulkForm;
using ERPCubes.Application.Features.Crm.FormBuilder.Commands.RestoreForm;
using ERPCubes.Application.Features.Crm.FormBuilder.Commands.SaveForm;
using ERPCubes.Application.Features.Crm.FormBuilder.Commands.SaveFormFields;
using ERPCubes.Application.Features.Crm.FormBuilder.Commands.SaveFormResult;
using ERPCubes.Application.Features.Crm.FormBuilder.Queries.GetDeletedForms;
using ERPCubes.Application.Features.Crm.FormBuilder.Queries.GetFieldTypes;
using ERPCubes.Application.Features.Crm.FormBuilder.Queries.GetFormFields;
using ERPCubes.Application.Features.Crm.FormBuilder.Queries.GetForms;
using ERPCubes.Application.Features.Crm.Product.Queries.GetDeletedProductList;
using ERPCubes.Domain.Entities;
using ERPCubes.Identity;
using MediatR;
using Microsoft.EntityFrameworkCore;
using System.Text;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory.Database;
using static Npgsql.PostgresTypes.PostgresCompositeType;

namespace ERPCubes.Persistence.Repositories.CRM
{
    public class FormsRepository : BaseRepository<CrmForm>, IAsyncFormsRepository
    {
        public FormsRepository(
            ERPCubesDbContext _dbContext,
            ERPCubesIdentityDbContext _dbContextIdentity)
            : base(_dbContext, _dbContextIdentity)
        { }
        public async Task<List<GetFieldTypesVm>> GetAllFieldTypes()
        {
            try
            {
                DateTime localDateTime = DateTime.Now;

                List<GetFieldTypesVm> obj = await (
                            from a in _dbContext.CrmFormFieldTypes
                            .Where(a => a.IsDeleted == 0)
                            select new GetFieldTypesVm
                            {
                                TypeId = a.TypeId,
                                TypeName = a.TypeName,
                                TypeLabel = a.TypeLabel,
                                Icon = a.Icon,
                            }).OrderBy(id => id.TypeId).ToListAsync();
                return obj;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }
        public async Task<List<GetFormsListVm>> GetAllForms(int TenantId)
        {
            try
            {
                List<GetFormsListVm> obj = await (
                            from a in _dbContext.CrmForm
                            .Where(a => a.IsDeleted == 0 && a.TenantId == TenantId)
                            select new GetFormsListVm
                            {
                                FormId = a.FormId,
                                Name = a.Name,
                                Description = a.Description,
                                Code = a.Code,
                                //CreatedBy = a.CreatedBy,
                                //CreatedDate = a.CreatedDate,
                                //TenantId = a.TenantId,
                            }).ToListAsync();
                return obj;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }
        public async Task<List<GetFormFieldsVm>> GetFormFields(int FormId, int TenantId)
        {
            try
            {
                DateTime localDateTime = DateTime.Now;

                List<GetFormFieldsVm> obj = await (
                            from a in _dbContext.CrmFormFields
                            .Where(a => a.IsDeleted == 0 && a.TenantId == TenantId && a.FormId == FormId)
                            select new GetFormFieldsVm
                            {
                                FormId = a.FormId,
                                FieldId = a.FieldId,
                                FieldLabel = a.FieldLabel,
                                FieldType = a.FieldType,
                                Placeholder = a.Placeholder,
                                IsFixed = a.IsFixed,
                                DisplayLabel = a.DisplayLabel,
                                Values = a.Values,
                                Order = a.Order,
                                CSS = a.CSS,
                            }).OrderBy(a => a.Order).ToListAsync();
                return obj;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }
        public async Task SaveForm(SaveFormCommand request)
        {
            DateTime localDateTime = DateTime.Now;
            try
            {
                if (request.FormId == -1)
                {
                    CrmForm newForm = new CrmForm();
                    newForm.Name = request.Name;
                    newForm.Description = request.Description;
                    newForm.Code = request.Code;
                    newForm.CreatedBy = request.Id;
                    newForm.CreatedDate = localDateTime.ToUniversalTime();
                    newForm.TenantId = request.TenantId;
                    await _dbContext.AddAsync(newForm);
                    await _dbContext.SaveChangesAsync();
                    string[] stringArray = { "First Name", "Last Name", "Email", "Phone" };
                    for (int i = 1; i <= stringArray.Length; i++)
                    {
                        CrmFormFields newField = new CrmFormFields();
                        newField.FormId = newForm.FormId;
                        newField.FieldLabel = stringArray[i - 1];
                        newField.FieldType = 1;
                        newField.Placeholder = "";
                        newField.Values = null;
                        newField.IsFixed = true;
                        newField.Order = i;
                        newField.DisplayLabel = true;
                        newField.CSS = "";
                        newField.CreatedBy = request.Id;
                        newField.CreatedDate = localDateTime.ToUniversalTime();
                        newField.TenantId = request.TenantId;
                        await _dbContext.CrmFormFields.AddAsync(newField);

                    }
                    await _dbContext.SaveChangesAsync();
                }
                else
                {
                    var existingForm = await (
                        from a in _dbContext.CrmForm
                        .Where(id => id.TenantId == request.TenantId && id.FormId == request.FormId)
                        select a).FirstOrDefaultAsync();
                    existingForm.Name = request.Name;
                    existingForm.Description = request.Description;
                    existingForm.Code = request.Code;
                    existingForm.LastModifiedBy = request.Id;
                    existingForm.LastModifiedDate = localDateTime.ToUniversalTime();
                    await _dbContext.SaveChangesAsync();
                }

            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }
        public async Task SaveFormFields(SaveFormFieldsCommand request)
        {
            try
            {
                DateTime localDateTime = DateTime.Now;
                if (request.FormFields != null)
                {
                    await _dbContext.Database.ExecuteSqlRawAsync("DELETE FROM \"CrmFormFields\" WHERE \"FormId\" = {0}", request.FormFields.First().FormId);

                }
                foreach (var field in request.FormFields)
                {
                    CrmFormFields newField = new CrmFormFields();
                    newField.FormId = field.FormId;
                    newField.FieldLabel = field.FieldLabel;
                    newField.FieldType = field.FieldType;
                    newField.Placeholder = field.Placeholder;
                    newField.Values = field.Values;
                    newField.IsFixed = field.IsFixed;
                    newField.Order = field.Order;
                    newField.DisplayLabel = field.DisplayLabel;
                    newField.CSS = field.CSS;
                    newField.CreatedBy = request.Id;
                    newField.CreatedDate = localDateTime.ToUniversalTime();
                    newField.TenantId = request.TenantId;
                    await _dbContext.AddAsync(newField);
                    await _dbContext.SaveChangesAsync();
                }


            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }
        public async Task SaveFormResult(SaveFormResultCommand request)
        {
            try
            {
                DateTime localDateTime = DateTime.Now;
                CrmLead newLead = new CrmLead();
                StringBuilder remarksBuilder = new StringBuilder();
                foreach (var result in request.FormResult)
                {
                    CrmFormResults newResult = new CrmFormResults();
                    newResult.FormId = result.FormId;
                    newResult.FieldId = result.FieldId;
                    newResult.Result = result.Result;
                    newResult.CreatedDate = localDateTime.ToUniversalTime();
                    newResult.TenantId = request.TenantId;
                    await _dbContext.AddAsync(newResult);
                    if (IsFixedField(result.FieldLabel))
                    {
                        HandleFixedField(newLead, result);
                    }
                    else
                    {
                        if (result != null && !string.IsNullOrEmpty(result.Result))
                        {
                            remarksBuilder.AppendLine($"{result.FieldLabel}: {result.Result}");
                        }
                    }
                }
                newLead.Status = 1;
                newLead.LeadOwner = "-1";
                newLead.Work = "";
                newLead.Address = "";
                newLead.Street = "";
                newLead.City = "";
                newLead.Zip = "";
                newLead.State = "";
                newLead.Country = "";
                newLead.SourceId = 1; //defulat webiste
                newLead.IndustryId = -1;
                newLead.ProductId = -1;
                newLead.CreatedBy = "-1";
                newLead.CreatedDate = localDateTime.ToUniversalTime();
                newLead.IsDeleted = 0;
                newLead.TenantId = request.TenantId;
                newLead.Remarks = remarksBuilder.ToString();
                await _dbContext.CrmLead.AddAsync(newLead);
                await _dbContext.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }
        private bool IsFixedField(string fieldLabel)
        {
            switch (fieldLabel)
            {
                case "First Name":
                case "Last Name":
                case "Email":
                case "Phone":
                    return true;
                default:
                    return false;
            }
        }

        private void HandleFixedField(CrmLead newLead, SaveFormResultDto result)
        {
           
            switch (result.FieldLabel)
            {
                case "First Name":
                    newLead.FirstName = result.Result;
                    break;
                case "Last Name":
                    newLead.LastName = result.Result;
                    break;
                case "Email":
                    newLead.Email = result.Result;
                    break;
                case "Phone":
                    newLead.Mobile = result.Result;
                    break;
            }
        }

        public async Task Delete(DeleteCommand formId)
        {
            try
            {
                var deleteFrom = await (from a in _dbContext.CrmForm.Where(a => a.FormId == formId.FormId)
                                        select a).FirstOrDefaultAsync();
                if (deleteFrom == null)
                {
                    throw new NotFoundException("formId", formId);
                }
                else
                {
                    deleteFrom.IsDeleted = 1;
                    deleteFrom.DeletedBy = formId.Id;
                    deleteFrom.DeletedDate = DateTime.Now.ToUniversalTime();
                    await _dbContext.SaveChangesAsync();
                }
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task<List<GetDeletedFormVm>> GetDeletedForms(int TenantId, string Id)
        {
            try
            {
                List<GetDeletedFormVm> formDetail = await (from a in _dbContext.CrmForm.Where(a => a.TenantId == TenantId && a.IsDeleted == 1)
                                                           join user in _dbContext.AppUser on a.DeletedBy equals user.Id
                                                           select new GetDeletedFormVm
                                                           {
                                                               Id = a.FormId,
                                                               Title = a.Name,
                                                               DeletedBy = user.FirstName + " " + user.LastName,
                                                               DeletedDate = a.DeletedDate,
                                                           }).OrderBy(a => a.Title).ToListAsync();
                return formDetail;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task RestoreForm(RestoreFormCommand form)
        {
            try
            {
                var restoreForm = await (from a in _dbContext.CrmForm.Where(a => a.FormId == form.FormId)
                                         select a).FirstOrDefaultAsync();
                if (restoreForm == null)
                {
                    throw new NotFoundException("form", form);
                }
                else
                {
                    restoreForm.IsDeleted = 0;
                    await _dbContext.SaveChangesAsync();
                }
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task RestoreBulkForm(ResotreBulkFormCommand form)
        {
            try
            {
                foreach (var formId in form.FormId)
                {
                    var formDetails = await _dbContext.CrmForm
                        .Where(p => p.FormId == formId && p.IsDeleted == 1)
                        .FirstOrDefaultAsync();

                    if (formDetails == null)
                    {
                        throw new NotFoundException(nameof(formId), formId);
                    }

                    formDetails.IsDeleted = 0;
                }

                await _dbContext.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
