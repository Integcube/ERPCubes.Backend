
using ERPCubes.Application.Features.Google.Commands.SaveAuth;
using ERPCubes.Application.Models.Mail;
using MediatR;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using System.Net.Http.Headers;

namespace ERPCubesApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ConnectGoogleController : ControllerBase
    {
        private readonly IMediator _mediator;
        public ConnectGoogleController(IMediator mediator)
        {
            _mediator = mediator;
        }
        private readonly string _clientId = "106482018435-sv6nech68f9qkhbpeejsucab67urdpff.apps.googleusercontent.com";
        private readonly string _clientSecret = "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";
        private readonly string _redirectUri = "https://localhost:7020/api/ConnectGoogle/callback";
        private readonly string _scope = "https://www.googleapis.com/auth/adwords openid email profile";
        private readonly string _tokenEndpoint = "https://oauth2.googleapis.com/token";


        [HttpGet("authorize")]
        public IActionResult Authorize(string tenantId, string userId)
        {
            var stateString = $"{tenantId};{userId}";
            var authorizationUrl = $"https://accounts.google.com/o/oauth2/v2/auth" +
                $"?client_id={_clientId}" +
                $"&redirect_uri={_redirectUri}" +
                $"&scope={_scope}" +
                 $"&response_type=code" +
                $"&access_type=offline" +
                $"&state={stateString}";
            return Ok(new { AuthorizationUrl = authorizationUrl });
        }

        [HttpGet("callback")]
        public async Task<IActionResult> CallbackAsync([FromQuery] string code, [FromQuery] string state)
        {
            if (string.IsNullOrEmpty(code))
            {
                return BadRequest("Missing authorization code.");
            }
            int tenantId = 0;
            var userId = "";
            var stateParts = state.Split(';');
            if (stateParts.Length >= 1)
            {
                tenantId = int.Parse(stateParts[0]);
                userId = stateParts[1];
            }
            var accessToken = await ExchangeCodeForTokenAsync(code);
            //var userInfo = await GetUserInfoAsync(accessToken);
            //SaveGoogleAuthUserCommand data = new SaveGoogleAuthUserCommand
            //{
            //    TenantId = tenantId,
            //    Id = userId,
            //    AuthToken = accessToken,
            //    AuthCode = code,
            //    IdToken = accessToken,
            //    User = new GoogleAuthUser
            //    {
            //        Sub = userInfo.Id,
            //        Email = userInfo.Email,
            //        Name = userInfo.Given_Name + " " + userInfo.Family_Name,
            //        Family_Name = userInfo.Family_Name,
            //        Given_Name = userInfo.Given_Name,
            //        Picture = userInfo.Picture,
            //    },
            //};
            //this._mediator.Send(data);
            string htmlContent = @"
<!DOCTYPE html>
<html lang=""en"">
<head>
    <meta charset=""UTF-8"">
    <meta name=""viewport"" content=""width=device-width, initial-scale=1.0"">
    <title>Login Success</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
        }
        .tick-icon {
            width: 100px;
            height: 100px;
            fill: #4CAF50;
        }
    </style>
</head>
<body>
    <h1>Login Successful!</h1>
    <svg class=""tick-icon"" viewBox=""0 0 24 24"">
        <path fill=""currentColor"" d=""M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z""/>
    </svg>
    <button id=""closeButton"">Close</button>
    <script>
        document.getElementById('closeButton').addEventListener('click', function() {
            // Emit an event here that your listener will listen to
            // Example: You can use window.postMessage() to send a message to the parent window
            // and then listen for this message in your listener
            window.opener.postMessage({ type: 'authenticationSuccess' }, '*');
            window.close(); // Close the popup window
        });
    </script>
</body>
</html>
";

            return Content(htmlContent, "text/html");
        }
        private async Task<Dictionary<string, string>> ExchangeCodeForTokenAsync(string code)
        {
            using var httpClient = new HttpClient();
            var requestBody = new Dictionary<string, string>
            {
                ["code"] = code,
                ["client_id"] = _clientId,
                ["client_secret"] = _clientSecret,
                ["redirect_uri"] = _redirectUri,
                ["grant_type"] = "authorization_code"
            };

            var response = await httpClient.PostAsync(_tokenEndpoint, new FormUrlEncodedContent(requestBody));
            response.EnsureSuccessStatusCode();

            var responseContent = await response.Content.ReadAsStringAsync();
            var responseData = JsonConvert.DeserializeObject<Dictionary<string, string>>(responseContent);

            return responseData;
        }
        //private async Task<string> ExchangeCodeForTokenAsync(string code)
        //{
        //    using var httpClient = new HttpClient();
        //    var requestBody = new Dictionary<string, string>
        //    {
        //        ["code"] = code,
        //        ["client_id"] = _clientId,
        //        ["client_secret"] = _clientSecret,
        //        ["redirect_uri"] = _redirectUri,
        //        ["grant_type"] = "authorization_code"
        //    };

        //    var response = await httpClient.PostAsync(_tokenEndpoint, new FormUrlEncodedContent(requestBody));
        //    response.EnsureSuccessStatusCode();

        //    var responseContent = await response.Content.ReadAsStringAsync();
        //    var responseData = JsonConvert.DeserializeObject<Dictionary<string, string>>(responseContent);

        //    return responseData["access_token"];
        //}
        private async Task<UserInfo> GetUserInfoAsync(string accessToken)
        {
            using var httpClient = new HttpClient();
            httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);

            var response = await httpClient.GetAsync("https://www.googleapis.com/oauth2/v2/userinfo");
            response.EnsureSuccessStatusCode();

            var responseContent = await response.Content.ReadAsStringAsync();
            var userInfo = JsonConvert.DeserializeObject<UserInfo>(responseContent);

            return userInfo;
        }

        public class UserInfo
        {
            public string Id { get; set; }
            public string Email { get; set; }
            public string Given_Name { get; set; }
            public string Family_Name { get; set; }
            public string Picture { get; set; }
        }
    }
}
