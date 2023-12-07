using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Tags.Commands.SaveTags;
using ERPCubes.Application.Features.Tags.Commands.DeleteTags;
using ERPCubes.Application.Features.Tags.Commands.SaveTags;
using ERPCubes.Application.Features.Tags.Queries.GetTagsList;
using ERPCubes.Domain.Entities;
using ERPCubes.Identity;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace ERPCubes.Persistence.Repositories.CRM
{
    public class TagsRepository : BaseRepository<CrmTags>, IAsyncTagsRepository
    {
        public TagsRepository(ERPCubesDbContext dbContext, ERPCubesIdentityDbContext dbContextIdentity) : base(dbContext, dbContextIdentity)
        {
        }



        public async Task<List<GetTagsVm>> GetAllTags(int TenantId)
        {
            try
            {
                List<GetTagsVm> tagList = await (from a in _dbContext.CrmTags.Where(a => a.TenantId == TenantId && a.IsDeleted == 0)
                                                 select new GetTagsVm
                                                 {
                                                     TagId = a.TagId,
                                                     TagTitle = a.TagTitle,
                                                 }).ToListAsync();
                return tagList;
            }
            catch (Exception e)
            {
                throw new BadRequestException(e.Message);
            }

        }

        public async Task DeleteTags(DeleteTagsCommand tagsId)
        {
            try
            {
                CrmTags? Tag = await (from a in _dbContext.CrmTags.Where(a => a.TagId == tagsId.TagId)
                                      select a).FirstOrDefaultAsync();
                Tag.IsDeleted = 1;
                await _dbContext.SaveChangesAsync();
            }
            catch (Exception e)
            {
                throw new BadRequestException(e.Message);
            }

        }

        public async Task<SaveTagVm> SaveTags(SaveTagsCommand Tags)
        {
            try
            {
                DateTime localDateTime = DateTime.Now;
                if (Tags.TagId == -1)
                {

                    CrmTags addTags = new CrmTags();
                    addTags.TenantId = Tags.TenantId;
                    addTags.TagTitle = Tags.TagTitle;
                    addTags.CreatedBy = Tags.Id;
                    addTags.CreatedDate = localDateTime.ToUniversalTime();
                    await _dbContext.AddAsync(addTags);
                    await _dbContext.SaveChangesAsync();
                    Tags.TagId = addTags.TagId;
                }
                else
                {
                    var existingTags = await _dbContext.CrmTags.FindAsync(Tags.TagId);

                    existingTags.TagTitle = Tags.TagTitle;
                    existingTags.LastModifiedBy = Tags.Id;
                    existingTags.LastModifiedDate = localDateTime.ToUniversalTime();
                    await _dbContext.SaveChangesAsync();
                }
                return new SaveTagVm { TagId = Tags.TagId, TagTitle = Tags.TagTitle, IsSelected = true };
            }
            catch (Exception e)
            {
                throw new BadRequestException(e.Message);
            }
        }
    }
}
