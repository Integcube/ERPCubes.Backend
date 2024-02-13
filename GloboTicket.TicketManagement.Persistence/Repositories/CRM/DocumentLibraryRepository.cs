using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.DocumentLibrary.Queries.GetDocumentLibrary;
using ERPCubes.Domain.Entities;
using ERPCubes.Identity;
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
                                                                  CreatedBy = b.FirstName + b.LastName,
                                                                  CreatedDate = a.CreatedDate,
                                                                  ModifiedBy = cc.FirstName + cc.LastName,
                                                                  ModifiedDate = a.LastModifiedDate,
                                                              }).ToListAsync();



                return documents;

            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
