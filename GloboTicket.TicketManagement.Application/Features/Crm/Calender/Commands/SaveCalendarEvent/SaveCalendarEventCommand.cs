using MediatR;

namespace ERPCubes.Application.Features.Crm.Calender.Commands.SaveCalendarEvent
{
    public class SaveCalendarEventCommand : IRequest
    {
        public SaveCalendarEventDto Event { get; set; } = new SaveCalendarEventDto();
        public int TenantId { get; set; }
        public int ContactTypeId { get; set; }
        public int ActivityId { get; set; }
        public string Id { get; set; } = String.Empty;
    }
}
