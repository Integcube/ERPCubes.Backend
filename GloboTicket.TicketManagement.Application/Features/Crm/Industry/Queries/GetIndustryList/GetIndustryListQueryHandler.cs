using AutoMapper;
using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Industry.Queries.GetIndustryList
{
    public class GetIndustryListQueryHandler : IRequestHandler<GetIndustryListQuery, List<GetIndustryListVm>>
    {
        private readonly ILogger<GetIndustryListQueryHandler> _logger;
        private readonly IAsyncIndustryRepository _industryRepository;
        private readonly IMapper _mapper;
        public GetIndustryListQueryHandler(ILogger<GetIndustryListQueryHandler> logger,IAsyncIndustryRepository industryRepository,IMapper mapper)
        {
            _logger = logger;
            _mapper = mapper;
            _industryRepository = industryRepository;
        }
        public async Task<List<GetIndustryListVm>> Handle(GetIndustryListQuery request, CancellationToken cancellationToken)
        {
            List<GetIndustryListVm> Industries = new List<GetIndustryListVm>();
            try
            {
                Industries = await _industryRepository.GetAllList(request.Id, request.TenantId);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting Industry list has failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return Industries;
        }
    }
}
