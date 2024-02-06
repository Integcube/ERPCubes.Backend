using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.FormBuilder.Commands.SaveForm;
using ERPCubes.Application.Features.Crm.FormBuilder.Commands.SaveFormFields;
using ERPCubes.Application.Features.Crm.FormBuilder.Commands.SaveFormResult;
using ERPCubes.Application.Features.Crm.FormBuilder.Queries.GetFieldTypes;
using ERPCubes.Application.Features.Crm.FormBuilder.Queries.GetFormFields;
using ERPCubes.Application.Features.Crm.FormBuilder.Queries.GetForms;
using ERPCubes.Domain.Entities;
using ERPCubes.Identity;
using MediatR;
using Microsoft.EntityFrameworkCore;
using static Npgsql.PostgresTypes.PostgresCompositeType;

namespace ERPCubes.Persistence.Repositories.CRM
{
    public class FormsRepository: BaseRepository<CrmForm>, IAsyncFormsRepository
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
                if(request.FormId == -1)
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
                    string[] stringArray = { "First Name", "Last Name", "Email" };
                    for (int i = 1; i < 4; i++)
                    {
                        CrmFormFields newField = new CrmFormFields();
                        newField.FormId = newForm.FormId;
                        newField.FieldLabel = stringArray[i-1];
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
            catch(Exception ex)
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
            catch(Exception ex)
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
                foreach (var result in request.FormResult)
                {
                    CrmFormResults newResult = new CrmFormResults();
                    newResult.FormId = result.FormId;
                    newResult.FieldId = result.FieldId;
                    newResult.Result = result.Result;
                    //newField.CreatedBy = request.Id;
                    newResult.CreatedDate = localDateTime.ToUniversalTime();
                    newResult.TenantId = request.TenantId;
                    await _dbContext.AddAsync(newResult);
                    if (result.FieldLabel == "First Name")
                    {
                        newLead.FirstName = result.Result;
                    }
                    if (result.FieldLabel == "Last Name")
                    {
                        newLead.LastName = result.Result;
                    }
                    if (result.FieldLabel == "Email")
                    {
                        newLead.Email = result.Result;
                    }
                    ;
                }
                newLead.Status = 1;
                newLead.LeadOwner = "-1";
                newLead.Mobile = "-1";
                newLead.Work = "-1";
                newLead.Address = "-1";
                newLead.Street = "-1";
                newLead.City = "-1";
                newLead.Zip = "-1";
                newLead.State = "-1";
                newLead.Country = "-1";
                newLead.SourceId = -1;
                newLead.IndustryId = -1;
                newLead.ProductId = -1;
                newLead.CreatedBy = "-1";
                newLead.CreatedDate = localDateTime.ToUniversalTime();
                newLead.IsDeleted = 0;
                newLead.TenantId = request.TenantId;
                await _dbContext.CrmLead.AddAsync(newLead);
                await _dbContext.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
