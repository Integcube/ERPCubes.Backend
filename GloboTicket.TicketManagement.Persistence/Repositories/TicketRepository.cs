using ERPCubes.Application.Contracts.Persistence;
using ERPCubes.Application.Contracts.Persistence.Social.Webhooks;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Tickets.Commands.SaveTicketInfo;
using ERPCubes.Application.Features.Tickets.Commands.SendMessage;
using ERPCubes.Application.Features.Tickets.Commands.SetReadStatus;
using ERPCubes.Application.Features.Tickets.Queries.GetAllTickets;
using ERPCubes.Application.Features.Tickets.Queries.GetSelectedConversation;
using ERPCubes.Application.Features.Tickets.Queries.GetTicketPriorityList;
using ERPCubes.Application.Features.Tickets.Queries.GetTicketPriorityList.GetTicketPriorityList;
using ERPCubes.Application.Features.Tickets.Queries.GetTicketStatusList;
using ERPCubes.Application.Features.Tickets.Queries.GetTicketTypeList;
using ERPCubes.Domain.Entities;
using ERPCubes.Identity;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Persistence.Repositories
{
    public class TicketRepository : BaseRepository<Ticket>, IAsyncTicketRepository
    {
        public TicketRepository(ERPCubesDbContext dbContext, ERPCubesIdentityDbContext dbContextIdentity) : base(dbContext, dbContextIdentity)
        {
        }

        public async Task<List<GetAllTicketsVm>> GetAllTickets(GetAllTicketsQuery request)
        {
            try
            {
                List<GetAllTicketsVm> tickets = await (from a in _dbContext.Ticket.Where(a => a.IsDeleted == 0 && a.TenantId == request.TenantId)
                                                       select new GetAllTicketsVm
                                                       {
                                                           TicketId = a.TicketId,
                                                           SocialMediaPlatform = a.SocialMediaPlatform,
                                                           CustomerId = a.CustomerId,
                                                           Timestamp = a.Timestamp,
                                                           Status = a.Status,
                                                           AssigneeId = a.AssigneeId,
                                                           Priority = a.Priority,
                                                           Category = a.Category,
                                                           ResolutionStatus = a.ResolutionStatus,
                                                           DueDate = a.DueDate,
                                                           RecentlyActive = a.RecentlyActive,
                                                           Notes = a.Notes,
                                                           Type = a.Type,
                                                           TenantId = a.TenantId,
                                                           LatestConversation = (
                                                               from b in _dbContext.Conversation
                                                               where b.TicketId == a.TicketId
                                                               orderby b.ConversationId descending
                                                               select new GetSelectedConversationVm
                                                               {
                                                                   ConversationId = b.ConversationId,
                                                                   TicketId = b.TicketId,
                                                                   FromId = b.FromId,
                                                                   ToId = b.ToId,
                                                                   IsMine = b.IsMine,
                                                                   Timestamp = b.Timestamp,
                                                                   MessageType = b.MessageType,
                                                                   MessageBody = b.MessageBody,
                                                                   MediaType = b.MediaType,
                                                                   ReadStatus = b.ReadStatus,
                                                                   Reaction = b.Reaction,
                                                                   ForwardedStatus = b.ForwardedStatus,
                                                                   Location = b.Location,
                                                                   MessageStatus = b.MessageStatus,
                                                                   EventType = b.EventType,
                                                                   CustomerFeedback = b.CustomerFeedback,
                                                                   TenantId = b.TenantId,
                                                                   CreatedDate = b.CreatedDate
                                                               }
                                                           ).FirstOrDefault()
                                                       }
                                                    ).OrderByDescending(a => a.RecentlyActive).ToListAsync();
                return tickets;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task<List<GetSelectedConversationVm>> GetSelectedConversation(GetSelectedConversationQuery request)
        {
            try
            {
                List<GetSelectedConversationVm> coversations = await (from a in _dbContext.Conversation.Where(a => a.IsDeleted == 0 && a.TicketId == request.TicketId)
                                                                      select new GetSelectedConversationVm
                                                                      {
                                                                          ConversationId = a.ConversationId,
                                                                          TicketId = a.TicketId,
                                                                          FromId = a.FromId,
                                                                          ToId = a.ToId,
                                                                          Timestamp = a.Timestamp,
                                                                          MessageType = a.MessageType,
                                                                          MessageBody = a.MessageBody,
                                                                          MediaType = a.MediaType,
                                                                          ReadStatus = a.ReadStatus,
                                                                          Reaction = a.Reaction,
                                                                          ForwardedStatus = a.ForwardedStatus,
                                                                          Location = a.Location,
                                                                          MessageStatus = a.MessageStatus,
                                                                          EventType = a.EventType,
                                                                          CustomerFeedback = a.CustomerFeedback,
                                                                          IsMine = a.IsMine,
                                                                          TenantId = a.TenantId,
                                                                          CreatedDate = a.CreatedDate
                                                                      }).OrderBy(a => a.CreatedDate).ToListAsync();
                return coversations;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task<List<GetTicketPriorityListVm>> GetTicketPriority(GetTicketPriorityListQuery request)
        {
            try
            {

                List<GetTicketPriorityListVm> priority= await(from a in _dbContext.TicketPriority.Where(a=>a.IsDeleted == 0)
                                                      select new GetTicketPriorityListVm
                                                      {
                                                          TicketPriorityId = a.TicketPriorityId,
                                                          PriorityName = a.PriorityName,
                                                      }).ToListAsync();
                return priority;

            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task<List<GetTicketStatusListVm>> GetTicketStatus(GetTicketStatusListQuery request)
        {
            try
            {
                List<GetTicketStatusListVm> priority = await (from a in _dbContext.TicketStatus.Where(a => a.IsDeleted == 0)
                                                                select new GetTicketStatusListVm
                                                                {
                                                                    TicketStatusId = a.TicketStatusId,
                                                                    StatusName = a.StatusName,
                                                                }).ToListAsync();
                return priority;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task<List<GetTicketTypeListVm>> GetTicketType(GetTicketTypeListQuery request)
        {
            try
            {
                List<GetTicketTypeListVm> priority = await(from a in _dbContext.TicketType.Where(a => a.IsDeleted == 0)
                                                               select new GetTicketTypeListVm
                                                               {
                                                                   TicketTypeId = a.TicketTypeId,
                                                                   TypeName = a.TypeName,
                                                               }).ToListAsync();
                return priority;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task SaveTicketInfo(SaveTicketInfoCommand request)
        {
            try
            {
                Ticket ticket = await (from a in _dbContext.Ticket.Where(a => a.TicketId == request.TicketId)
                                       select a).FirstOrDefaultAsync();
                ticket.Priority = request.Priority;
                ticket.Type = request.Type;
                ticket.AssigneeId = request.AssigneeId;
                ticket.Status = request.Status;
                ticket.Notes = request.Notes;
                await _dbContext.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task<SendMessageCommand> SendMessage(SendMessageCommand request)
        {
            try
            {
                Conversation message = new Conversation();
                message.TicketId = request.LatestConversation.TicketId;
                message.FromId = request.LatestConversation.FromId;
                message.ToId = request.LatestConversation.ToId;
                message.Timestamp = DateTime.Now.ToUniversalTime();
                message.MessageType = request.LatestConversation.MessageType;
                message.MessageBody = request.LatestConversation.MessageBody;
                message.MediaType = request.LatestConversation.MediaType;
                message.ReadStatus = true;
                message.Reaction = request.LatestConversation.Reaction;
                message.ForwardedStatus = false;
                message.Location = request.LatestConversation.Location;
                message.MessageStatus = request.LatestConversation.MessageStatus;
                message.EventType = request.LatestConversation.EventType;
                message.CustomerFeedback = request.LatestConversation.CustomerFeedback;
                message.TenantId = request.LatestConversation.TenantId;
                message.IsMine = request.LatestConversation.IsMine;
                message.CreatedDate = DateTime.Now.ToUniversalTime();
                message.CreatedBy = request.Id;
                _dbContext.Add(message);
                _dbContext.SaveChanges();
                request.LatestConversation.ConversationId = message.ConversationId;
                request.LatestConversation.Timestamp = message.Timestamp;
                request.LatestConversation.CreatedDate = message.CreatedDate;

                return request;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task SetReadStatus(SetReadStatusCommand request)
        {
            try
            {
                await _dbContext.Database.ExecuteSqlRawAsync("UPDATE \"Conversation\" SET \"ReadStatus\" = {0} WHERE \"TicketId\" = {1}", true, request.TicketId);
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
