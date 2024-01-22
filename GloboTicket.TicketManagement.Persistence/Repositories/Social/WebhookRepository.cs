using ERPCubes.Application.Contracts.Persistence.Social.Webhooks;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Social.Webhooks.Instagram.Commands;
using ERPCubes.Application.Features.Tickets.Queries.GetAllTickets;
using ERPCubes.Application.Features.Tickets.Queries.GetSelectedConversation;
using ERPCubes.Domain.Entities;
using ERPCubes.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.VisualBasic;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Sockets;
using System.Text;
using System.Threading.Tasks;
using System.Transactions;

namespace ERPCubes.Persistence.Repositories.Social
{
    public class WebhookRepository : BaseRepository<Ticket>, IAsyncWebhookRepository
    {
        public WebhookRepository(ERPCubesDbContext dbContext, ERPCubesIdentityDbContext dbContextIdentity) : base(dbContext, dbContextIdentity)
        {
        }

        public async Task<InstagramWebhookVm> SaveInstaMessage(InstagramWebhookCommand message)
        {
         
                try
                {
                    Ticket tik = await (from a in _dbContext.Ticket.Where(a => a.CustomerId == message.Data.Entry[0].Messaging[0].Sender.Id)
                                        select a).FirstOrDefaultAsync();
                    if (tik == null)
                    {
                    using (var transactionScope = new TransactionScope())
                    {
                        Ticket ticket = new Ticket
                        {
                            SocialMediaPlatform = "Instagram",
                            CustomerId = message.Data.Entry[0].Messaging[0].Sender.Id,
                            Timestamp = DateTimeOffset.FromUnixTimeMilliseconds(message.Data.Entry[0].Time).UtcDateTime,
                            Status = "Open",
                            AssigneeId = "-1",
                            Priority = "Normal",
                            Category = "General",
                            ResolutionStatus = null,
                            DueDate = DateTime.Now.ToUniversalTime(),
                            Notes = null,
                            CreatedBy = "InstagramWebhook",
                            CreatedDate = DateTime.Now.ToUniversalTime(),
                            LastModifiedBy = null,
                            LastModifiedDate = null,
                            RecentlyActive = DateTime.Now.ToUniversalTime(),
                            IsDeleted = 0,
                            TenantId = int.Parse(message.TenantId),
                        };
                        _dbContext.Add(ticket);
                        _dbContext.SaveChanges();

                        Conversation conversation = BuildConversationObject(ticket, message);
                        _dbContext.Add(conversation);
                        _dbContext.SaveChanges();
                        transactionScope.Complete();
                        GetAllTicketsVm returnTicket = BuildTicketObject(ticket, conversation);
                        var obj = new InstagramWebhookVm
                        {
                            Ticket = returnTicket,
                            Conversation = conversation
                        };
                        return obj;
                    }
                }
                    else
                    {
                    tik.RecentlyActive = DateTime.Now.ToUniversalTime();
                    Conversation conversation = BuildConversationObject(tik, message);
                    _dbContext.Add(conversation);
                    _dbContext.SaveChanges();
                    GetAllTicketsVm returnTicket = BuildTicketObject(tik, conversation);

                    var obj = new InstagramWebhookVm
                        {
                            Ticket = returnTicket,
                            Conversation = conversation
                        };
                        return obj;

                    }
                }
                catch (Exception ex)
                {
                    throw new BadRequestException(ex.Message);
                }
            
        }
        private GetAllTicketsVm BuildTicketObject (Ticket ticket, Conversation conversation)
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

        private Conversation BuildConversationObject(Ticket ticket, InstagramWebhookCommand message)
        {
            return new Conversation
            {
                TicketId = ticket.TicketId,
                FromId = message.Data.Entry[0].Messaging[0].Sender.Id,
                ToId = message.Data.Entry[0].Messaging[0].Recipient.Id,
                Timestamp = DateTimeOffset.FromUnixTimeMilliseconds(long.Parse(message.Data.Entry[0].Messaging[0].Timestamp)).UtcDateTime,
                MessageType = "Text",
                MessageBody = message.Data.Entry[0].Messaging[0].Message.Text,
                MediaType = null,
                ReadStatus = false,
                Reaction = null,
                ForwardedStatus = false,
                Location = null,
                MessageStatus = null,
                EventType = null,
                CustomerFeedback = null,
                TenantId = int.Parse(message.TenantId),
                CreatedBy = "InstagramWebhook",
                CreatedDate = DateTime.UtcNow,
                LastModifiedBy = null,
                LastModifiedDate = null,
            };
        }
    }
}
