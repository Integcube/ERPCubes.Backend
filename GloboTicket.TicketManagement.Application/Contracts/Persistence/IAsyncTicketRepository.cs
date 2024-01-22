using ERPCubes.Application.Features.Tickets.Commands.SaveTicketInfo;
using ERPCubes.Application.Features.Tickets.Commands.SendMessage;
using ERPCubes.Application.Features.Tickets.Commands.SetReadStatus;
using ERPCubes.Application.Features.Tickets.Queries.GetAllTickets;
using ERPCubes.Application.Features.Tickets.Queries.GetSelectedConversation;
using ERPCubes.Application.Features.Tickets.Queries.GetTicketPriorityList;
using ERPCubes.Application.Features.Tickets.Queries.GetTicketPriorityList.GetTicketPriorityList;
using ERPCubes.Application.Features.Tickets.Queries.GetTicketStatusList;
using ERPCubes.Application.Features.Tickets.Queries.GetTicketTypeList;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Contracts.Persistence
{
    public interface IAsyncTicketRepository
    {
        Task<List<GetAllTicketsVm>> GetAllTickets(GetAllTicketsQuery request);
        Task<List<GetSelectedConversationVm>> GetSelectedConversation(GetSelectedConversationQuery request);
        Task SetReadStatus(SetReadStatusCommand request);
        Task<SendMessageCommand> SendMessage(SendMessageCommand request);
        Task<List<GetTicketStatusListVm>> GetTicketStatus(GetTicketStatusListQuery request);
        Task<List<GetTicketTypeListVm>> GetTicketType(GetTicketTypeListQuery request);
        Task<List<GetTicketPriorityListVm>> GetTicketPriority(GetTicketPriorityListQuery request);
        Task SaveTicketInfo(SaveTicketInfoCommand request);
    }
}
