using MediatR;

namespace ERPCubes.Application.Features.Crm.Calender.Commands.DeleteCalendarEvent
{
    public class DeleteCalendarEventCommand : IRequest
    {
        public int TenantId { get; set; }
        public string Id { get; set; } = String.Empty;
        public string Title { get; set; } = String.Empty;
        public int EventId { get; set; }
    }
}
