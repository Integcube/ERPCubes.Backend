using Microsoft.AspNetCore.Authentication.Google;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Net.Http;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;

public interface IGoogleAuthenticationService
{
    Task<IActionResult> GoogleLoginRedirect();
    Task<string> ExchangeCodeForAccessToken(string code);
}

public class GoogleAuthenticationService : IGoogleAuthenticationService
{
    private readonly IHttpClientFactory _httpClientFactory;
    private readonly IConfiguration _configuration;
    private readonly IHttpContextAccessor _httpContextAccessor;

    public GoogleAuthenticationService(
        IHttpClientFactory httpClientFactory,
        IConfiguration configuration,
        IHttpContextAccessor httpContextAccessor)
    {
        _httpClientFactory = httpClientFactory;
        _configuration = configuration;
        _httpContextAccessor = httpContextAccessor;
    }

    public async Task<IActionResult> GoogleLoginRedirect()
    {
        // Redirect user to Google login page
        var properties = new AuthenticationProperties
        {
            RedirectUri = "https://localhost:7020/api/GoogleLogin/callback"
        };

        await _httpContextAccessor.HttpContext.ChallengeAsync(GoogleDefaults.AuthenticationScheme, properties);
        return null;
        return new ChallengeResult(GoogleDefaults.AuthenticationScheme);
    }
    public async Task<string> ExchangeCodeForAccessToken(string code)
    {
        var googleTokenEndpoint = "https://oauth2.googleapis.com/token";
        var clientId = _configuration["Authentication:Google:ClientId"];
        var clientSecret = _configuration["Authentication:Google:ClientSecret"];
        var redirectUri = "https://localhost:7020/api/GoogleLogin/callback"; // Ensure this matches the callback URL set in Google Console

        var httpClient = _httpClientFactory.CreateClient();

        var requestBody = new List<KeyValuePair<string, string>>
        {
            new KeyValuePair<string, string>("code", code),
            new KeyValuePair<string, string>("client_id", clientId),
            new KeyValuePair<string, string>("client_secret", clientSecret),
            new KeyValuePair<string, string>("redirect_uri", redirectUri),
            new KeyValuePair<string, string>("grant_type", "authorization_code")
        };

        var tokenRequest = new HttpRequestMessage(HttpMethod.Post, googleTokenEndpoint)
        {
            Content = new FormUrlEncodedContent(requestBody)
        };

        var tokenResponse = await httpClient.SendAsync(tokenRequest);

        if (tokenResponse.IsSuccessStatusCode)
        {
            var responseContent = await tokenResponse.Content.ReadAsStringAsync();
            var responseData = JsonConvert.DeserializeObject<dynamic>(responseContent);
            var accessToken = responseData.access_token;
            return accessToken;
        }

        return null; // Handle error cases accordingly
    }
}
