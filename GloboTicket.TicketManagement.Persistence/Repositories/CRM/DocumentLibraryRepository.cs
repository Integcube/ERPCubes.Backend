﻿using ERPCubes.Application.Contracts.Persistence.CRM;
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
        public async Task<List<GetDocumentLibraryVm>> GetAllList(string Id, int TenantId, int ParentId, int ContactTypeId)
        {
            try
            {

                List<GetDocumentLibraryVm> documents = await (from a in _dbContext.DocumentLibrary.Where(a => a.IsDeleted == 0
                                                && a.TenantId == TenantId
                                                && a.ParentId == ParentId
                                                && (a.ContactTypeId == ContactTypeId))
                                                              select new GetDocumentLibraryVm
                                                              {
                                                                  FileId = a.FileId,
                                                                  FileName = a.FileName,
                                                                  Description = a.Description,
                                                                  Type = a.Type,
                                                                  Path = a.Path,
                                                                  ParentId = a.ParentId,

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