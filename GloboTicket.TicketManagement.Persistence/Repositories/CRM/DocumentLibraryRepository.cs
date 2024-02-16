using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.DocumentLibrary.Command.AddDocument;
using ERPCubes.Application.Features.Crm.DocumentLibrary.Command.AddFile;
using ERPCubes.Application.Features.Crm.DocumentLibrary.Command.AddLeadFile;
using ERPCubes.Application.Features.Crm.DocumentLibrary.Command.UpdateDocumentCommand;
using ERPCubes.Application.Features.Crm.DocumentLibrary.Queries.GetDocumentLibrary;
using ERPCubes.Domain.Entities;
using ERPCubes.Identity;
using ERPCubes.Identity.Models;
using MediatR;
using Microsoft.AspNetCore.Routing.Constraints;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Query;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion.Internal;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Persistence.Repositories.CRM
{
    public class DocumentLibraryRepository : BaseRepository<DocumentLibrary>, IAsyncDocumentLibraryRepository
    {
        public DocumentLibraryRepository(ERPCubesDbContext dbContext, ERPCubesIdentityDbContext dbContextIdentity) : base(dbContext, dbContextIdentity)
        {
        }
        public async Task<List<GetDocumentLibraryVm>> GetAllList(string Id, int TenantId, int ParentId, int ContactTypeId, int ContactId)
        {
            try
            {

                List<GetDocumentLibraryVm> documents = await (from a in _dbContext.DocumentLibrary.Where(a => a.IsDeleted == 0
                                                && a.TenantId == TenantId
                                                && (a.ParentId == ParentId || a.FileId == ParentId)
                                                //&& (a.ContactTypeId == ContactTypeId)
                                                //&& (a.Id == ContactId)
                                                )
                                                join b in _dbContext.AppUser on a.CreatedBy equals b.Id
                                                              join c in _dbContext.AppUser on a.LastModifiedBy equals c.Id into all
                                                              from cc in all.DefaultIfEmpty()
                                                              select new GetDocumentLibraryVm
                                                              {
                                                                  FileId = a.FileId,
                                                                  FileName = a.FileName,
                                                                  Description = a.Description,
                                                                  Type = a.Type,
                                                                  Path = a.Path,
                                                                  ParentId = a.ParentId,
                                                                  Size = a.Size,
                                                                  CreatedBy = b.FirstName +" "+ b.LastName,
                                                                  CreatedDate = a.CreatedDate,
                                                                  ModifiedBy = cc.FirstName + " " + cc.LastName,
                                                                  ModifiedDate = a.LastModifiedDate,
                                                              }).ToListAsync();

                return documents;

            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }
    
        public async Task DeleteDocument(int FileId, string Id, int TenantId)
        {
            try
            {
                DocumentLibrary document = await( 
                    from a in _dbContext.DocumentLibrary.Where(a => a.TenantId == TenantId && a.FileId == FileId)
                    select a).FirstOrDefaultAsync();
                document.IsDeleted = 1;
                await _dbContext.SaveChangesAsync();
            }
            catch(Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task UpdateDocument(UpdateDocumentCommand request)
        {
            try
            {
                DateTime localDateTime = DateTime.Now;
                DocumentLibrary document = await (
                    from a in _dbContext.DocumentLibrary.Where(a => a.TenantId == request.TenantId && a.FileId == request.FileId)
                    select a).FirstOrDefaultAsync();
                document.Description = request.Description;
                document.LastModifiedBy = request.Id;
                document.LastModifiedDate = localDateTime.ToUniversalTime();
                await _dbContext.SaveChangesAsync();
            }
            catch(Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task<AddDocumentCommandVm> AddDocument(AddDocumentCommand request)
        {
            try
            {
                DocumentLibrary doc = new DocumentLibrary
                {
                    FileName = request.Document.FileName,
                    Type = request.Document.Type,
                    Size = request.Document.Size,
                    Path = request.Document.Path,
                    ParentId = request.Document.ParentId,
                    TenantId = request.TenantId,
                    Description = request.Document.FileName,
                    Id = -1,
                    ContactTypeId = -1,
                    CreatedBy = request.Id,
                    CreatedDate = DateTime.UtcNow,
                    IsDeleted = 0
                };
                _dbContext.Add(doc);
                _dbContext.SaveChanges();
                AddDocumentCommandVm vm = new AddDocumentCommandVm
                {
                    FileId = doc.FileId,
                    FileName = doc.FileName,
                    Description = doc.Description,
                    Type = doc.Type,
                    Path = doc.Path,
                    ParentId = doc.ParentId,
                    Size = doc.Size,
                    CreatedDate = doc.CreatedDate,
                    CreatedBy = doc.CreatedBy
                };
                return vm;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task<AddLeadFileCommandVm> AddFile(AddFileCommand request)
        {
            try
            {
                DocumentLibrary doc = new DocumentLibrary
                {
                    FileName = request.FileName,
                    Type = "Folder",
                    Size = 0,
                    Path = "",
                    ParentId = request.ParentId,
                    TenantId = request.TenantId,
                    Description = request.Description,
                    Id = -1,
                    ContactTypeId = -1,
                    CreatedBy = request.Id,
                    CreatedDate = DateTime.UtcNow,
                    IsDeleted = 0
                };
                _dbContext.Add(doc);
                _dbContext.SaveChanges();
                AddLeadFileCommandVm vm = new AddLeadFileCommandVm
                {
                    FileId = doc.FileId,
                    FileName = doc.FileName,
                    Description = doc.Description,
                    Type = doc.Type,
                    Path = doc.Path,
                    ParentId = doc.ParentId,
                    Size = doc.Size,
                    CreatedDate = doc.CreatedDate,
                    CreatedBy = doc.CreatedBy
                };
                return vm;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task AddLeadFile(AddLeadFileCommand request)
        {
            try
            {
                var ExistingMainLeadsFolder = await(
                    from a in _dbContext.DocumentLibrary
                    .Where(a => a.TenantId == request.TenantId && a.Type == "Folder" && a.FileName == "Leads")
                    select a).FirstOrDefaultAsync();

                if (ExistingMainLeadsFolder == null)
                {
                    DocumentLibrary NewMainLeadsFolder = addToDocument("Leads", null, "Folder", 0, -1, request.Id, request.TenantId,  -1, null, 0);
                    _dbContext.Add(NewMainLeadsFolder);
                    _dbContext.SaveChanges();

                    var SelectedLead = await (
                        from a in _dbContext.CrmLead
                        .Where(a => a.TenantId == request.TenantId && a.LeadId == request.LeadId)
                        select a).FirstOrDefaultAsync();

                    var leadName = SelectedLead.FirstName + " " + SelectedLead.LastName;
                    DocumentLibrary NewSubLeadFolder = addToDocument(leadName, null,"Folder", NewMainLeadsFolder.FileId,-1,request.Id,request.TenantId, -1,null,0);

                    _dbContext.Add(NewSubLeadFolder);
                    _dbContext.SaveChanges();

                    DocumentLibrary file = addToDocument(request.File.FileName, request.File.Description, request.File.Type, NewSubLeadFolder.FileId, request.LeadId, request.Id, request.TenantId, request.ContactTypeId, request.File.Path, request.File.Size);

                    _dbContext.Add(file);
                    _dbContext.SaveChanges();


                }
                else
                {
                    var SelectedLead = await (
                        from a in _dbContext.CrmLead
                        .Where(a => a.TenantId == request.TenantId && a.LeadId == request.LeadId)
                        select a).FirstOrDefaultAsync();
                    var leadName = SelectedLead.FirstName + " " + SelectedLead.LastName;
                   
                    var ExistingSubLeadFolder = await (
                        from a in _dbContext.DocumentLibrary
                        .Where(a => a.TenantId == request.TenantId && a.Type == "Folder" && a.ParentId == ExistingMainLeadsFolder.FileId && a.FileName == leadName)
                        select a).FirstOrDefaultAsync();
                    
                    if (ExistingSubLeadFolder == null)
                    {                        
                        DocumentLibrary NewSubLeadFolder = addToDocument(leadName, null, "Folder", ExistingMainLeadsFolder.FileId, -1, request.Id, request.TenantId, -1, null, 0);

                        _dbContext.Add(NewSubLeadFolder);
                        _dbContext.SaveChanges();

                        DocumentLibrary file = addToDocument(request.File.FileName, request.File.Description, request.File.Type, NewSubLeadFolder.FileId, request.LeadId, request.Id, request.TenantId, request.ContactTypeId, request.File.Path, request.File.Size);

                        _dbContext.Add(file);
                        _dbContext.SaveChanges();

                    }
                    else
                    {
                        DocumentLibrary file = addToDocument(request.File.FileName, request.File.Description, request.File.Type, ExistingSubLeadFolder.FileId, request.LeadId, request.Id, request.TenantId, request.ContactTypeId, request.File.Path, request.File.Size);

                        _dbContext.Add(file);
                        _dbContext.SaveChanges();

                    }                    
                }
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }

        }
        public DocumentLibrary addToDocument(string fileName, string description, string type, int parentId, int leadId, string userId, int tenantId,  int contactTypeId, string path, decimal size)
        {
            DocumentLibrary NewMainLeadsFolder = new DocumentLibrary
            {
                FileName = fileName,
                Description = description,
                Type = type,
                ParentId = parentId,
                Id = leadId,                
                CreatedBy = userId,
                CreatedDate = DateTime.UtcNow,
                IsDeleted = 0,
                TenantId = tenantId,
                ContactTypeId = contactTypeId,
                Path = path,
                Size = size,
            };
            return NewMainLeadsFolder;
        }
    }
}
