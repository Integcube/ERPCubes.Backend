﻿using ERPCubes.Application.Features.Crm.Campaign.Commands.DeleteCampaign;
using ERPCubes.Application.Features.Crm.Campaign.Commands.SaveCampaign;
using ERPCubes.Application.Features.Crm.Campaign.Queries.GetCampaign;
using ERPCubes.Application.Features.Crm.Campaign.Queries.GetCampaignSource;
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
        Task SaveCampaign(SaveCampaignCommand campaign);
        //Task SaveCampaigns(List<SaveCampaignCommand> campaigns);
        Task SaveBulkCampaigns(List<SaveBulkCampaignCommand> campaigns);
        Task<List<GetCampaignVm>> GetCampaign(GetCampaignQuery campaigns);
        Task DeleteCampaign(DeleteCampaignCommand campaigns);
        Task<List<GetCampaignSourceVm>> GetCampaignSource(GetCampaignSourceQuery campaignSource);

    }
}