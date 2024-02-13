
using ERPCubes.Application.Features.Crm.DocumentLibrary.Command.DeleteDocument;
using ERPCubes.Application.Features.Crm.DocumentLibrary.Command.UpdateDocumentCommand;
using ERPCubes.Application.Features.Crm.DocumentLibrary.Queries.GetDocumentLibrary;
using ERPCubes.Identity.Models;
using MediatR;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using System.Net.Http;
using System.Text;

namespace ERPCubesApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class DocumentLibraryController : ControllerBase
    {
        
        private readonly IMediator _mediator;
        private readonly IConfiguration _configuration;
        private readonly ILogger<DocumentLibraryController> _logger;
        public DocumentLibraryController(IMediator mediator,IConfiguration configuration, ILogger<DocumentLibraryController> logger)
        {
            _mediator = mediator;
            _configuration = configuration;
            _logger = logger;
        }

        [HttpPost("all", Name = "GetAllDocuments")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetDocumentLibraryVm>>> GetAllCategories(GetDocumentLibraryQuery getDocument)
        {
            var dtos = await _mediator.Send(getDocument);
            return Ok(dtos);
        }
        [HttpPost("SaveFile")]
        public async Task<IActionResult> SaveFile(IFormFile file, int tenantId)
        {
            try
            {
                if (file == null || file.Length == 0)
                {
                    return BadRequest("Invalid file");
                }

                using (var memoryStream = new MemoryStream())
                {
                    await file.CopyToAsync(memoryStream);
                    byte[] fileBytes = memoryStream.ToArray();

                    var directApiBaseUrl = _configuration["AppSettings:FileServerUrl"];
                    if (directApiBaseUrl == null)
                    {
                        _logger.LogError("AppSettings:FileServerUrl is not configured.");
                        return BadRequest("Internal server error.");
                    }

                    var saveFileUrl = $"{directApiBaseUrl}/api/FileManagment/savefile?tenantId={tenantId}";

                    using (HttpClient httpClient = new HttpClient())
                    {
                        using (var formData = new MultipartFormDataContent())
                        {
                            var fileContent = new ByteArrayContent(fileBytes);
                            formData.Add(fileContent, "file", file.FileName);
                            var saveFileResponse = await httpClient.PostAsync(saveFileUrl, formData);
                            saveFileResponse.EnsureSuccessStatusCode();
                            var responseContent = await saveFileResponse.Content.ReadAsStringAsync();

                            return Ok(responseContent);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"Error during file upload: {ex.Message}");
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }




        [HttpGet("getfile")]
        public async Task<IActionResult> ReturnFile(string filePath)
        {
            try
            {
                var saveFileUrl = $"{_configuration["AppSettings:FileServerUrl"]}/api/FileManagment/getfile?filePath={Uri.EscapeDataString(filePath)}";
               

                using (HttpClient httpClient = new HttpClient())
                 {
                    var response = await httpClient.GetAsync(saveFileUrl);
                    response.EnsureSuccessStatusCode();

                    var fileBytes = await response.Content.ReadAsByteArrayAsync();
                    var fileStream = new MemoryStream(fileBytes);

                    return File(fileStream, "application/octet-stream", Path.GetFileName(filePath));
                }
            }
            catch (HttpRequestException ex)
            {
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Unexpected error: {ex.Message}");
            }
        }


        [HttpPost("update", Name = "UpdateDocument")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> UpdateDocument(UpdateDocumentCommand updateDocument)
        {
            var dtos = await _mediator.Send(updateDocument);
            return Ok(dtos);
        }

        [HttpPost("delete", Name = "DeleteDocument")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> DeleteDocument(DeleteDocumentCommand deleteDocument)
        {
            var dtos = await _mediator.Send(deleteDocument);
            return Ok(dtos);
        }
    }
}
