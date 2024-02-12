using ERPCubes.Application.Contracts.Persistence;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Chatbot.Commands.SaveCbConversations;
using ERPCubes.Application.Features.Chatbot.Queries.GetAllConversations;
using ERPCubes.Application.Features.Social.Webhooks.Instagram.Commands;
using ERPCubes.Application.Features.Tickets.Queries.GetAllTickets;
using ERPCubes.Application.Features.Tickets.Queries.GetSelectedConversation;
using ERPCubes.Domain.Entities;
using ERPCubes.Identity;
using MediatR;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Transactions;

namespace ERPCubes.Persistence.Repositories
{
    public class ChatbotRepository : BaseRepository<Task>, IAsyncChatbotRepository
    {
        public ChatbotRepository(ERPCubesDbContext dbContext, ERPCubesIdentityDbContext dbContextIdentity) : base(dbContext, dbContextIdentity)
        {
        }

        public async Task<List<GetCbConversationVm>> GetAllConversation(GetCbConversationQueries request)
        {
            try
            {
                List<GetCbConversationVm> coversations = await (from a in _dbContext.Conversation.Where(a => a.IsDeleted == 0 && a.FromId == request.BrowserId)
                                                                select new GetCbConversationVm
                                                                {
                                                                    ConversationId = a.ConversationId,
                                                                    TicketId = a.TicketId,
                                                                    Timestamp = a.Timestamp,
                                                                    Message = a.MessageBody,
                                                                    IsMine = a.IsMine,
                                                                }).OrderBy(a => a.Timestamp).ToListAsync();
                return coversations;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }

        }

        public async Task<GetAllTicketsVm> SaveConversation(SaveCbConversationCommand request)
        {
            try
            {
                Ticket tik = await (from a in _dbContext.Ticket.Where(a => a.CustomerId == request.BrowserId)
                                    select a).FirstOrDefaultAsync();
                if (tik == null)
                {
                    using (var transactionScope = new TransactionScope())
                    {
                        Ticket ticket = new Ticket
                        {
                            SocialMediaPlatform = "Chatbot",
                            CustomerId = request.BrowserId,
                            Timestamp = DateTime.Now.ToUniversalTime(),
                            Status = -1,
                            AssigneeId = "-1",
                            Priority = -1,
                            Type = -1,
                            Category = "General",
                            ResolutionStatus = null,
                            DueDate = DateTime.Now.ToUniversalTime(),
                            Notes = null,
                            CreatedBy = "Chatbot",
                            CreatedDate = DateTime.Now.ToUniversalTime(),
                            LastModifiedBy = null,
                            LastModifiedDate = null,
                            RecentlyActive = DateTime.Now.ToUniversalTime(),
                            IsDeleted = 0,
                            TenantId = int.Parse(request.TenantId),
                        };
                        _dbContext.Add(ticket);
                        _dbContext.SaveChanges();

                        Conversation conversation = BuildConversationObject(ticket, request);
                        _dbContext.Add(conversation);
                        _dbContext.SaveChanges();
                        transactionScope.Complete();
                        GetAllTicketsVm returnTicket = BuildTicketObject(ticket, conversation);
         
                        return returnTicket;
                    }
                }
                else
                {
                    tik.RecentlyActive = DateTime.Now.ToUniversalTime();
                    Conversation conversation = BuildConversationObject(tik, request);
                    _dbContext.Add(conversation);
                    _dbContext.SaveChanges();
                    GetAllTicketsVm returnTicket = BuildTicketObject(tik, conversation);


                    return returnTicket;

                }
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }
        private GetAllTicketsVm BuildTicketObject(Ticket ticket, Conversation conversation)
        {

            return new GetAllTicketsVm
            {
                TicketId = ticket.TicketId,
                SocialMediaPlatform = ticket.SocialMediaPlatform,
                CustomerId = ticket.CustomerId,
                Timestamp = ticket.Timestamp,
                Status = ticket.Status,
                AssigneeId = ticket.AssigneeId,
                Priority = ticket.Priority,
                Category = ticket.Category,
                ResolutionStatus = ticket.ResolutionStatus,
                DueDate = ticket.DueDate,
                RecentlyActive = ticket.RecentlyActive,
                Notes = ticket.Notes,
                TenantId = ticket.TenantId,
                LatestConversation = new GetSelectedConversationVm
                {
                    ConversationId = conversation.ConversationId,
                    TicketId = conversation.TicketId,
                    FromId = conversation.FromId,
                    ToId = conversation.ToId,
                    Timestamp = conversation.Timestamp,
                    MessageType = conversation.MessageType,
                    MessageBody = conversation.MessageBody,
                    MediaType = conversation.MediaType,
                    ReadStatus = conversation.ReadStatus,
                    Reaction = conversation.Reaction,
                    ForwardedStatus = conversation.ForwardedStatus,
                    Location = conversation.Location,
                    MessageStatus = conversation.MessageStatus,
                    EventType = conversation.EventType,
                    CustomerFeedback = conversation.CustomerFeedback,
                    TenantId = conversation.TenantId,
                    CreatedDate = conversation.CreatedDate
                }
            };
        }

        private Conversation BuildConversationObject(Ticket ticket, SaveCbConversationCommand message)
        {
            return new Conversation
            {
                TicketId = ticket.TicketId,
                FromId = message.BrowserId,
                ToId = "0",
                Timestamp = DateTime.Now.ToUniversalTime(),
                MessageType = "Text",
                MessageBody = message.Message,
                MediaType = null,
                ReadStatus = false,
                Reaction = null,
                ForwardedStatus = false,
                Location = null,
                MessageStatus = null,
                EventType = null,
                CustomerFeedback = null,
                TenantId = int.Parse(message.TenantId),
                CreatedBy = "Chatbot",
                CreatedDate = DateTime.UtcNow,
                LastModifiedBy = null,
                LastModifiedDate = null,
            };
        }
    }
}
