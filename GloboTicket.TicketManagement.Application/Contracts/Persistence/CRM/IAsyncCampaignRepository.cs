using ERPCubes.Application.Features.Crm.Campaign.Commands.SaveCampaign;
using ERPCubes.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Contracts.Persistence.CRM
{
    public interface IAsyncCampaignRepository : IAsyncRepository<CrmCampaign>
    {
        //Task SaveCampaign(SaveCampaignCommand campaign);
        //Task SaveCampaigns(List<SaveCampaignCommand> campaigns);
        Task SaveCampaigns(List<SaveCampaignCommand> campaigns);


    }
}
