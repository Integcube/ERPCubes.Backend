﻿using AutoMapper;
using ERPCubes.Application.Contracts.Persistence;
using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Industry.Queries.GetIndustryList;
using ERPCubes.Domain.Entities;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadList
{
    public class GetLeadListQueryHandler : IRequestHandler<GetLeadListQuery, GetLeadVm>
    {
        private readonly IMapper _mapper;
        private readonly IAsyncLeadRepository _leadRepository;
        private readonly ILogger<GetIndustryListQueryHandler> _logger;

        public GetLeadListQueryHandler(IMapper mapper, IAsyncLeadRepository leadRepository, ILogger<GetIndustryListQueryHandler> logger)
        {
            _mapper = mapper;
            _leadRepository = leadRepository;
            _logger = logger;
        }
        public async Task<GetLeadVm> Handle(GetLeadListQuery request, CancellationToken cancellationToken)
        {
            GetLeadVm leads = new GetLeadVm();
            try
            {
                leads = await _leadRepository.GetAllLeads(request);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting Lead list has failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }

            return leads;
        }
    }
}
