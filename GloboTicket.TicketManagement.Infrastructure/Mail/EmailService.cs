using ERPCubes.Application.Contracts.Persistence.Infrastructure;
using ERPCubes.Application.Models.Mail;
using ERPCubes.Domain.Entities;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using SendGrid;
using SendGrid.Helpers.Mail;

namespace ERPCubes.Infrastructure.Mail
{
    public class EmailService : IEmailService
    {
        public EmailSettings _emailSettings { get; }
        public ILogger<EmailService> _logger { get; }

        public EmailService(IOptions<EmailSettings> mailSettings, ILogger<EmailService> logger)
        {
            _emailSettings = mailSettings.Value;
            _logger = logger;
        }

        public async Task<bool> SendEmail(Email email)
        {
            try
            {

                var client = new SendGridClient("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");

                var subject = email.Subject;
                var to = new EmailAddress(email.To);
                var emailBody = email.Body;

                var from = new EmailAddress
                {
                    Email = _emailSettings.FromAddress,
                    Name = _emailSettings.FromName
                };

                var sendGridMessage = MailHelper.CreateSingleEmail(from, to, subject, emailBody, emailBody);
                var response = await client.SendEmailAsync(sendGridMessage);


                if (response.StatusCode == System.Net.HttpStatusCode.Accepted || response.StatusCode == System.Net.HttpStatusCode.OK)
                {
                    _logger.LogInformation("Email sent " + from.Email);
                    return true;
                }
                _logger.LogError("Email sending failed " + from.Email);
                return false;
            }
            catch (Exception ex)
            {
                _logger.LogError("Email sending failed " + ex.Message);
                return false;

            }
        }
    }
}
