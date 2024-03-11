using ERPCubes.Application.Contracts.Persistence.Identity;
using ERPCubes.Application.Contracts.Persistence.Infrastructure;
using ERPCubes.Application.Features.Crm.Tenant.Commands.SaveTenant;
using ERPCubes.Application.Models.Authentication;
using ERPCubes.Application.Models.Mail;
using MediatR;
using Microsoft.AspNetCore.Mvc;
using System.Xml;
using static Google.Rpc.Context.AttributeContext.Types;

namespace ERPCubes.Api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AccountController : ControllerBase
    {
        private readonly IAuthenticationService _authenticationService;
        private readonly IEmailService _IemailService;


        public AccountController(IAuthenticationService authenticationService, IEmailService EmailService)
        {
            _authenticationService = authenticationService;
            _IemailService = EmailService;


        }

        [HttpPost("authenticate")]
        public async Task<ActionResult<AuthenticationResponse>> AuthenticateAsync(AuthenticationRequest request)
        {
            return Ok(await _authenticationService.AuthenticateAsync(request));
        }

        [HttpPost("register")]
        public async Task<ActionResult<RegistrationResponse>> RegisterAsync(RegistrationRequest request)
        {
            return Ok(await _authenticationService.RegisterAsync(request));
        }

        [HttpPost("Update")]
        public async Task<ActionResult<RegistrationResponse>> UpdateUser(RegistrationRequest request)
        {
            return Ok(await _authenticationService.UpdateUserAsync(request));
        }

        [HttpPost("newTenant")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<bool>> NewTenant(SaveTenantCommand checker)
        {
            bool eml = await _authenticationService.SaveTenant(checker);
           
            if (eml)
            {
                string emailBody = $@"
<!DOCTYPE html>
<html lang=""en"">
<head>
    <meta charset=""UTF-8"">
    <meta http-equiv=""X-UA-Compatible"" content=""IE=edge"">
    <meta name=""viewport"" content=""width=device-width, initial-scale=1.0"">
    <title>Welcome to Quantus</title>
    <style>
        /* Styles for email body */
        body {{
            font-family: Arial, sans-serif;
            line-height: 1.6;
            background-color: #f9f9f9;
            margin: 0;
            padding: 0;
        }}

        /* Styles for email container */
        .container {{
            max-width: 600px;
            margin: 0 auto;
            background-color: #ffffff;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
        }}

     
       .header {{
         background-color: #E85038!important;
        color: #ffffff!important;
        padding: 20px;
        text-align: center;
    }}

        /* Styles for main content */
        .content {{
            padding: 30px;
            text-align: center;
        }}

        h1 {{
            color: #333333;
            margin-top: 0;
        }}

        p {{
            margin-bottom: 20px;
            color: #555555;
            font-size: 16px;
            line-height: 1.6;
        }}

        .cta-button {{
            display: inline-block;
            padding: 10px 20px;
            background-color: #007bff;
            color: #ffffff;
            text-decoration: none;
            border-radius: 5px;
        }}

        .footer {{
            background-color: #f3f3f3;
            padding: 20px;
            text-align: center;
            font-size: 14px;
            color: #555555;
        }}
    </style>
</head>
<body>
    <div class=""container"">
        <div class=""header"">
            <h1 style=""color:ffffff!imprtant"">Welcome to Quantus</h1>
        </div>
        <div class=""content"">
            <p>Hello,</p>
            <p>Thank you for joining Quantus! To get started, please use the link below to login:</p>
          <p>https://{checker.Domain}.myquantus.com/</p>
            <p>If you have any questions or need assistance, feel free to <a href=""mailto:support@myquantus.com"">contact us</a>.</p>
            <p>Best regards,<br>Quantus Team</p>
        </div>
        <div class=""footer"">
            <p>This is an automated email. Please do not reply to this email.</p>
        </div>
    </div>
</body>
</html>


";

                Email Em = new Email
                {
                    Body = emailBody,
                    Subject = "Welcome to Quantus",
                    To = checker.Email
                };
                var Reponse = await _IemailService.SendEmail(Em);
                return Ok(Em);
            }
            else
            {
                return Ok(false);
            }
        }
    }
}
