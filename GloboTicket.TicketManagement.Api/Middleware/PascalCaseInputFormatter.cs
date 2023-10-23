using System.Text;
using System.Text.Json;
using Microsoft.AspNetCore.Mvc.Formatters;
using Microsoft.Net.Http.Headers;

public class PascalCaseInputFormatter : TextInputFormatter
{
    public PascalCaseInputFormatter()
    {
        SupportedMediaTypes.Add(MediaTypeHeaderValue.Parse("application/json"));
        SupportedEncodings.Add(Encoding.UTF8);
        SupportedEncodings.Add(Encoding.Unicode);
    }

    public override async Task<InputFormatterResult> ReadRequestBodyAsync(InputFormatterContext context, Encoding encoding)
    {
        using (var reader = new StreamReader(context.HttpContext.Request.Body, encoding))
        {
            try
            {
                var content = await reader.ReadToEndAsync();
                var modelType = context.ModelType;

                var options = new JsonSerializerOptions
                {
                    PropertyNameCaseInsensitive = false,
                };

                var model = JsonSerializer.Deserialize(content, modelType, options);

                return InputFormatterResult.Success(model);
            }
            catch
            {
                return InputFormatterResult.Failure();
            }
        }
    }

    protected override bool CanReadType(Type type)
    {
        return true; // You can add additional type checks here if needed
    }
}
