
using ERPCubes.Application.Features.Crm.DocumentLibrary.Queries.GetDocumentLibrary;
using MediatR;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace ERPCubesApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class DocumentLibraryController : ControllerBase
    {

        private readonly IMediator _mediator;
        //private readonly HttpClient _httpClient;
        public DocumentLibraryController(IMediator mediator)
        {
            _mediator = mediator;
            //_httpClient = httpClientFactory.CreateClient();
        }

        [HttpPost("all", Name = "GetAllDocuments")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetDocumentLibraryVm>>> GetAllCategories(GetDocumentLibraryQuery getDocument)
        {
            var dtos = await _mediator.Send(getDocument);
            return Ok(dtos);
        }

        //[HttpPost("SaveFile")]
        //public async Task<IActionResult> SaveFile(IFormFile file, string tenantId)
        //{
        //    try
        //    {
        //        if (file == null || file.Length == 0)
        //        {
        //            return BadRequest("Invalid file");
        //        }

        //        // Convert file to byte array
        //        using (var memoryStream = new MemoryStream())
        //        {
        //            await file.CopyToAsync(memoryStream);
        //            byte[] fileBytes = memoryStream.ToArray();

        //            // Serialize file bytes into JSON
        //            string json = JsonSerializer.Serialize(fileBytes);

        //            // Send file bytes to the endpoint
        //            var response = await _httpClient.PostAsync("https://localhost:7046/FileServer/SaveFile", new StringContent(json));

        //            response.EnsureSuccessStatusCode(); // Ensure successful response

        //            return Ok("File saved successfully.");
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        return StatusCode(500, $"Internal server error: {ex.Message}");
        //    }
        //}


        //[HttpGet("ReturnFile")]
        //public async Task<IActionResult> ReturnFile(string filePath)
        //{
        //    try
        //    {
        //        var response = await _httpClient.GetAsync($"/FileServer/ReturnFile?filePath={filePath}");

        //        if (!response.IsSuccessStatusCode)
        //        {
        //            return StatusCode((int)response.StatusCode, response.ReasonPhrase);
        //        }

        //        var fileBytes = await response.Content.ReadAsByteArrayAsync();
        //        var fileStream = new MemoryStream(fileBytes);

        //        return File(fileStream, "application/octet-stream", Path.GetFileName(filePath));
        //    }
        //    catch (Exception ex)
        //    {
        //        return StatusCode(500, $"Internal server error: {ex.Message}");
        //    }
        //}
    }
}
