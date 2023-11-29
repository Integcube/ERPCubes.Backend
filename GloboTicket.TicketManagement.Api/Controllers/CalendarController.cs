using ERPCubes.Application.Features.Crm.Calender.Commands.DeleteCalendarEvent;
using ERPCubes.Application.Features.Crm.Calender.Commands.SaveCalendarEvent;
using ERPCubes.Application.Features.Crm.Calender.Queries.GetCalendarTypeList;
using ERPCubes.Application.Features.Crm.Calender.Queries.GetCalenderList;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ERPCubesApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CalendarController : ControllerBase
    {
        private readonly IMediator _mediator;
        public CalendarController(IMediator mediator)
        {
            _mediator = mediator;
        }
        [HttpPost("all", Name = "GetCalender")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetCalenderListVm>>> GetAllList(GetCalenderListQuery getCalender)
        {
            var dtos = await _mediator.Send(getCalender);
            return Ok(dtos);
        }
        [HttpPost("type", Name = "GetEventType")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetCalenderListVm>>> GetEventType(GetCalendarTypeListQuery getCalender)
        {
            var dtos = await _mediator.Send(getCalender);
            return Ok(dtos);
        }
        [Authorize]
        [HttpPost("delete", Name = "DeleteCalendarEvent")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task DeleteCalendarEvent(DeleteCalendarEventCommand deleteEvent)
        {
            await _mediator.Send(deleteEvent);
        }
        [Authorize]
        [HttpPost("save", Name = "SaveCalendarEvent")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task SaveCalendarEvent(SaveCalendarEventCommand saveEvent)
        {
            await _mediator.Send(saveEvent);
        }
    }
}
