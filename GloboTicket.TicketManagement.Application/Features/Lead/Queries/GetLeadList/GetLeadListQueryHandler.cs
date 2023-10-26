using AutoMapper;
using ERPCubes.Application.Contracts.Persistence;
using ERPCubes.Domain.Entities;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Lead.Queries.GetLeadList
{
    public class GetLeadListQueryHandler : IRequestHandler<GetLeadListQuery, List<GetLeadVm>>
    {
        private readonly IMapper _mapper;
        private readonly IAsyncRepository<Leads> _leadRepository;

        public GetLeadListQueryHandler(IMapper mapper, IAsyncRepository<Leads> leadRepository)
        {
            _mapper = mapper;
            _leadRepository = leadRepository;
        }
        public async Task<List<GetLeadVm>> Handle(GetLeadListQuery request, CancellationToken cancellationToken)
        {
            var leads = await _leadRepository.ListAllAsync();
           
            return _mapper.Map<List<GetLeadVm>>(leads);
        }
    }
}
