using System.Text.Json;

namespace ERPCubesApi.Middleware
{
    public class PropertyNamingMiddleware
    {
        private readonly RequestDelegate _next;

        public PropertyNamingMiddleware(RequestDelegate next)
        {
            _next = next;
        }

        public async Task Invoke(HttpContext context)
        {
            // Capture the original response stream
            var originalBodyStream = context.Response.Body;

            try
            {
                using (var responseBody = new MemoryStream())
                {
                    // Replace the response stream with a new memory stream
                    context.Response.Body = responseBody;

                    // Continue processing the request
                    await _next(context);

                    // If the content type is application/json, perform the conversion
                    if (context.Response.ContentType?.ToLower().Contains("application/json") == true)
                    {
                        responseBody.Seek(0, SeekOrigin.Begin);

                        // Deserialize the response JSON
                        var settings = new JsonSerializerOptions
                        {
                            PropertyNamingPolicy = new JsonNamingPolicyConverter()
                        };

                        var responseJson = await JsonSerializer.DeserializeAsync<object>(responseBody, settings);

                        responseBody.Seek(0, SeekOrigin.Begin);
                        responseBody.SetLength(0);

                        // Serialize the response JSON with the naming policy applied
                        await JsonSerializer.SerializeAsync(responseBody, responseJson, settings);
                    }

                    responseBody.Seek(0, SeekOrigin.Begin);

                    // Copy the modified response stream to the original response stream
                    await responseBody.CopyToAsync(originalBodyStream);
                }
            }
            finally
            {
                // Restore the original response stream
                context.Response.Body = originalBodyStream;
            }
        }
    }
}
