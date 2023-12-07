﻿using ERPCubes.Application.Features.Crm.Task.Commands.DeleteTask;
using ERPCubes.Application.Features.Crm.Task.Commands.SaveTask;
using ERPCubes.Application.Features.Crm.Task.Commands.UpdateTaskOrder;
using ERPCubes.Application.Features.Crm.Task.Commands.UpdateTaskStatus;
using ERPCubes.Application.Features.Crm.Task.Queries.GetTaskList;
using ERPCubes.Application.Features.Crm.Task.Queries.GetTaskTagsList;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace ERPCubesApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TaskController : ControllerBase
    {
        private readonly IMediator _mediator;
        public TaskController(IMediator mediator)
        {
            _mediator = mediator;
        }

        [HttpPost("all", Name = "GetAllCrmTasks")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetCrmTaskListVm>>> GetAllCrmTasks(GetCrmTaskListQuery getTaskList)
        {
            var dtos = await _mediator.Send(getTaskList);
            return Ok(dtos);
        }
        [HttpPost("tags", Name = "GetAllTaskTags")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetTaskTagsListVm>>> GetAllTags(GetTaskTagsListQuery getTaskList)
        {
            var dtos = await _mediator.Send(getTaskList);
            return Ok(dtos);
        }
        [HttpPost("updateTaskOrder", Name = "UpateTaskOrder")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task UpateTaskOrder(UpdateTaskOrderCommand updatetaskOrder)
        {
            var dtos = await _mediator.Send(updatetaskOrder);
        }
        [HttpPost("delete", Name = "DeleteTask")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task DeleteTask(DeleteTaskCommand deletetask)
        {
            var dtos = await _mediator.Send(deletetask);
        }
        [HttpPost("updateStatus", Name = "UpdateTaskStatus")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task UpdateTaskStatus(UpdateTaskStatusCommand updateTaskStatus)
        {
            var dtos = await _mediator.Send(updateTaskStatus);
        }
        [HttpPost("save", Name = "SaveTask")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task SaveTask(SaveTaskCommand saveTask)
        {
            var dtos = await _mediator.Send(saveTask);
        }
    }
}
