using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadAttachments
{
    public class GetLeadAttachmentsQueryHandler: IRequestHandler<GetLeadAttachmentsQuery, List<GetLeadAttachmentsVm>>
    {
        private IAsyncLeadRepository _leadRepository;
        private ILogger<GetLeadAttachmentsQueryHandler> _logger;
        public GetLeadAttachmentsQueryHandler( IAsyncLeadRepository leadRepository, ILogger<GetLeadAttachmentsQueryHandler> logger)
        {
            _leadRepository = leadRepository;
            _logger = logger;
        }
        public async Task<List<GetLeadAttachmentsVm>> Handle(GetLeadAttachmentsQuery request, CancellationToken token)
        {
            try
            {
                List<GetLeadAttachmentsVm> attachments = new List<GetLeadAttachmentsVm>();
                attachments = await (
                    _leadRepository.GetLeadAttachments(request.TenantId, request.Id, request.LeadId, request.ContactTypeId));
                return attachments;
            }
            catch(Exception ex)
            {
                _logger.LogError($"Getting Lead Attachments failed due to {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
