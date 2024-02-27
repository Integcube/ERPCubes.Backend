using ERPCubes.Application.Contracts.Persistence.Social.Webhooks;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Social.Webhooks.Instagram.Commands;
using ERPCubes.Application.Features.Social.Webhooks.Whatsapp.Commands;
using ERPCubes.Application.Features.Tickets.Queries.GetAllTickets;
using ERPCubes.Application.Features.Tickets.Queries.GetSelectedConversation;
using ERPCubes.Domain.Entities;
using ERPCubes.Identity;
using ERPCubes.Identity.Models;
using MediatR;
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
                int tenant = await (from a in _dbContextIdentity.Tenant.Where(a => a.TenantGuid == Guid.Parse(message.TenantGuid))
                                    select a.TenantId).FirstOrDefaultAsync();

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
                            Timestamp = DateTime.Now.ToUniversalTime(),
                            Status = -1,
                            AssigneeId = "-1",
                            Priority = -1,
                            Type = -1,
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
                            TenantId = tenant,
                        };
                        _dbContext.Add(ticket);
                        _dbContext.SaveChanges();

                        Conversation conversation = BuildConversationObject(ticket, message, tenant);
                        _dbContext.Add(conversation);
                        _dbContext.SaveChanges();
                        transactionScope.Complete();
                        GetAllTicketsVm returnTicket = BuildTicketObject(ticket, conversation, tenant);
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
                    Conversation conversation = BuildConversationObject(tik, message, tenant);
                    _dbContext.Add(conversation);
                    _dbContext.SaveChanges();
                    GetAllTicketsVm returnTicket = BuildTicketObject(tik, conversation, tenant);

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
        private GetAllTicketsVm BuildTicketObject (Ticket ticket, Conversation conversation, int tenant)
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

        private Conversation BuildConversationObject(Ticket ticket, InstagramWebhookCommand message, int tenant)
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
                TenantId = tenant,
                CreatedBy = "InstagramWebhook",
                CreatedDate = DateTime.UtcNow,
                LastModifiedBy = null,
                LastModifiedDate = null,
            };
        }

        private Conversation BuildConversationObjectt(Ticket ticket, WhatsappWebhookCommand message, int tenant)
        {
            var firstMessage = message.Data.Entry[0].Changes[0].Value.Messages[0];

            return new Conversation
            {
                TicketId = ticket.TicketId,
                FromId = firstMessage.From,
                ToId = firstMessage.Id,
                Timestamp = DateTimeOffset.FromUnixTimeMilliseconds(long.Parse(firstMessage.Timestamp)).UtcDateTime,
                MessageType = "Text",
                MessageBody = firstMessage.Text.Body,
                MediaType = null,
                ReadStatus = false,
                Reaction = null,
                ForwardedStatus = false,
                Location = null,
                MessageStatus = null,
                EventType = null,
                CustomerFeedback = null,
                TenantId = tenant,
                CreatedBy = "WhatsAppWebhook",
                CreatedDate = DateTime.UtcNow,
                LastModifiedBy = null,
                LastModifiedDate = null,
            };
        }

        public async Task<WhatsappWebhookVm> SaveWhatsappMessage(WhatsappWebhookCommand message)
        {
            try
            {
                int tenant = await (from a in _dbContextIdentity.Tenant.Where(a => a.TenantGuid == Guid.Parse(message.TenantGuid))
                                    select a.TenantId).FirstOrDefaultAsync();

                var firstMessage = message.Data.Entry[0].Changes[0].Value.Messages[0];
                Ticket tik = await _dbContext.Ticket
                .Where(a => a.CustomerId == firstMessage.From)
                .FirstOrDefaultAsync();
                if (tik == null)
                {
                    using (var transactionScope = new TransactionScope())
                    {
                        Ticket ticket = new Ticket
                        {
                            SocialMediaPlatform = "WhatsApp",
                            CustomerId = firstMessage.From,
                            Timestamp = DateTime.Now.ToUniversalTime(),
                            Status = -1,
                            AssigneeId = "-1",
                            Priority = -1,
                            Type = -1,
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
                            TenantId = tenant,
                        };
                        _dbContext.Add(ticket);
                        _dbContext.SaveChanges();

                        Conversation conversation = BuildConversationObjectt(ticket, message, tenant);
                        _dbContext.Add(conversation);
                        _dbContext.SaveChanges();
                        transactionScope.Complete();
                        GetAllTicketsVm returnTicket = BuildTicketObject(ticket, conversation, tenant);
                        var obj = new WhatsappWebhookVm
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
                    Conversation conversation = BuildConversationObjectt(tik, message, tenant);
                    _dbContext.Add(conversation);
                    _dbContext.SaveChanges();
                    GetAllTicketsVm returnTicket = BuildTicketObject(tik, conversation, tenant);

                    var obj = new WhatsappWebhookVm
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
    }
}
