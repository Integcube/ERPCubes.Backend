using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.DocumentLibrary.Queries.GetDocumentLibrary;
using ERPCubesApi.Services;
using MediatR;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Drawing.Imaging;
using System.Text;

[ApiController]
[Route("[controller]")]
public class DocumentLibraryController : ControllerBase
{



    private readonly IMediator _mediator;
    public DocumentLibraryController(IMediator mediator)
    {
        _mediator = mediator;
    }


    [HttpPost("all", Name = "GetAllDocuments")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    public async Task<ActionResult<List<GetDocumentLibraryVm>>> GetAllCategories(GetDocumentLibraryQuery getDocument)
    {
        var dtos = await _mediator.Send(getDocument);
        return Ok(dtos);
    }
    //private readonly FileServerService _fileServerService;


    //[HttpPost("GetFile")]
    //public async Task<IActionResult> GetFile(IFormFile file, int tenantId)
    //{
    //    try
    //    {
    //        var url = "https://localhost:7046/api/FileServer/SaveFile";

    //        using var httpClient = new HttpClient();

    //        // Consider using POST method and sending the file data
    //        // Example:
    //        // var content = new MultipartFormDataContent();
    //        // content.Add(new StreamContent(file.OpenReadStream()), "file", file.FileName);
    //        // var response = await httpClient.PostAsync(url, content);

    //        var response = await httpClient.GetAsync(url);

    //        if (response.IsSuccessStatusCode)
    //        {
    //            // File saved successfully on the file server
    //            return Ok("File saved successfully.");
    //        }
    //        else
    //        {
    //            // Handle the case where the file server request fails
    //            return StatusCode((int)response.StatusCode, "File server error");
    //        }
    //    }
    //    catch (Exception ex)
    //    {
    //        return BadRequest($"Error: {ex.Message}");
    //    }
    //}

}
