using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.CustomLists.Commands.SaveCustomListFilters;
using MediatR;
using Microsoft.Extensions.Logging;

public class SaveCustomListFilterCommandHandler : IRequestHandler<SaveCustomListFilterCommand>
{
    private readonly IAsyncCustomListRepository _customRepository;
    private readonly ILogger<SaveCustomListFilterCommandHandler> _logger;
    public SaveCustomListFilterCommandHandler(IAsyncCustomListRepository customRepository, ILogger<SaveCustomListFilterCommandHandler> logger)
    {
        _customRepository = customRepository;
        _logger = logger;
    }
    public async Task<Unit> Handle(SaveCustomListFilterCommand request, CancellationToken cancellationToken)
    {
        try
        {
            await _customRepository.UpdateCustomListFilter(request);
            return Unit.Value;
        }
        catch (Exception ex)
        {
            _logger.LogError($"Saving Custom List {request.ListTitle}  failed due to an error : {ex.Message}");
            throw new BadRequestException(ex.Message);
        }
    }
}

