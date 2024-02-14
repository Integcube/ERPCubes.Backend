using ERPCubes.Application.Features.Crm.DocumentLibrary.Command.AddDocument;
using ERPCubes.Application.Features.Crm.DocumentLibrary.Command.AddFile;
using ERPCubes.Application.Features.Crm.DocumentLibrary.Command.UpdateDocumentCommand;
using ERPCubes.Application.Features.Crm.DocumentLibrary.Queries.GetDocumentLibrary;
using ERPCubes.Domain.Entities;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Contracts.Persistence.CRM
{
    public interface IAsyncDocumentLibraryRepository : IAsyncRepository<DocumentLibrary>
    {
        Task<List<GetDocumentLibraryVm>> GetAllList(string Id, int TenantId, int ParentId, int ContactTypeId, int ContactId);

        Task DeleteDocument(int FileId, string Id, int TenantId);

        Task UpdateDocument(UpdateDocumentCommand request);
        Task<AddDocumentCommandVm> AddDocument(AddDocumentCommand request);

        Task<AddFileCommandVm> AddFile(AddFileCommand request);
    }
}
