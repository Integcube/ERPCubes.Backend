using Google.Ads.GoogleAds.Config;
using Google.Ads.GoogleAds.Lib;

namespace ERPCubesApi.Services
{
    public class GoogleAdsAuthenticationService : IGoogleAdsAuthenticationService
    {
        private readonly GoogleAdsClient _googleAdsClient;

        public GoogleAdsAuthenticationService()
        {
            // Set up authentication credentials.
            GoogleAdsConfig config = new GoogleAdsConfig()
            {
                DeveloperToken = "YOUR_DEVELOPER_TOKEN",
                OAuth2Mode = OAuth2Flow.APPLICATION,
                OAuth2ClientId = "YOUR_CLIENT_ID",
                OAuth2ClientSecret = "YOUR_CLIENT_SECRET",
                OAuth2RefreshToken = "YOUR_REFRESH_TOKEN",
                LoginCustomerId = "YOUR_LOGIN_CUSTOMER_ID"
            };

            // Initialize a GoogleAdsClient.
            _googleAdsClient = new GoogleAdsClient(config);
        }

        // Method to get a GoogleAdsClient instance.
        public GoogleAdsClient GetGoogleAdsClient()
        {
            return _googleAdsClient;
        }
    }

    public interface IGoogleAdsAuthenticationService
    {
        GoogleAdsClient GetGoogleAdsClient();
    }
}
