using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.DocumentLibrary.Command.AddDocument;
using ERPCubes.Application.Features.Crm.DocumentLibrary.Command.AddFile;
using ERPCubes.Application.Features.Crm.DocumentLibrary.Command.UpdateDocumentCommand;
using ERPCubes.Application.Features.Crm.DocumentLibrary.Queries.GetDocumentLibrary;
using ERPCubes.Domain.Entities;
using ERPCubes.Identity;
using ERPCubes.Identity.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
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
                                                && (a.ContactTypeId == ContactTypeId)
                                                && (a.Id == ContactId))
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

        public async Task<AddFileCommandVm> AddFile(AddFileCommand request)
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
                AddFileCommandVm vm = new AddFileCommandVm
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
    }
}
