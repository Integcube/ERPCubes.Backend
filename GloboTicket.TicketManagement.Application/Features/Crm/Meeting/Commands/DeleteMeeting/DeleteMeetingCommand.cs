using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Meeting.Commands.DeleteMeeting
{
    public class DeleteMeetingCommand: IRequest
    {
        public int MeetingId { get; set; }

    }
}
