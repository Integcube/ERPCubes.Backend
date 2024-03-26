using ERPCubes.Application.Features.Crm.AdAccount.Commands.BulkSaveAdAccount;
using ERPCubes.Application.Features.Google.Queries.GetAuthCode;
using MediatR;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;

namespace ERPCubesApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class GoogleAdsController : ControllerBase
    {
        private readonly string _clientId = "106482018435-sv6nech68f9qkhbpeejsucab67urdpff.apps.googleusercontent.com";
        private readonly string _clientSecret = "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";
        private readonly string _redirectUri = "https://localhost:7020/api/ConnectGoogle/callback";
        private readonly string _scope = "https://www.googleapis.com/auth/adwords openid email profile";
        private readonly string _tokenEndpoint = "https://oauth2.googleapis.com/token";
        private readonly string _developerToken = "5XD7GOppiWxT8n5nfpS0sQ";

        private readonly IMediator _mediator;

        public GoogleAdsController(IMediator mediator)
        {
            _mediator = mediator;
        }
        [HttpPost("saveAdAccount")]
        public async Task<IActionResult> SaveAdsAccounts(SaveBulkAdAccountCommand request)
        {
            try
            {
                 await _mediator.Send(request);
                GetAuthCodeQuery data = new GetAuthCodeQuery
                {
                    Id = request.Id,
                    TenantId = request.TenantId,
                    Provider = request.Provider
                };
                var accessToken = await _mediator.Send(data);
                foreach (var account in request.AdAccount)
                {
                    if(account.IsSelected == true)
                    {
                        var response = await GetCampaignInfoForCustomer(account.AccountId, accessToken.ToString());

                    }

                }
                   
                    return Ok();
            }

            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
        [HttpPost("AdAccount")]
        public async Task<IActionResult> GetAdsAccounts(GetAuthCodeQuery request)
        {
            try
            {
                List<SaveBulkAdAccountDto> managerAccount = new List<SaveBulkAdAccountDto>();
                var accessToken = await _mediator.Send(request);
                using var httpClient = new HttpClient();
                httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
                httpClient.DefaultRequestHeaders.Add("developer-token", _developerToken);
                var adsAccountListEndpoint = "https://googleads.googleapis.com/v16/customers:listAccessibleCustomers";
                var response = await httpClient.GetAsync(adsAccountListEndpoint);
                if (response.IsSuccessStatusCode)
                {
                    var accountListJson = await response.Content.ReadAsStringAsync();
                    var accounts = JsonConvert.DeserializeObject<dynamic>(accountListJson);

                    if (accounts != null && accounts.resourceNames != null && accounts.resourceNames.Count > 0)
                    {
                        List<string> customerDetails = new List<string>();

                        foreach (var resource in accounts.resourceNames)
                        {
                            try
                            {
                                var str = resource.ToString();
                                var parts = str.Split('/');
                                var customerId = parts[1];
                                SaveBulkAdAccountDto account = new SaveBulkAdAccountDto
                                {
                                    AccountId = customerId,
                                    Title = customerId,
                                    IsSelected = false,
                                    SocialId = customerId,
                                    Provider = "GOOGLE"
                                };
                                managerAccount.Add(account);

                            }
                            catch (Exception ex)
                            {
                                Console.WriteLine($"Error processing customer: {ex.Message}");
                            }
                        }
                        SaveBulkAdAccountCommand adCommand = new SaveBulkAdAccountCommand()
                        {
                            TenantId = request.TenantId,
                            Id = request.Id,
                            AdAccount = managerAccount
                        };
                    }
                    else
                    {
                        return Ok();
                    }
                }
                else
                {
                    Console.WriteLine($"Error processing customer");
                }
                return Ok(managerAccount);
            }

            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        private async Task<string> GetCampaignInfoForCustomer(string customerId, string accessToken)
        {
            try
            {
                var customerInfoEndpoint = $"https://googleads.googleapis.com/v15/customers/{customerId}/googleAds:searchStream";
                var requestBody = @"
{
    'query' : 'SELECT campaign.name, campaign.status, segments.device,
        metrics.impressions, metrics.clicks, metrics.ctr,
        metrics.average_cpc, metrics.cost_micros
    FROM campaign
    WHERE segments.date DURING LAST_30_DAYS'
}";

                using var httpClient = new HttpClient();
                httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
                httpClient.DefaultRequestHeaders.Add("developer-token", "5XD7GOppiWxT8n5nfpS0sQ");

                httpClient.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

                var request = new HttpRequestMessage(HttpMethod.Post, customerInfoEndpoint);
                request.Content = new StringContent(requestBody, Encoding.UTF8, "application/json");

                var response = await httpClient.SendAsync(request);

                if (response.IsSuccessStatusCode)
                {
                    var campaignInfoJson = await response.Content.ReadAsStringAsync();
                    return campaignInfoJson;
                }

                return $"Failed to retrieve campaign info for customer ID: {customerId}";
            }
            catch (Exception ex)
            {
                return $"Error retrieving campaign info for customer ID {customerId}: {ex.Message}";
            }
        }
    }
}
