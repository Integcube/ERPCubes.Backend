using ERPCubes.Application.Features.Google.Commands.SaveAuth;
using Google.Apis.Auth.OAuth2.Responses;
using MediatR;
using Microsoft.AspNetCore.Cors;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using System.Net.Http.Headers;
using static Google.Rpc.Context.AttributeContext.Types;

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

        public class Dto
        {
            public int TenantId { get; set; }
            public string Id { get; set; }
        }
        [HttpPost("Connect")]
        public async Task<IActionResult> Connect(Dto reg)
        {
            var stateString = $"tenantId={reg.TenantId}&id={reg.Id}";
            var googleAuthUrl = "https://accounts.google.com/o/oauth2/v2/auth" +
                "?client_id=37203354676-7mtk0bipf5q7ivdgd1pnlnc9d0m7008r.apps.googleusercontent.com" +
                "&redirect_uri=https://localhost:7020/api/ConnectGoogle/callback" +
                "&response_type=code" +
                "&scope=email profile openid https://www.googleapis.com/auth/adwords" + // Include Google Ads API scope here
                $"&state={Uri.EscapeDataString(stateString)}";

            var obj = new
            {
                googleAuthUrl
            };

            return Ok(obj);
        }

        [HttpGet("callback")]
        public async Task<IActionResult> Callback(string code, string state)
        {
            if (string.IsNullOrEmpty(code))
            {
                return BadRequest("Missing authorization code.");
            }
            string decodedState = Uri.UnescapeDataString(state);

            string[] keyValuePairs = decodedState.Split('&');

            // Define variables to store parsed values
            int tenantId = 0;
            string id = null;
            // Parse the key-value pairs to extract the values
            foreach (var pair in keyValuePairs)
            {
                string[] keyValue = pair.Split('=');

                if (keyValue.Length == 2)
                {
                    if (keyValue[0] == "tenantId")
                    {
                        int.TryParse(keyValue[1], out tenantId);
                    }
                    else if (keyValue[0] == "id")
                    {
                      id = keyValue[1];
                    }
                }
            }

         

            var clientId = "37203354676-7mtk0bipf5q7ivdgd1pnlnc9d0m7008r.apps.googleusercontent.com";
            var clientSecret = "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";
            var redirectUri = "https://localhost:7020/api/ConnectGoogle/callback";

            var Token = await ExchangeCodeForAccessToken(clientId, clientSecret, redirectUri, code);

            if (Token == null)
            {
                // Handle token exchange failure
                return BadRequest("Failed to retrieve access token from Google.");
            }

            // Store the accessToken securely (e.g., in a database) or use it for further API calls
            var UserInfo = await GetUserInfo(Token.AccessToken);
            var obj = new SaveGoogleAuthUserCommand
            {
               TenantId = tenantId,
               Id = id,
               IdToken = Token.IdToken,
               AuthCode = code,
               AuthToken = Token.AccessToken,
               User = UserInfo
            };
             await _mediator.Send(obj);
            if (Token.AccessToken == null)
            {
                // Handle token exchange failure
                return BadRequest("Failed to retrieve access token from Google.");
            }
            return Ok("Access token obtained from Google!");
        }
        private async Task<TokenResponse> ExchangeCodeForAccessToken(string clientId, string clientSecret, string redirectUri, string code)
        {
            using var httpClient = new HttpClient();

            var tokenEndpoint = "https://oauth2.googleapis.com/token";
            var requestBody = new Dictionary<string, string>
    {
        { "code", code },
        { "client_id", clientId },
        { "client_secret", clientSecret },
        { "redirect_uri", redirectUri },
        { "grant_type", "authorization_code" },
        { "access_type", "offline" }, // Request refresh token
        { "prompt", "consent" } // Ensure the consent screen is displayed to get a refresh token
    };

            var requestContent = new FormUrlEncodedContent(requestBody);

            var tokenResponse = await httpClient.PostAsync(tokenEndpoint, requestContent);
            if (tokenResponse.IsSuccessStatusCode)
            {
                var responseContent = await tokenResponse.Content.ReadAsStringAsync();
                var responseData = JsonConvert.DeserializeObject<dynamic>(responseContent);
                var accessToken = responseData.access_token;
                var idToken = responseData.id_token;

                var token = new TokenResponse
                {
                    AccessToken = accessToken,
                    IdToken = idToken
                };

                return token;
            }

            return null; // Handle error cases accordingly
        }
        private async Task<GoogleAuthUser> GetUserInfo(string accessToken)
        {
            using var httpClient = new HttpClient();
            httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);

            var userInfoEndpoint = "https://www.googleapis.com/oauth2/v3/userinfo";
            var response = await httpClient.GetAsync(userInfoEndpoint);

            if (response.IsSuccessStatusCode)
            {
                var userInfoJson = await response.Content.ReadAsStringAsync();
                var userInfo = JsonConvert.DeserializeObject<GoogleAuthUser>(userInfoJson);
                return userInfo;
            }

            return null; // Handle error cases accordingly
        }
      
    }
}
