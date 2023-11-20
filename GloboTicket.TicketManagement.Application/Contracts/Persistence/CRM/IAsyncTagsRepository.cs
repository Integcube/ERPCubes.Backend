
using ERPCubes.Application.Features.Tags.Commands.DeleteTags;
using ERPCubes.Application.Features.Tags.Commands.SaveTags;
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
    public interface IAsyncTagsRepository : IAsyncRepository<CrmTags>
    {
        Task<List<GetTagsVm>> GetAllTags(int TenantId);
        Task DeleteTags(DeleteTagsCommand TagsId);

        Task SaveTags(SaveTagsCommand Tags);
    }
}
