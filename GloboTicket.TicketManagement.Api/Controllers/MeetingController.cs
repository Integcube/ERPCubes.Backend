using ERPCubes.Application.Features.Crm.Email.Commands.DeleteEmail;
using ERPCubes.Application.Features.Crm.Email.Commands.SaveEmail;
using ERPCubes.Application.Features.Crm.Email.Queries.GetEmailList;
using ERPCubes.Application.Features.Crm.Meeting.Commands.DeleteMeeting;
using ERPCubes.Application.Features.Crm.Meeting.Commands.SaveMeeting;
using ERPCubes.Application.Features.Crm.Meeting.Queries.GetMeetingList;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace ERPCubesApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class MeetingController : ControllerBase
    {
        private readonly IMediator _mediator;
        public MeetingController(IMediator mediator)
        {
            _mediator = mediator;
        }
        //[Authorize]
        [HttpPost("all", Name = "GetAllMeetings")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetMeetingVm>>> GetAllCategories(GetMeetingListQuery getMeeting)
        {
            var dtos = await _mediator.Send(getMeeting);
            return Ok(dtos);
        }

        //[Authorize]
        [HttpPost("delete", Name = "DeletMeeting")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<List<ActionResult>>> DeleteMeeting(DeleteMeetingCommand deleteMeeting)
        {
            var dtos = await _mediator.Send(deleteMeeting);
            return Ok(dtos);
        }

        //[Authorize]
        [HttpPost("save", Name = "SaveMeeting")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult> SaveEmail(SaveMeetingCommand meetingCommand)
        {
            var dtos = await _mediator.Send(meetingCommand);
            return Ok(dtos);
        }
    }
}
