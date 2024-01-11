using ERPCubes.Application.Features.Google.Queries.GetAuthCode;
using Google.Ads.GoogleAds.Config;
using Google.Ads.GoogleAds.Lib;
using Google.Ads.GoogleAds.V10.Errors;
using Google.Ads.GoogleAds.V10.Services;
using Google.Api.Gax;
using MediatR;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using System.Net.Http.Headers;
using System.Text;
using static Google.Rpc.Context.AttributeContext.Types;

namespace ERPCubesApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class GoogleAdsController : ControllerBase
    {
        private readonly IMediator _mediator;
        public GoogleAdsController(IMediator mediator)
        {
            _mediator = mediator;
        }
        [HttpPost("AdAccount")]
        public async Task<IActionResult> GetAdsAccounts(GetAuthCodeQuery request)
        {
            try
            {
                var accessToken = await _mediator.Send(request);

                using var httpClient = new HttpClient();
                httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
                httpClient.DefaultRequestHeaders.Add("developer-token", "5XD7GOppiWxT8n5nfpS0sQ");

                var adsAccountListEndpoint = "https://googleads.googleapis.com/v15/customers:listAccessibleCustomers";
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

                                // Get campaign info for the current customer ID
                                var campaignInfo = await GetCampaignInfoForCustomer(customerId, accessToken);
                                customerDetails.Add(campaignInfo);
                            }
                            catch (Exception ex)
                            {
                                // Log or handle specific customer-related errors here
                                Console.WriteLine($"Error processing customer: {ex.Message}");
                            }
                        }
                    }

                    return BadRequest("Failed to retrieve Ads Account ID");
                }
                return Ok();
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
